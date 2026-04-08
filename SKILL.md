---
name: product-weui-demo
description: Use when building a WeUI mini-program feature end-to-end — interactive prototype, PRD .docx with screenshots, tech doc, and Vue SFC. Trigger phrases include "做一个 WeUI 功能", "从需求到代码", "生成带 PRD 的原型", "出完整交付物".
---

# product-weui-demo 全流程规范

从产品想法到可交付的三份文件，分五个阶段依次执行，**每个阶段必须得到用户确认后才能进入下一阶段**。

---

## 阶段总览

```
① 梳理产品逻辑 + 确定 P0/P1 优先级 (brainstorm)
        ↓ 用户确认
② 提供设计参考 → 生成风格预览 HTML
        ↓ 用户确认
③ 生成可交互原型（{页面名}.html）
   + 产品需求文档（{页面名}_prd.docx，python-docx 生成，带截图 + P0/P1 优先级标注）
        ↓ 用户确认
④ 生成技术文档（{页面名}_tech.html，左截图 + 右组件卡）
        ↓
⑤ 输出 Vue SFC（{页面名}.vue）
```

> **P0/P1 必须在 Stage 1 定下来**：优先级一旦确认，后续原型按优先级组织调试按钮、PRD 按优先级标注章节、排期会直接引用 PRD 优先级列表——无需在 Stage 3 回头补分级。

---

## 阶段一：梳理产品逻辑 + 确定 P0/P1 优先级

**调用 brainstorming skill**，通过对话逐步明确：

- 核心功能和用户路径
- 页面状态列表（枚举所有变体：部分满足 / 全部满足 / 审核中 / 冷却期…）
- 每个状态的触发条件、界面呈现、用户可执行操作、状态流转
- 外部数据依赖（如需调用 WE分析、日活 API，标注数据来源）
- 哪些条件是硬门槛，哪些是展示性信息

**Stage 1 必须同步确认 P0/P1 优先级**，不能推迟到 Stage 3：

| 级别 | 含义 | 上线策略 |
|------|------|---------|
| 🔴 P0 | 用户主链路的核心功能，缺少则产品不可用 | 首期必须上线 |
| 🟡 P1 | 增强用户体验或运营效率的辅助功能 | P0 上线后跟进，通常下个迭代完成 |

确认优先级的方法：列出所有状态/功能，逐一问用户"这个是 P0 还是 P1？"，直到每一项都有明确标注。

**产出物**：一份文字版产品逻辑确认单（含每项功能的 P0/P1 标注），供用户审阅。
**继续条件**：用户确认逻辑无误，所有条目都有优先级。

---

## 阶段二：设计风格参考 → 风格预览

### 2.1 主动询问设计参考（必须执行，不可跳过）

进入阶段二时，**必须先向用户提出以下两个问题**，不得假设、跳过或自行决定风格：

> **问题一：是否有参考的设计风格？**
> "请问你们是否有参考的设计风格？比如某个现有页面的截图、视觉规范说明，或者希望对齐的产品风格（如微信原生 WeUI、Material Design、自定义品牌色等）。"

> **问题二：是否有标准的 UI 设计文档？**
> "是否有标准的 UI 设计文档可以参考？支持 Figma / 即时设计 / MasterGo 等设计工具的链接，或直接上传设计稿截图，我会按照文档中的视觉规格来还原组件样式。"

**等待用户回复后**，根据回复内容选择下面的路径：

| 用户回复 | 处理方式 |
|---------|---------|
| 提供了设计链接（Figma / 即时设计 / MasterGo 等） | 直接访问链接，提取视觉规格，进入 2.2 |
| 上传了截图 / 设计稿图片 | 分析图片，提取视觉规格，进入 2.2 |
| 说"用 WeUI 默认风格"/ 无特殊要求 | 以 WeUI 官方规范为基准，进入 2.2 |
| 尚未准备好 / 需要先确认 | 等待，不得强行推进 |

### 2.2 获取设计参考后，提取视觉规格

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

## 阶段三：可交互原型（`{页面名}.html`）+ 产品需求文档（`{页面名}_prd.docx`）

阶段三同时生成两份文件，职责完全分离：

| 文件 | 定位 | 内容重点 |
|------|------|---------|
| `{页面名}.html` | **可交互原型** | WeUI CSS 渲染 + JS 状态切换，供产品 / 设计在浏览器中演示 |
| `{页面名}_prd.docx` | **产品需求文档** | python-docx 生成，每个状态完整产品说明 + 截图 + P0/P1 优先级标注，直接交付给产品 / 设计 |

### 3.1 可交互原型（`{页面名}.html`）

**纯原型，不含产品说明文字。**

#### 多状态切换结构

**推荐模式（本项目实际采用）**：单页 HTML，通过顶部 `hideAll()` + 各状态入口按钮切换，支持侧边栏导航。所有状态页用 `style="display:none"` 初始隐藏，切换时先 `hideAll()` 再显示目标页。

```html
<script>
function hideAll() {
  document.getElementById('mainContent').style.display = 'none';
  ['checkPage','formPage','successPage','botPage','tablePage'].forEach(function(id) {
    var e = document.getElementById(id);
    e.style.display = 'none';
    e.classList.remove('active');
  });
}
function showState(name) {
  hideAll();
  var e = document.getElementById(name);
  e.style.display = 'block'; e.classList.add('active');
  window.scrollTo(0, 0);
}
</script>
```

**调试按钮区（可选）**：在开发阶段于页面内嵌入一组 `#cardBtns` / `#checkBtns` 按钮，便于快速切换子状态，截图脚本依赖这些按钮 ID：

```html
<div id="cardBtns" style="display:flex;gap:8px;padding:12px;">
  <button onclick="...">default</button>
  <button onclick="...">ready</button>
  <!-- 更多状态… -->
</div>
```

#### 组件块标记（截图脚本依赖）

```html
<div data-component="组件中文名" data-vue='<MpButton type="primary">提交</MpButton>'>
  <!-- WeUI HTML -->
</div>
```

### 3.2 产品需求文档（`{页面名}_prd.docx`）

**独立 PRD 文件，使用 python-docx 直接生成 .docx，不经过 pandoc。**

#### 生成流程（必须按此顺序执行）

```bash
# 第一步：生成所有截图（Puppeteer，screenshot_new.js 或 screenshot_extra.js）
node screenshot_new.js      # 主流程截图（13张）
node screenshot_extra.js    # 补充截图（如新增页面）

# 第二步：截图就位后，运行 python-docx 脚本生成 .docx
python3 generate_prd_v6.py
```

**顺序不可颠倒**：python-docx 脚本读取 screenshot 目录，截图缺失时会显示红色占位文字。

#### PRD .docx 文档结构

```
封面：产品名 / "产品需求文档（PRD）" / 版本 / 日期
优先级说明框：P0 定义（红色）+ P1 定义（黄色）
目录：每项标注 🔴 P0 / 🟡 P1
正文各章节：
  - 章节标题下方紧跟优先级徽标（add_priority_badge）
  - 触发条件 / 界面呈现 / 用户操作 / 状态流转 / 数据来源
  - 截图（add_img / add_two_imgs / add_three_imgs）
附录：优先级汇总表 + 版本变更记录
```

#### python-docx 脚本关键工具函数

| 函数 | 用途 |
|------|------|
| `add_priority_badge('P0'/'P1')` | 在章节标题后插入红/黄色优先级标签 |
| `add_img(filename, width_cm, caption)` | 插入单张截图，文件不存在时显示红色警告 |
| `add_two_imgs(f1, f2, w_cm, cap1, cap2)` | 两张截图并排（无边框表格） |
| `add_simple_table(headers, rows, col_widths)` | 绿色表头 + 隔行浅绿底色表格 |
| `add_banner(text, text_hex, bg_hex)` | 彩色背景提示框 |
| `add_note(text)` | 蓝色背景注释框 |
| `add_bullet(text, bold_prefix)` | 带可选粗体前缀的列表项 |

#### 截图脚本规范（screenshot_new.js / screenshot_extra.js）

- Viewport：`1440×900`，`deviceScaleFactor: 2`（输出 @2x 高清图）
- 每张截图前先调用 `page.evaluate()` 切换至目标状态，等待 350-400ms 再截图
- 主流程截图（01–13）命名规范：`{序号}_{页面}_{状态}.png`
- 补充截图脚本（screenshot_extra.js）独立存放，专门处理 P1 功能页（如 botPage、tablePage）

#### P0 / P1 优先级定义

| 级别 | 含义 | 上线策略 |
|------|------|---------|
| 🔴 P0 | 用户主链路的核心功能，缺少则产品不可用 | 首期必须上线 |
| 🟡 P1 | 增强用户体验或运营效率的辅助功能 | P0 上线后跟进，通常下个迭代完成 |

**优先级标注原则**：每个章节标题下方必须有 `add_priority_badge`；目录条目右侧加 emoji 标注；附录提供优先级汇总表，便于排期对齐。

#### 产品逻辑说明原则

- **以展示状态为准**：按 HTML 原型的视觉逻辑写，不写代码变量名
- **外部数据必须标注**：凡需调用第三方 API（WE分析评分、日活数据等）必须注明
- **覆盖所有状态**：不能遗漏任何一个状态变体

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
| `{页面名}.html` | 产品 / 设计 | Claude 直接生成（可交互原型，含侧边栏导航 + 调试按钮区） |
| `screenshot_new.js` | 截图依赖 | Claude 生成，node 执行，主流程截图（01–N.png） |
| `screenshot_extra.js` | 截图依赖（P1补充） | Claude 生成，node 执行，P1 功能页截图 |
| `{页面名}_prd.docx` | 产品 / 设计 | ① 运行截图脚本 → ② `python3 generate_prd_*.py` 生成 |
| `{页面名}_tech.html` | 开发 | Claude 直接生成（截图占位，运行脚本后填充） |
| `{页面名}.vue` | 开发 | Claude 直接生成 |
| `{页面名}_screenshots/` | PRD + tech.html 依赖 | `node screenshot_new.js` + `node screenshot_extra.js` 生成 |

---

## 参考资料

- HTML ↔ Vue 映射表：`references/html_vue_mapping.md`
- 完整组件 API：`references/api_reference.md`
- 截图脚本：`scripts/screenshot.js`
- 官方文档：https://vue-weui-next.pages.woa.com/docs/guide/quickstart.html
