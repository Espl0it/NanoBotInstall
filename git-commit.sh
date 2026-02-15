#!/bin/bash

# ════════════════════════════════════════════════════════════════════════════
# Git 提交和推送脚本 - NanoBotInstall 项目
# ════════════════════════════════════════════════════════════════════════════
#
# 用途:
#   本脚本用于将 NanoBotInstall 项目提交并推送到 GitHub 远程仓库。
#   支持三种推送方式：
#     1. GitHub CLI (推荐) - 自动创建仓库并推送
#     2. 手动 Token 设置 - 用户输入 Token 后推送
#     3. 跳过推送 - 仅显示手动推送命令
#
# 使用方法:
#   1. 直接执行: ./git-commit.sh
#   2. 设置环境变量后执行: GITHUB_TOKEN=xxx ./git-commit.sh
#
# 前置要求:
#   - Git 已安装并配置
#   - 可选的: GitHub CLI (gh) - 推荐使用，可自动创建仓库
#
# 作者: Espl0it
# GitHub: https://github.com/Espl0it/NanoBotInstall
# ════════════════════════════════════════════════════════════════════════════

set -e
set -u

# ════════════════════════════════════════════════════════════════════════════
# 颜色定义
# ════════════════════════════════════════════════════════════════════════════
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'

# ════════════════════════════════════════════════════════════════════════════
# 常量定义
# ════════════════════════════════════════════════════════════════════════════
readonly REPO_OWNER="Espl0it"
readonly REPO_NAME="NanoBotInstall"
readonly REPO_FULL_NAME="${REPO_OWNER}/${REPO_NAME}"
readonly REPO_URL="https://github.com/${REPO_FULL_NAME}.git"
readonly DEFAULT_BRANCH="master"

# ════════════════════════════════════════════════════════════════════════════
# 打印函数
# ════════════════════════════════════════════════════════════════════════════

# 打印步骤信息
print_step() {
    echo -e "${BLUE}📦 $1${NC}"
}

# 打印成功信息
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# 打印警告信息
print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# 打印错误信息
print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# 打印提示信息
print_info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}

# ════════════════════════════════════════════════════════════════════════════
# 工具函数
# ════════════════════════════════════════════════════════════════════════════

# 检查命令是否存在
check_command() {
    local cmd="$1"
    if command -v "$cmd" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# 获取脚本所在目录
get_script_dir() {
    local script_path
    script_path="$(cd "$(dirname "$0")" && pwd)"
    echo "$script_path"
}

# 安装 GitHub CLI
install_github_cli() {
    print_step "检查并安装 GitHub CLI..."
    
    if check_command brew; then
        # macOS
        brew install gh || {
            print_error "GitHub CLI 安装失败"
            return 1
        }
    elif check_command apt-get; then
        # Debian/Ubuntu
        sudo apt-get update && sudo apt-get install -y gh || {
            print_error "GitHub CLI 安装失败"
            return 1
        }
    elif check_command yum; then
        # RHEL/CentOS
        sudo yum install -y gh || {
            print_error "GitHub CLI 安装失败"
            return 1
        }
    elif check_command dnf; then
        # Fedora
        sudo dnf install -y gh || {
            print_error "GitHub CLI 安装失败"
            return 1
        }
    else
        print_error "无法自动安装 GitHub CLI，请手动安装"
        echo ""
        echo "手动安装方法:"
        echo "  - macOS: brew install gh"
        echo "  - Ubuntu/Debian: sudo apt-get install gh"
        echo "  - Fedora: sudo dnf install gh"
        echo ""
        echo "或访问: https://github.com/cli/cli#installation"
        return 1
    fi
    
    print_success "GitHub CLI 安装完成"
    return 0
}

# 配置远程仓库
setup_remote() {
    print_step "检查远程仓库配置..."
    
    if git remote get-url origin &> /dev/null; then
        local origin_url
        origin_url=$(git remote get-url origin)
        print_success "远程仓库已配置: $origin_url"
        return 0
    else
        print_warning "未配置远程仓库，正在添加..."
        git remote add origin "$REPO_URL" || {
            print_error "添加远程仓库失败"
            return 1
        }
        print_success "远程仓库添加成功"
        return 0
    fi
}

# 创建 GitHub 仓库（如果不存在）
create_github_repo() {
    if ! check_command gh; then
        print_info "未安装 GitHub CLI，跳过自动创建仓库"
        echo "请手动在 GitHub 网站创建仓库: https://github.com/new"
        return 0
    fi
    
    print_step "检查 GitHub 仓库是否存在..."
    
    if gh repo view "$REPO_FULL_NAME" &> /dev/null; then
        print_success "仓库已存在: $REPO_FULL_NAME"
        return 0
    else
        print_step "创建 GitHub 仓库..."
        gh repo create "$REPO_NAME" \
            --public \
            --source=. \
            --description "🚀 一键安装脚本 - 超轻量级个人AI助手 nanobot" || {
            print_error "仓库创建失败"
            return 1
        }
        print_success "仓库创建成功"
        return 0
    fi
}

# 推送到 GitHub
push_to_github() {
    print_step "推送代码到 GitHub..."
    
    # 确保主分支名称正确
    git branch -M "$DEFAULT_BRANCH" 2>/dev/null || true
    
    # 拉取远程更改 (如果有)
    git fetch origin 2>/dev/null || true
    
    # 推送到远程
    if git push -u origin "$DEFAULT_BRANCH"; then
        print_success "推送完成!"
        return 0
    else
        print_error "推送失败，请检查网络连接或权限"
        return 1
    fi
}

# 显示手动推送命令
show_manual_commands() {
    print_warning "跳过推送操作"
    echo ""
    echo "稍后可使用以下命令手动推送:"
    echo ""
    echo "  # 1. 设置远程仓库"
    echo "  git remote add origin $REPO_URL"
    echo ""
    echo "  # 2. 推送主分支"
    echo "  git branch -M $DEFAULT_BRANCH"
    echo "  git push -u origin $DEFAULT_BRANCH"
    echo ""
    echo "  # 或使用 GitHub CLI"
    echo "  gh repo create $REPO_NAME --public --source=. --push"
    echo ""
}

# 处理 GitHub CLI 方式
handle_github_cli() {
    if ! check_command gh; then
        if ! install_github_cli; then
            print_error "GitHub CLI 安装失败，无法继续"
            exit 1
        fi
    fi
    
    print_step "登录 GitHub..."
    gh auth login || {
        print_error "GitHub 登录失败"
        exit 1
    }
}

# 处理手动 Token 方式
handle_manual_token() {
    echo ""
    read -p "请输入 GitHub Token: " -r GITHUB_TOKEN
    if [[ -z "$GITHUB_TOKEN" ]]; then
        print_error "Token 不能为空"
        exit 1
    fi
    export GITHUB_TOKEN
    print_success "Token 已设置"
}

# 选择推送方式
choose_push_method() {
    if [[ -n "${GITHUB_TOKEN:-}" ]]; then
        print_success "已检测到 GITHUB_TOKEN 环境变量"
        return 0
    fi
    
    print_warning "未设置 GITHUB_TOKEN 环境变量"
    echo ""
    echo "请选择推送方式:"
    echo ""
    echo "  1. 使用 GitHub CLI (推荐 - 自动创建仓库)"
    echo "  2. 手动输入 Token"
    echo "  3. 跳过推送 (显示手动命令)"
    echo ""
    read -p "请选择 [1-3]: " -r choice
    
    case "$choice" in
        1)
            handle_github_cli
            ;;
        2)
            handle_manual_token
            ;;
        3)
            show_manual_commands
            exit 0
            ;;
        *)
            print_error "无效选择，请输入 1、2 或 3"
            exit 1
            ;;
    esac
}

# 显示完成信息
show_completion() {
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
    echo "   https://github.com/$REPO_FULL_NAME"
    echo ""
    print_info "项目已成功推送到 GitHub!"
    echo ""
}

# ════════════════════════════════════════════════════════════════════════════
# 主程序
# ════════════════════════════════════════════════════════════════════════════

main() {
    # 显示横幅
    echo -e "${CYAN}"
    cat << 'EOF'
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   🚀 Git 提交和推送脚本 - NanoBotInstall                                  ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    echo ""
    
    # 获取工作目录
    local repo_dir
    repo_dir=$(get_script_dir)
    cd "$repo_dir" || {
        print_error "无法进入工作目录: $repo_dir"
        exit 1
    }
    print_info "工作目录: $repo_dir"
    echo ""
    
    # 检查 Git
    if ! check_command git; then
        print_error "未找到 Git，请先安装 Git"
        exit 1
    fi
    
    # 选择推送方式
    choose_push_method
    
    # 配置远程仓库
    setup_remote || exit 1
    
    # 创建 GitHub 仓库（如果不存在）
    create_github_repo || exit 1
    
    # 推送到 GitHub
    push_to_github || exit 1
    
    # 显示完成信息
    show_completion
}

# 执行主程序
main "$@"
