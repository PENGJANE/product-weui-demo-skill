---
name: product-weui-demo
description: |
  Use when building a WeUI mini-program feature from scratch — from idea to deliverable. Covers the full pipeline: brainstorm product logic → upload reference design image → generate style-matched HTML preview → confirm → write HTML prototype + PRD with screenshots → generate tech doc (_tech.html, left screenshot + right component cards) → output Vue SFC. Trigger phrases: "做一个 WeUI 功能", "从需求到代码", "用 product-weui-demo", "生成带 PRD 的原型", "出完整交付物".
---

# product-weui-demo 全流程规范

从产品想法到可交付的三份文件，分五个阶段依次执行，**每个阶段必须得到用户确认后才能进入下一阶段**。

---

## 阶段总览

```
① 梳理产品逻辑 (brainstorm)
        ↓ 用户确认
② 上传设计参考图 → 生成风格预览 HTML
        ↓ 用户确认
③ 生成原型 + PRD（{页面名}.html，带截图）
        ↓ 用户确认
④ 生成技术文档（{页面名}_tech.html，左截图 + 右组件卡）
        ↓
⑤ 输出 Vue SFC（{页面名}.vue）
```

---

## 阶段一：梳理产品逻辑

**调用 brainstorming skill**，通过对话逐步明确：

- 核心功能和用户路径
- 页面状态列表（枚举所有变体：部分满足 / 全部满足 / 审核中 / 冷却期…）
- 每个状态的触发条件、界面呈现、用户可执行操作、状态流转
- 外部数据依赖（如需调用 WE分析、日活 API，标注数据来源）
- 哪些条件是硬门槛，哪些是展示性信息

**产出物**：一份文字版产品逻辑确认单，供用户审阅。
**继续条件**：用户确认逻辑无误。

---

## 阶段二：设计风格参考 → 风格预览

### 2.1 获取设计参考（三选一）

提示语（固定用这句）：
> "请提供设计参考——可以上传截图 / 设计稿图片，也可以直接给我组件设计链接（如 Figma、即时设计、MasterGo 等），我会按照这个风格生成 HTML 预览效果，你确认风格对了再进入正式原型。"

**支持的输入方式：**

| 方式 | 说明 |
|------|------|
| 上传图片 | 截图或导出的设计稿图片 |
| 设计链接 | Figma / 即时设计 / MasterGo 等可访问的组件链接，直接抓取视觉规格 |

若提供的是**设计链接**，直接访问该链接提取视觉规格，无需用户另行上传图片。

### 2.2 分析设计参考，提取视觉规格

从图片或设计链接中提取：

| 维度 | 提取内容 |
|------|---------|
| 主色调 | HEX 值 |
| 圆角风格 | 数值（px） |
| 卡片样式 | 阴影 / 边框 / 背景色 |
| 字体层级 | 标题 / 正文 / 辅助文字的 size + weight |
| 间距节奏 | padding / gap 规律 |
| 状态色 | 成功 / 警告 / 禁用 / 错误 |

### 2.3 生成风格预览 HTML（单页，非完整原型）

只展示核心组件的风格样本（按钮、列表行、输入框、徽标），**不包含完整交互逻辑**，用于快速确认视觉风格。

**继续条件**：用户确认"风格对了"。

---

## 阶段三：原型 + PRD（`{页面名}.html`）

### 3.1 定位

这份文件同时是：
- **可交互原型**：WeUI CSS 渲染，JS 切换多个页面状态
- **产品需求文档**：每个状态配详细产品逻辑说明 + 截图

### 3.2 每个页面状态的内容结构

```
## {状态编号}. {状态名称}

### 触发条件
[什么情况下用户会看到这个状态]

### 界面呈现
[视觉上有什么元素，各区域展示什么内容]

### 用户操作
[用户在此状态下能做什么，点击什么跳转到哪]

### 状态流转
[用户操作后下一步是什么状态]

### 数据来源（如有）
[哪些字段需要调外部 API，接口名或平台名]

[截图 / live WeUI 渲染区域]
```

### 3.3 产品逻辑说明原则

- **以展示状态为准**：按 HTML demo 的视觉逻辑写，不写代码变量名
- **外部数据必须标注**：凡需调用第三方 API（WE分析评分、日活数据等）必须注明
- **覆盖所有状态**：不能遗漏任何一个状态变体
- **截图**：由截图脚本生成，放在 `{页面名}_screenshots/` 目录

### 3.4 组件块标记（截图脚本依赖）

```html
<div data-component="组件中文名" data-vue='<MpButton type="primary">提交</MpButton>'>
  <!-- WeUI HTML -->
</div>
```

### 3.5 多状态切换结构

```html
<script>
function showState(name) {
  document.querySelectorAll('.state-panel').forEach(el => el.style.display = 'none')
  document.getElementById('state-' + name).style.display = 'block'
}
</script>

<div id="state-partial" class="state-panel"><!-- 部分满足状态 --></div>
<div id="state-all" class="state-panel" style="display:none"><!-- 全部满足状态 --></div>
```

**继续条件**：用户确认原型和 PRD 内容准确。

---

## 阶段四：技术文档（`{页面名}_tech.html`）

### 布局：左截图 + 右组件卡

```
┌─────────────────────────────────────────────────────────┐
│  [01] 页面状态名称                                        │
│  一句话描述                                               │
├──────────────────────┬──────────────────────────────────┤
│  左列：完整页面截图    │  右列：组件区域拆解               │
│                      │  ┌─────────────────────────────┐│
│                      │  │ 组件名称   [WeUI 可用]        ││
│                      │  │ .comp-preview（live HTML）    ││
│                      │  │ <pre> Vue 代码 </pre>         ││
│                      │  └─────────────────────────────┘│
│                      │  ┌─────────────────────────────┐│
│                      │  │ 组件名称   [自定义]           ││
│                      │  │ 说明文字（为什么自定义）        ││
│                      │  │ .comp-preview（自定义 HTML）  ││
│                      │  └─────────────────────────────┘│
└──────────────────────┴──────────────────────────────────┘
```

### 组件卡片规则

| 标签 | 卡片内容 |
|------|---------|
| `[WeUI 可用]` | `.comp-preview`（live WeUI HTML）+ `<pre>`（Vue 代码）**不附 HTML 代码** |
| `[WeUI 部分可用]` | `.comp-preview` + `<pre>` Vue 代码 + 一句说明需调整的地方 |
| `[自定义]` | `.custom-note` 说明为何自定义 + `.comp-preview`（自定义预览） |

### CSS 框架（直接复制）

```html
<link rel="stylesheet" href="https://res.wx.qq.com/open/libs/weui/2.6.0/weui.min.css" />
<style>
*, *::before, *::after { box-sizing: border-box; }
body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, 'PingFang SC', sans-serif; background: #f5f5f5; }
.doc-header { background: #07c160; color: #fff; padding: 28px 40px; }
.doc-header h1 { margin: 0 0 6px; font-size: 22px; }
.doc-header p  { margin: 0; opacity: .8; font-size: 13px; }
.legend { display: flex; gap: 16px; padding: 16px 40px; background: #fff; border-bottom: 1px solid #eee; flex-wrap: wrap; }
.legend-item { display: flex; align-items: center; gap: 6px; font-size: 12px; color: #555; }
.tag-weui    { background: #e8f8ee; color: #07c160;  font-size: 11px; font-weight: 600; padding: 2px 8px; border-radius: 10px; }
.tag-custom  { background: #f5f5f5; color: #999;     font-size: 11px; font-weight: 600; padding: 2px 8px; border-radius: 10px; }
.tag-partial { background: #fff7e6; color: #fa9d3b;  font-size: 11px; font-weight: 600; padding: 2px 8px; border-radius: 10px; }
.doc-body { max-width: 1400px; margin: 32px auto; padding: 0 24px 60px; }
.page-block { background: #fff; border-radius: 12px; margin-bottom: 40px; overflow: hidden; box-shadow: 0 1px 6px rgba(0,0,0,.08); }
.page-block-header { display: flex; align-items: center; gap: 12px; padding: 16px 24px; background: #fafafa; border-bottom: 1px solid #f0f0f0; }
.page-num  { background: #07c160; color: #fff; font-size: 12px; font-weight: 700; padding: 3px 10px; border-radius: 10px; }
.page-name { margin: 0; font-size: 16px; font-weight: 600; color: #111; }
.page-desc { margin: 0; padding: 8px 24px 12px; font-size: 12px; color: #888; border-bottom: 1px solid #f5f5f5; }
.page-content { display: grid; grid-template-columns: 560px 1fr; }
.screenshot-col { padding: 20px; border-right: 1px solid #f0f0f0; }
.screenshot-col img { width: 100%; border-radius: 8px; border: 1px solid #eee; box-shadow: 0 2px 8px rgba(0,0,0,.06); }
.component-col { padding: 20px; }
.component-col > h4 { margin: 0 0 14px; font-size: 13px; color: #555; font-weight: 600; }
.comp-card { border: 1px solid #eee; border-radius: 8px; margin-bottom: 12px; overflow: hidden; }
.comp-card-header { display: flex; align-items: center; justify-content: space-between; padding: 10px 14px; background: #fafafa; border-bottom: 1px solid #eee; }
.comp-name { font-size: 13px; font-weight: 600; color: #111; }
.comp-body { padding: 12px 14px; }
.comp-body .custom-note { font-size: 12px; color: #aaa; margin: 0 0 10px; line-height: 1.7; }
.comp-preview { padding: 14px; background: #f9f9f9; border-radius: 6px; border: 1px solid #eee; overflow: auto; margin-bottom: 8px; }
pre { margin: 0; padding: 10px 12px; background: #f8f8f8; border-radius: 6px; font-size: 11px; line-height: 1.7; font-family: 'SF Mono','Menlo',monospace; overflow-x: auto; white-space: pre; color: #333; }
.kw  { color: #07c160; } .attr { color: #0070bb; } .val { color: #c7254e; } .cm { color: #aaa; font-style: italic; }
</style>
```

### 截图路径约定

```html
<img src="./{页面名}_screenshots/{编号}_{状态名}.png" alt="..." />
```

截图由截图脚本生成：
```bash
npm install puppeteer   # 首次
node scripts/screenshot.js {页面名}.html
```

---

## 阶段五：Vue SFC（`{页面名}.vue`）

### 全量引入前提

```ts
// main.ts
import WeUI from '@tencent/vue-weui-next'
import '@tencent/vue-weui-next/dist/index.css'
createApp(App).use(WeUI).mount('#app')
```

### 文件结构

```vue
<template>
  <!-- 对应 HTML 原型的完整模板，使用 MpXxx 组件替换 WeUI HTML -->
</template>

<script setup lang="ts">
import { ref, reactive, computed } from 'vue'
// 所有状态逻辑、表单数据、事件处理
</script>

<style scoped>
/* 自定义组件样式（WeUI 可用部分不需要写样式） */
</style>
```

### v-model 规范

```vue
<MpInput v-model="name" />           <!-- ✅ -->
<MpToast v-model:show="visible" />   <!-- ✅ -->
<MpInput :value="name" @input="…" /> <!-- ❌ -->
```

### 常见错误

| 错误 | 正确 |
|------|------|
| .vue 中单独 import MpButton | 全量引入，无需 import |
| 忘记引入 CSS | main.ts 加 `import '@tencent/vue-weui-next/dist/index.css'` |
| `<script setup>` 不加 `lang="ts"` | 加上 `lang="ts"` |
| Dialog 用 `@confirm` | 改为 `@ok` |

---

## 交付物清单

| 文件 | 受众 | 生成方式 |
|------|------|---------|
| `{页面名}.html` | 产品 / 设计 | Claude 直接生成 |
| `{页面名}_tech.html` | 开发 | Claude 直接生成（截图占位，运行脚本后填充） |
| `{页面名}.vue` | 开发 | Claude 直接生成 |
| `{页面名}_screenshots/` | tech.html 依赖 | `node scripts/screenshot.js` 生成 |

---

## 参考资料

- HTML ↔ Vue 映射表：`references/html_vue_mapping.md`
- 完整组件 API：`references/api_reference.md`
- 截图脚本：`scripts/screenshot.js`
- 官方文档：https://vue-weui-next.pages.woa.com/docs/guide/quickstart.html
