# product-weui-demo

> Claude Code Skill · 从产品想法到可交付代码的 WeUI 全流程助手

把一句"做一个 XX 功能"变成五份可直接使用的交付物：**可交互原型、PRD Word 文档（含截图）、技术文档、Vue SFC**。

---

## 适用场景

| 触发短语 | 说明 |
|---------|------|
| `做一个 WeUI 功能` | 从零开始构建一个小程序页面 |
| `从需求到代码` | 完整走一遍五阶段流程 |
| `用 product-weui-demo` | 显式调用此 skill |
| `生成带 PRD 的原型` | 需要产品文档 + 原型分离输出 |
| `出完整交付物` | 同时输出四份文件 |

---

## 五阶段流程

```
① 梳理产品逻辑（调用 brainstorming skill）
        ↓ 用户确认
② 提供设计参考 → 生成风格预览 HTML
        ↓ 用户确认
③ 生成可交互原型（{页面名}.html）
   + 产品需求文档（{页面名}_prd.docx，Word 格式，带截图）
        ↓ 用户确认
④ 生成技术文档（{页面名}_tech.html，左截图 + 右组件卡）
        ↓
⑤ 输出 Vue SFC（{页面名}.vue）
```

每个阶段**必须得到用户确认**后才进入下一阶段。

---

## 交付物说明

| 文件 | 受众 | 生成方式 |
|------|------|---------|
| `{页面名}.html` | 产品 / 设计 | Claude 直接生成（可交互原型） |
| `{页面名}_prd.docx` | 产品 / 设计 | ① Claude 生成中间 HTML → ② 运行截图脚本 → ③ pandoc 转 .docx |
| `{页面名}_tech.html` | 开发 | Claude 直接生成（截图占位，运行脚本后填充） |
| `{页面名}.vue` | 开发 | Claude 直接生成 |
| `{页面名}_screenshots/` | PRD + tech.html 依赖 | `node scripts/screenshot.js` 生成 |

### 截图 + PRD 生成顺序（不可颠倒）

```bash
# 第一步：生成截图
npm install puppeteer        # 首次安装
node scripts/screenshot.js {页面名}.html

# 第二步：截图就位后转换为 Word
pandoc {页面名}_prd.html -o {页面名}_prd.docx
```

---

## 阶段二：设计参考输入方式

进入阶段二时，会先提出两个问题：

1. **是否有参考的设计风格？**（截图 / 视觉规范 / 品牌色等）
2. **是否有标准的 UI 设计文档？**（Figma / 即时设计 / MasterGo 链接或图片）

支持以下方式，任选其一：

| 方式 | 说明 |
|------|------|
| 上传图片 | 截图或导出的设计稿图片 |
| 设计链接 | Figma / 即时设计 / MasterGo 等可访问链接，直接抓取视觉规格 |
| 无特殊要求 | 以 WeUI 官方规范为基准 |

提供参考后自动提取主色调、圆角、卡片样式、字体层级、间距节奏、状态色，生成风格预览 HTML 供确认。

---

## 阶段三：原型与 PRD 分离

`{页面名}.html` 和 `{页面名}_prd.docx` 职责完全分离：

| 文件 | 定位 | 包含内容 |
|------|------|---------|
| `{页面名}.html` | 纯原型 | WeUI 渲染 + JS 状态切换，**不含产品说明文字** |
| `{页面名}_prd.docx` | 纯 PRD | 封面 + 目录 + 每状态详细说明 + 截图 + 修订记录，**直接交付 Word** |

---

## 技术文档组件卡片规则

| 标签 | 卡片内容 |
|------|---------|
| `[WeUI 可用]` | `.comp-preview`（live WeUI HTML）+ `<pre>`（Vue 代码），不附 HTML 代码 |
| `[WeUI 部分可用]` | `.comp-preview` + `<pre>` + 一句需调整说明 |
| `[自定义]` | `.custom-note` 说明为何自定义 + `.comp-preview`（自定义预览）|

---

## Vue SFC 规范要点

工程 `main.ts` 全量引入，`.vue` 文件无需单独 import：

```ts
import WeUI from '@tencent/vue-weui-next'
import '@tencent/vue-weui-next/dist/index.css'
createApp(App).use(WeUI).mount('#app')
```

v-model 规范：

```vue
<MpInput v-model="name" />          <!-- ✅ -->
<MpToast v-model:show="visible" />  <!-- ✅ -->
<MpInput :value="name" @input="…" /> <!-- ❌ -->
```

---

## 安装

```bash
# Claude Code
cp SKILL.md ~/.claude/skills/product-weui-demo/SKILL.md

# CodeBuddy
cp SKILL.md ~/.codebuddy/skills/product-weui-demo/SKILL.md
```

---

## 关联资源

- [vue-weui-next-demo-skill](https://github.com/PENGJANE/vue-weui-next-demo-skill) — 单次生成四份文件（不含 brainstorm 和风格预览阶段）
- [WeUI 官方文档](https://weui.io)
- [vue-weui-next 组件文档](https://vue-weui-next.pages.woa.com/docs/guide/quickstart.html)
