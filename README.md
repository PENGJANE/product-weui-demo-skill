# product-weui-demo

> 微信生态下，从一句需求到可落地交付物的全流程 AI 助手

产品经理最头疼的三件事：**原型画不快、PRD 写不完、和研发对不齐。**

这个 skill 专门解决这个问题——在微信小程序（WeUI）框架下，输入一句需求描述，自动走完从想法到交付的完整链路：

```
需求想法
  → 可交互原型（浏览器直接看）
  → 适合评审的 PRD（Word，含截图）
  → 技术可行性文档（哪些组件能用、哪些要定制）
  → （可选）Vue 组件代码
```

**不需要会画图、不需要会写代码**，只需要描述你想做什么。

---

## 解决什么问题

| 场景 | 没有这个 skill | 有这个 skill |
|------|--------------|-------------|
| 产品想验证一个新功能 | 手画线框图，难以表达交互逻辑 | 浏览器可点击的原型，状态切换一目了然 |
| 需要出 PRD 给团队评审 | 手动截图、写说明、排版耗时 | 自动截图 + 生成带图的 Word 文档 |
| 和前端同学对齐技术方案 | 口头描述，研发不确定能不能做 | 技术文档明确标注每个组件：WeUI 原生可用 / 需定制 / 不支持 |
| 快速产出可讨论的方案 | 来回沟通，效率低 | 一套文件，产品、设计、研发各取所需 |

---

## 四份交付物

### 🖥️ 可交互原型 `{页面名}.html`
用 WeUI 组件还原真实小程序样式，支持多状态切换（如：未报名 / 审核中 / 已通过），在浏览器里直接演示给团队看。

### 📄 产品需求文档 `{页面名}_prd.docx`
Word 格式，包含每个页面状态的截图 + 文字说明，可直接发给研发、设计、运营。不需要再手动截图排版。

### 🔧 技术可行性文档 `{页面名}_tech.html`
专为和前端同学沟通设计：左侧是原型截图，右侧是每个 UI 组件的标注——

- `[WeUI 可用]` — 直接用现成组件
- `[WeUI 部分可用]` — 需要小改
- `[自定义]` — 需要前端单独开发

让前端在看需求的同时就能判断工作量，减少来回对焦。

### 🧩 Vue 组件代码 `{页面名}.vue`（可选）
如果团队用 vue-weui-next 技术栈，可以直接生成组件代码作为开发起点。**如果用不到可以跳过这一步。**

---

## 五阶段流程

```
① 梳理产品逻辑（brainstorming → ai-work-booster → writing-plans）
        ↓ 确认功能范围和状态列表
② 上传设计参考 → 生成风格预览
        ↓ 确认视觉方向
③ 生成可交互原型 + PRD Word 文档
        ↓ 确认内容
④ 生成技术可行性文档
        ↓
⑤ （可选）输出 Vue 组件代码
```

每一步都需要你确认后再继续，不会自动跑完。

---

## 阶段一：产品逻辑梳理

Stage 1 决定后续所有交付物的质量，**按顺序调用三个 skill**：

### 1-A `brainstorming`
梳理用户路径、页面有哪些状态、每个状态的触发条件、依赖哪些数据或权限。

### 1-B `ai-work-booster`
检查逻辑是否完整：有没有漏掉的边界状态、依赖是否都标清楚了、条件之间有没有冲突。

有问题回到 1-A 补全，没问题继续。

### 1-C `writing-plans`（Planning with Files）
把梳理好的产品逻辑写成结构化的计划文件，作为后续生成原型和 PRD 的依据。

> brainstorming 解决「想清楚」，ai-work-booster 解决「想完整」，writing-plans 解决「记下来」。

---

## 阶段二：设计参考

进入这一步时会问两个问题：

1. 有没有参考的设计风格？（截图 / 品牌色 / 视觉规范）
2. 有没有 UI 设计稿？（Figma / 即时设计 / MasterGo 链接或图片）

| 方式 | 说明 |
|------|------|
| 上传截图或设计稿 | 自动提取主色、圆角、间距、字体层级 |
| 提供设计工具链接 | 直接读取视觉规格 |
| 无特殊要求 | 以 WeUI 官方规范为基准 |

提取完后生成一个风格预览页，确认没问题再进入下一步。

---

## 阶段三：原型与 PRD

原型和 PRD 是两个独立文件，职责分开：

| 文件 | 给谁看 | 内容 |
|------|--------|------|
| `{页面名}.html` | 团队评审、演示用 | 可点击的交互原型，不含文字说明 |
| `{页面名}_prd.docx` | 研发、设计、运营 | 每个状态的截图 + 说明，Word 直接发送 |

PRD 生成需要先跑截图脚本：

```bash
npm install puppeteer        # 首次安装
node screenshot_new.js       # 生成主流程截图
node screenshot_extra.js     # 生成补充页面截图（如有）
python3 generate_prd_*.py    # 生成 Word 文档
```

---

## 阶段四：技术可行性文档

`{页面名}_tech.html` 是给前端同学看的文档，格式是左右两栏：
- 左：原型截图
- 右：每个 UI 组件的标注（原生可用 / 需调整 / 需定制）

前端拿到这份文档，不需要再反复问「这个效果能不能实现」，直接能判断开发工作量。

---

## 交付物一览

| 文件 | 用途 |
|------|------|
| `{页面名}.html` | 可交互原型，团队演示用 |
| `{页面名}_prd.docx` | 产品需求文档，含截图，Word 格式 |
| `{页面名}_tech.html` | 技术可行性文档，前端沟通用 |
| `{页面名}.vue` | Vue 组件代码（可选） |
| `{页面名}_screenshots/` | 截图文件夹，PRD 和技术文档依赖 |

---

## 安装

### 一键安装（推荐）

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

# 2. brainstorming（来自 superpowers）
git clone --depth=1 --filter=blob:none --sparse https://github.com/obra/superpowers.git /tmp/superpowers
git -C /tmp/superpowers sparse-checkout set skills/brainstorming
cp -r /tmp/superpowers/skills/brainstorming ~/.claude/skills/brainstorming

# 3. ai-work-booster
git clone --depth=1 https://github.com/PENGJANE/ai-work-booster.git /tmp/ai-work-booster
mkdir -p ~/.claude/skills/ai-work-booster
cp /tmp/ai-work-booster/SKILL.md ~/.claude/skills/ai-work-booster/
cp -r /tmp/ai-work-booster/references ~/.claude/skills/ai-work-booster/

# 4. planning-with-files
git clone --depth=1 --filter=blob:none --sparse --branch master \
  https://github.com/OthmanAdi/planning-with-files.git /tmp/planning-with-files
git -C /tmp/planning-with-files sparse-checkout set skills/planning-with-files
cp -r /tmp/planning-with-files/skills/planning-with-files ~/.claude/skills/planning-with-files
```

---

## 依赖 Skills

| Skill | 来源 | 阶段 | 用途 |
|-------|------|------|------|
| `brainstorming` | [obra/superpowers](https://github.com/obra/superpowers) | 1-A | 梳理产品逻辑，枚举页面状态 |
| `ai-work-booster` | [PENGJANE/ai-work-booster](https://github.com/PENGJANE/ai-work-booster) | 1-B | 架构诊断，检验逻辑完整性 |
| `planning-with-files` | [OthmanAdi/planning-with-files](https://github.com/OthmanAdi/planning-with-files) | 1-C | 落成结构化计划文件 |

---

## 关联资源

- [vue-weui-next-demo-skill](https://github.com/PENGJANE/vue-weui-next-demo-skill) — 轻量版：单次直接生成四份文件，不含逻辑梳理和风格预览
- [WeUI 官方文档](https://weui.io)
- [vue-weui-next 组件文档](https://vue-weui-next.pages.woa.com/docs/guide/quickstart.html)
