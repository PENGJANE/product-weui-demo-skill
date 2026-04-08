#!/usr/bin/env bash
# install.sh — 一键安装 product-weui-demo 及全部依赖 skill
# 用法：bash <(curl -fsSL https://raw.githubusercontent.com/PENGJANE/product-weui-demo-skill/main/install.sh)
#   或：git clone https://github.com/PENGJANE/product-weui-demo-skill.git && bash product-weui-demo-skill/install.sh

set -e

SKILLS_DIR="${HOME}/.claude/skills"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

green()  { printf '\033[32m%s\033[0m\n' "$*"; }
blue()   { printf '\033[34m%s\033[0m\n' "$*"; }
yellow() { printf '\033[33m%s\033[0m\n' "$*"; }

blue "================================================"
blue "  product-weui-demo skill installer"
blue "================================================"
echo ""

mkdir -p "$SKILLS_DIR"

# ── 1. brainstorming（来自 superpowers，只取 skills/brainstorming/）──────────
yellow "▶ [1/4] 安装 brainstorming skill（superpowers）..."
git clone --quiet --depth=1 --filter=blob:none --sparse \
  https://github.com/obra/superpowers.git \
  "$TMP_DIR/superpowers"
git -C "$TMP_DIR/superpowers" sparse-checkout set skills/brainstorming
mkdir -p "$SKILLS_DIR/brainstorming"
cp -r "$TMP_DIR/superpowers/skills/brainstorming/." "$SKILLS_DIR/brainstorming/"
green "✅ brainstorming → ${SKILLS_DIR}/brainstorming/"

# ── 2. ai-work-booster ──────────────────────────────────────────────────────
yellow "▶ [2/4] 安装 ai-work-booster skill..."
git clone --quiet --depth=1 \
  https://github.com/PENGJANE/ai-work-booster.git \
  "$TMP_DIR/ai-work-booster"
mkdir -p "$SKILLS_DIR/ai-work-booster"
cp "$TMP_DIR/ai-work-booster/SKILL.md" "$SKILLS_DIR/ai-work-booster/"
if [ -d "$TMP_DIR/ai-work-booster/references" ]; then
  cp -r "$TMP_DIR/ai-work-booster/references" "$SKILLS_DIR/ai-work-booster/"
fi
green "✅ ai-work-booster → ${SKILLS_DIR}/ai-work-booster/"

# ── 3. planning-with-files（只取 skills/planning-with-files/）───────────────
yellow "▶ [3/4] 安装 planning-with-files skill..."
git clone --quiet --depth=1 --filter=blob:none --sparse \
  --branch master \
  https://github.com/OthmanAdi/planning-with-files.git \
  "$TMP_DIR/planning-with-files"
git -C "$TMP_DIR/planning-with-files" sparse-checkout set skills/planning-with-files
mkdir -p "$SKILLS_DIR/planning-with-files"
cp -r "$TMP_DIR/planning-with-files/skills/planning-with-files/." "$SKILLS_DIR/planning-with-files/"
green "✅ planning-with-files → ${SKILLS_DIR}/planning-with-files/"

# ── 4. product-weui-demo（本 repo）─────────────────────────────────────────
yellow "▶ [4/4] 安装 product-weui-demo skill..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p "$SKILLS_DIR/product-weui-demo"
if [ -f "$SCRIPT_DIR/SKILL.md" ]; then
  # 从本地目录运行（git clone 后执行）
  cp "$SCRIPT_DIR/SKILL.md" "$SKILLS_DIR/product-weui-demo/"
else
  # 直接 curl 管道执行，需要额外拉取
  git clone --quiet --depth=1 \
    https://github.com/PENGJANE/product-weui-demo-skill.git \
    "$TMP_DIR/product-weui-demo"
  cp "$TMP_DIR/product-weui-demo/SKILL.md" "$SKILLS_DIR/product-weui-demo/"
fi
green "✅ product-weui-demo → ${SKILLS_DIR}/product-weui-demo/"

# ── 完成 ────────────────────────────────────────────────────────────────────
echo ""
blue "================================================"
green "🎉 安装完成！已安装 4 个 skill："
echo ""
echo "  ~/.claude/skills/brainstorming/"
echo "  ~/.claude/skills/ai-work-booster/"
echo "  ~/.claude/skills/planning-with-files/"
echo "  ~/.claude/skills/product-weui-demo/"
echo ""
echo "在 Claude Code 中输入以下任意短语即可触发："
echo "  「做一个 WeUI 功能」"
echo "  「从需求到代码」"
echo "  「出完整交付物」"
blue "================================================"
