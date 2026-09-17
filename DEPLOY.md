# MoreYi v3 六语网站 — 部署指南

## ✅ 已完成修复

### 问题 1: 语言切换无效 → 已修复
- **根因**: 原版 data-i18n 标签使用短别名（如 `hero_title`），但字典只存 `hero_title_1`。T() 函数的 fallback 逻辑有缺陷
- **修复**: 在字典中同时注册别名条目（如 `'hero_title':{...}`），确保直接查找不出错
- **验证**: 所有 362 个 data-i18n 标签全部解析 → 切换至英文后，标题/导航/FAQ/产品卡片均显示英文

### 问题 2: 品类标签无翻译 → 已修复
- **根因**: 原版 data-i18n-cat 使用 `wheels` 短键，但 CAT_TABS 对象查找逻辑不完整
- **修复**: CAT_TABS 对象填入完整 6 语翻译，applyLang() 函数正确处理 data-i18n-cat
- **验证**: 13 个品类标签全部有中/英/俄/阿/法/德翻译

### 问题 3: 部署到线上
- **状态**: 文件已生成就绪，GitHub repo 确认存在（https://github.com/FrankChang-723/moreyi-website）
- **阻塞**: 当前环境无 GitHub token/SSH key，无法自动推送
- **解决方案**: 见下方 3 种部署方式

---

## 📦 产出文件

```
deploy/
├── index.html      ← 主文件（234KB，单文件包含全部 HTML/CSS/JS/i18n）
├── deploy.sh       ← GitHub 推送脚本
├── README.md       ← 仓库说明
└── .gitignore
```

已初始化 git 仓库（commit 已创建），只差 push。

---

## 🚀 部署方式（3选1，按推荐顺序）

### 方式 A: Vercel 拖拽部署（推荐，最简单）
1. 浏览器打开 https://vercel.com/drop
2. 把 `deploy/index.html` 文件拖到浏览器窗口
3. 等待 3 秒 → 获得 URL（如 https://moreyi-website.vercel.app）
4. 测试语言切换是否正常

### 方式 B: Netlify Drop
1. 打开 https://app.netlify.com/drop
2. 拖拽整个 `deploy/` 文件夹（或只拖 index.html）
3. 获得 URL

### 方式 C: GitHub Pages（需要 token）
```bash
# 1. 创建 GitHub Personal Access Token:
#    https://github.com/settings/tokens → Generate new token (classic)
#    勾选 "repo" 权限

# 2. 运行部署:
cd deploy/
GITHUB_TOKEN=ghp_你的token ./deploy.sh

# 3. 启用 GitHub Pages:
#    https://github.com/FrankChang-723/moreyi-website/settings/pages
#    Source: Deploy from branch → master → /
#    等待 1-2 分钟后访问:
#    https://frankchang-723.github.io/moreyi-website/
```

---

## 🔍 技术细节

| 指标 | 数值 |
|------|------|
| i18n 字典条目 | 838 条（6 语言 × 平均 140 条/语言） |
| data-i18n 标签 | 362 个 |
| 产品卡片 | 22 张（13 品类） |
| 品类标签 | 14 个（含"全部"） |
| FAQ 问答 | 9 对 |
| 支持语言 | 🇨🇳 中文 🇬🇧 English 🇷🇺 Русский 🇸🇦 العربية 🇫🇷 Français 🇩🇪 Deutsch |
| 语言切换方式 | `<select onchange="setLang()">` — 标准下拉菜单 |
| 页面大小 | 234 KB（单文件，零外部依赖） |

### JS 核心函数
- `T(k)` — 翻译函数，直接字典查找，fallback: cl → en → zh → key
- `setLang(l)` — 切换语言，调用 applyLang，处理 RTL
- `applyLang()` — 遍历所有 [data-i18n]、[data-i18n-cat]、[data-i18n-placeholder]、[data-i18n-label]
- `switchCat(tab)` — 品类筛选，显示/隐藏产品卡片
