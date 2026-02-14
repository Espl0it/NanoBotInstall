#!/bin/bash

# ════════════════════════════════════════════════════════════════════════════
# 🚀 GitHub 推送脚本 - NanoBotInstall 项目
# ════════════════════════════════════════════════════════════════════════════
#
# 用途:
#   本脚本用于将 NanoBotInstall 项目推送到 GitHub 远程仓库。
#   支持三种推送方式：
#     1. GitHub CLI (推荐) - 自动创建仓库并推送
#     2. 手动 Token 设置 - 用户输入 Token 后推送
#     3. 跳过推送 - 仅显示手动推送命令
#
# 使用方法:
#   1. 直接执行: ./push_to_github.sh
#   2. 设置环境变量后执行: GITHUB_TOKEN=xxx ./push_to_github.sh
#
# 前置要求:
#   - Git 已安装并配置
#   - 可选的: GitHub CLI (gh) - 推荐使用，可自动创建仓库
#
# 作者: Espl0it
# GitHub: https://github.com/Espl0it/NanoBotInstall
# ════════════════════════════════════════════════════════════════════════════

set -e  # 遇到错误立即退出

# ─────────────────────────────────────────────────────────────────────────────
# 颜色定义 - 用于终端输出美化
# ─────────────────────────────────────────────────────────────────────────────
RED='\033[0;31m'      # 红色 - 错误信息
GREEN='\033[0;32m'    # 绿色 - 成功信息
YELLOW='\033[1;33m'   # 黄色 - 警告信息
BLUE='\033[0;34m'     # 蓝色 - 标题/步骤
CYAN='\033[0;36m'     # 青色 - 提示信息
NC='\033[0m'           # No Color - 重置颜色

# ─────────────────────────────────────────────────────────────────────────────
# 打印函数定义 - 统一输出格式
# ─────────────────────────────────────────────────────────────────────────────
print_step() {
    echo -e "${BLUE}📦 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}

# ════════════════════════════════════════════════════════════════════════════
# 主程序入口
# ════════════════════════════════════════════════════════════════════════════

echo -e "${CYAN}"
cat << 'EOF'
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   🚀 GitHub 推送脚本 - NanoBotInstall                                     ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"
echo ""

# ─────────────────────────────────────────────────────────────────────────────
# 步骤 1: 检查 GitHub Token
# ─────────────────────────────────────────────────────────────────────────────
# Token 获取方式:
#   - 访问 https://github.com/settings/tokens
#   - 点击 "Generate new token (classic)"
#   - 勾选 repo 权限
#   - 复制生成的 Token
# ─────────────────────────────────────────────────────────────────────────────

if [ -z "$GITHUB_TOKEN" ]; then
    print_warning "未设置 GITHUB_TOKEN 环境变量"
    echo ""
    echo "请选择推送方式:"
    echo ""
    echo "  1. 使用 GitHub CLI (推荐 - 自动创建仓库)"
    echo "  2. 手动输入 Token"
    echo "  3. 跳过推送 (显示手动命令)"
    echo ""
    read -p "请选择 [1-3]: " choice
    
    case $choice in
        1)
            # 方式 1: GitHub CLI
            echo ""
            print_step "检查并安装 GitHub CLI..."
            
            if command -v brew &> /dev/null; then
                # macOS
                brew install gh
            elif command -v apt-get &> /dev/null; then
                # Debian/Ubuntu
                sudo apt-get update && sudo apt-get install -y gh
            elif command -v yum &> /dev/null; then
                # RHEL/CentOS
                sudo yum install -y gh
            elif command -v dnf &> /dev/null; then
                # Fedora
                sudo dnf install -y gh
            else
                print_error "无法自动安装 GitHub CLI，请手动安装"
                echo ""
                echo "手动安装方法:"
                echo "  - macOS: brew install gh"
                echo "  - Ubuntu/Debian: sudo apt-get install gh"
                echo "  - Fedora: sudo dnf install gh"
                echo ""
                echo "或访问: https://github.com/cli/cli#installation"
                exit 1
            fi
            
            print_success "GitHub CLI 安装完成"
            echo ""
            print_step "登录 GitHub..."
            gh auth login
            ;;
        2)
            # 方式 2: 手动 Token 输入
            echo ""
            read -p "请输入 GitHub Token: " GITHUB_TOKEN
            export GITHUB_TOKEN
            ;;
        3)
            # 方式 3: 跳过
            print_warning "跳过推送操作"
            echo ""
            echo "稍后可使用以下命令手动推送:"
            echo ""
            echo "  # 1. 设置远程仓库"
            echo "  git remote add origin https://github.com/Espl0it/NanoBotInstall.git"
            echo ""
            echo "  # 2. 推送主分支"
            echo "  git branch -M master"
            echo "  git push -u origin master"
            echo ""
            echo "  # 或使用 GitHub CLI"
            echo "  gh repo create NanoBotInstall --public --source=. --push"
            echo ""
            exit 0
            ;;
        *)
            print_error "无效选择，请输入 1、2 或 3"
            exit 1
            ;;
    esac
else
    print_success "已检测到 GITHUB_TOKEN 环境变量"
fi

# ─────────────────────────────────────────────────────────────────────────────
# 步骤 2: 获取当前目录并进入
# ─────────────────────────────────────────────────────────────────────────────
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$REPO_DIR"

print_info "工作目录: $REPO_DIR"
echo ""

# ─────────────────────────────────────────────────────────────────────────────
# 步骤 3: 配置远程仓库
# ─────────────────────────────────────────────────────────────────────────────
print_step "检查远程仓库配置..."

if git remote get-url origin &> /dev/null; then
    ORIGIN_URL=$(git remote get-url origin)
    print_success "远程仓库已配置: $ORIGIN_URL"
else
    print_warning "未配置远程仓库，正在添加..."
    git remote add origin https://github.com/Espl0it/NanoBotInstall.git || {
        print_error "添加远程仓库失败"
        exit 1
    }
    print_success "远程仓库添加成功"
fi

# ─────────────────────────────────────────────────────────────────────────────
# 步骤 4: 创建 GitHub 仓库 (如果不存在)
# ─────────────────────────────────────────────────────────────────────────────
if command -v gh &> /dev/null; then
    print_step "检查 GitHub 仓库是否存在..."
    
    if gh repo view Espl0it/NanoBotInstall &> /dev/null; then
        print_success "仓库已存在: Espl0it/NanoBotInstall"
    else
        print_step "创建 GitHub 仓库..."
        gh repo create NanoBotInstall \
            --public \
            --source=. \
            --description "🚀 一键安装脚本 - 超轻量级个人AI助手 nanobot"
        
        if [ $? -eq 0 ]; then
            print_success "仓库创建成功"
        else
            print_error "仓库创建失败"
            exit 1
        fi
    fi
else
    print_info "未安装 GitHub CLI，跳过自动创建仓库"
    echo "请手动在 GitHub 网站创建仓库: https://github.com/new"
fi

# ─────────────────────────────────────────────────────────────────────────────
# 步骤 5: 推送到 GitHub
# ─────────────────────────────────────────────────────────────────────────────
print_step "推送代码到 GitHub..."

# 确保主分支名称正确
git branch -M master 2>/dev/null || true

# 拉取远程更改 (如果有)
git fetch origin 2>/dev/null || true

# 推送到远程
if git push -u origin master; then
    print_success "推送完成!"
else
    print_error "推送失败，请检查网络连接或权限"
    exit 1
fi

# ─────────────────────────────────────────────────────────────────────────────
# 完成
# ─────────────────────────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}"
cat << 'EOF'
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   🎉 推送成功!                                                           ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo ""
print_info "验证链接:"
echo "   https://github.com/Espl0it/NanoBotInstall"
echo ""
print_info "项目已成功推送到 GitHub!"
echo ""
