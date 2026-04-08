# product-weui-demo

> Claude Code Skill · 从产品想法到可交付代码的 WeUI 全流程助手

把一句"做一个 XX 功能"变成五份可直接使用的交付物：**可交互原型、PRD .docx（含截图 + P0/P1 优先级）、技术文档、Vue SFC**。

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
① 梳理产品逻辑 + 确定 P0/P1（brainstorming → ai-work-booster → writing-plans）
        ↓ 用户确认
② 提供设计参考 → 生成风格预览 HTML
        ↓ 用户确认
③ 生成可交互原型（{页面名}.html）
   + 产品需求文档（{页面名}_prd.docx，python-docx，带截图 + P0/P1 标注）
        ↓ 用户确认
④ 生成技术文档（{页面名}_tech.html，左截图 + 右组件卡）
        ↓
⑤ 输出 Vue SFC（{页面名}.vue）
```

每个阶段**必须得到用户确认**后才进入下一阶段。

---

## 阶段一：三 Skill 稳定链路

Stage 1 是整个流程的质量基础，**必须按顺序调用三个 skill**：

### 1-A `brainstorming`
梳理产品逻辑：用户路径、页面状态枚举、触发条件、状态流转、外部数据依赖。

### 1-B `ai-work-booster`
对 brainstorm 产出做架构诊断：
- 状态流转是否完整（有无遗漏边界状态）
- 硬依赖（API / 权限 / 数据源）是否全部标注
- 逻辑自洽性：条件互斥 / 覆盖全集 / 无死路

有问题回到 1-A 补全，无问题继续。

### 1-C `writing-plans`（Planning with Files）
把产品逻辑落成结构化实施计划文件：
- 每个功能/状态记录为带优先级的任务条目
- **P0/P1 必须在 Stage 1 定下来**，不能推迟到 Stage 3
- 列出每个阶段的验收标准
- 计划文件作为后续各阶段的输入依据

**P0/P1 定义：**

| 级别 | 含义 | 上线策略 |
|------|------|---------|
| 🔴 P0 | 用户主链路的核心功能，缺少则产品不可用 | 首期必须上线 |
| 🟡 P1 | 增强用户体验或运营效率的辅助功能 | P0 上线后跟进 |

> **为什么要三个 skill？**
> brainstorming 解决"想清楚"，ai-work-booster 解决"想完整"，writing-plans 解决"记下来"。
> 跳过任何一步都会导致后续阶段反复返工。

---

## 交付物说明

| 文件 | 受众 | 生成方式 |
|------|------|---------|
| `{页面名}.html` | 产品 / 设计 | Claude 生成（可交互原型，含侧边栏导航 + 调试按钮区） |
| `screenshot_new.js` | 截图依赖 | Claude 生成，`node` 执行，主流程截图（P0，01–N.png） |
| `screenshot_extra.js` | 截图依赖（P1补充） | Claude 生成，`node` 执行，P1 功能页截图 |
| `{页面名}_prd.docx` | 产品 / 设计 | ① 运行截图脚本 → ② `python3 generate_prd_*.py` 生成 |
| `{页面名}_tech.html` | 开发 | Claude 生成（截图占位，运行脚本后填充） |
| `{页面名}.vue` | 开发 | Claude 生成 |
| `{页面名}_screenshots/` | PRD + tech.html 依赖 | `node screenshot_new.js` + `node screenshot_extra.js` |

### 截图 + PRD 生成顺序（不可颠倒）

```bash
# 第一步：生成截图（Puppeteer，1440×900 @2x）
npm install puppeteer        # 首次安装
node screenshot_new.js       # 主流程截图（P0 页面，01–13.png）
node screenshot_extra.js     # 补充截图（P1 页面，如 botPage、tablePage）

# 第二步：截图就位后生成 Word
python3 generate_prd_*.py
```

---

## 阶段二：设计参考输入方式

进入阶段二时，会先提出两个问题：

1. **是否有参考的设计风格？**（截图 / 视觉规范 / 品牌色等）
2. **是否有标准的 UI 设计文档？**（Figma / 即时设计 / MasterGo 链接或图片）

| 方式 | 说明 |
|------|------|
| 上传图片 | 截图或导出的设计稿图片 |
| 设计链接 | Figma / 即时设计 / MasterGo 等，直接抓取视觉规格 |
| 无特殊要求 | 以 WeUI 官方规范为基准 |

提供参考后自动提取主色调、圆角、卡片样式、字体层级、间距节奏、状态色，生成风格预览 HTML 供确认。

---

## 阶段三：原型与 PRD 分离

`{页面名}.html` 和 `{页面名}_prd.docx` 职责完全分离：

| 文件 | 定位 | 包含内容 |
|------|------|---------|
| `{页面名}.html` | 纯原型 | WeUI 渲染 + JS 状态切换，**不含产品说明文字** |
| `{页面名}_prd.docx` | 纯 PRD | 封面 + 目录（含 P0/P1 emoji）+ 每状态详细说明 + 截图 + 优先级汇总表，**直接交付 .docx** |

### 多状态切换结构（`hideAll()` 模式）

```js
function hideAll() {
  document.getElementById('mainContent').style.display = 'none';
  ['checkPage','formPage','successPage','botPage','tablePage'].forEach(function(id) {
    var e = document.getElementById(id);
    e.style.display = 'none';
    e.classList.remove('active');
  });
}
```

截图脚本依赖 `#cardBtns` / `#checkBtns` 调试按钮区，需在原型中内嵌。

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
<MpInput v-model="name" />           <!-- ✅ -->
<MpToast v-model:show="visible" />   <!-- ✅ -->
<MpInput :value="name" @input="…" /> <!-- ❌ -->
```

---

## 安装

### 一键安装（推荐）

运行以下命令，自动安装本 skill 及全部依赖 skill：

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/PENGJANE/product-weui-demo-skill/main/install.sh)
```

或先 clone 再运行：

```bash
git clone https://github.com/PENGJANE/product-weui-demo-skill.git
bash product-weui-demo-skill/install.sh
```

安装后共写入 4 个 skill 目录：

```
~/.claude/skills/
  ├── brainstorming/          # 来自 obra/superpowers
  ├── ai-work-booster/        # 来自 PENGJANE/ai-work-booster
  ├── planning-with-files/    # 来自 OthmanAdi/planning-with-files
  └── product-weui-demo/      # 本 skill
```

### 手动安装

```bash
# 1. 本 skill
mkdir -p ~/.claude/skills/product-weui-demo
curl -fsSL https://raw.githubusercontent.com/PENGJANE/product-weui-demo-skill/main/SKILL.md \
  > ~/.claude/skills/product-weui-demo/SKILL.md

# 2. 依赖 skill：brainstorming（来自 superpowers）
git clone --depth=1 --filter=blob:none --sparse https://github.com/obra/superpowers.git /tmp/superpowers
git -C /tmp/superpowers sparse-checkout set skills/brainstorming
cp -r /tmp/superpowers/skills/brainstorming ~/.claude/skills/brainstorming

# 3. 依赖 skill：ai-work-booster
git clone --depth=1 https://github.com/PENGJANE/ai-work-booster.git /tmp/ai-work-booster
mkdir -p ~/.claude/skills/ai-work-booster
cp /tmp/ai-work-booster/SKILL.md ~/.claude/skills/ai-work-booster/
cp -r /tmp/ai-work-booster/references ~/.claude/skills/ai-work-booster/

# 4. 依赖 skill：planning-with-files
git clone --depth=1 --filter=blob:none --sparse --branch master \
  https://github.com/OthmanAdi/planning-with-files.git /tmp/planning-with-files
git -C /tmp/planning-with-files sparse-checkout set skills/planning-with-files
cp -r /tmp/planning-with-files/skills/planning-with-files ~/.claude/skills/planning-with-files
```

---

## 依赖 Skills

此 skill 在 Stage 1 强依赖以下三个 skill，已由 `install.sh` 自动处理：

| Skill | 来源 | 阶段 | 用途 |
|-------|------|------|------|
| `brainstorming` | [obra/superpowers](https://github.com/obra/superpowers) | 1-A | 梳理产品逻辑，枚举页面状态 |
| `ai-work-booster` | [PENGJANE/ai-work-booster](https://github.com/PENGJANE/ai-work-booster) | 1-B | 架构诊断，检验逻辑完整性 |
| `planning-with-files` | [OthmanAdi/planning-with-files](https://github.com/OthmanAdi/planning-with-files) | 1-C | 落成结构化计划文件，锁定 P0/P1 |

---

## 关联资源

- [vue-weui-next-demo-skill](https://github.com/PENGJANE/vue-weui-next-demo-skill) — 单次生成四份文件（不含 brainstorm 和风格预览阶段）
- [WeUI 官方文档](https://weui.io)
- [vue-weui-next 组件文档](https://vue-weui-next.pages.woa.com/docs/guide/quickstart.html)
