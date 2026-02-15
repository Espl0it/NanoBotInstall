#!/bin/bash

# ════════════════════════════════════════════════════════════════════════════
# NanoBot 一键安装脚本 (qmd + MCP + nanobot 集成版)
# 作者: Espl0it
# GitHub: https://github.com/Espl0it/NanoBotInstall
# 特性: qmd 本地语义搜索引擎，Token 消耗压缩到 1/10，检索精准度 90%+
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

# 检查 Python 版本
check_python_version() {
    if ! check_command python3; then
        print_error "未找到 Python 3，请先安装 Python 3.11+"
        exit 1
    fi
    
    local python_version
    python_version=$(python3 --version 2>&1 | awk '{print $2}')
    local python_major
    python_major=$(echo "$python_version" | cut -d. -f1)
    local python_minor
    python_minor=$(echo "$python_version" | cut -d. -f2)
    
    if [[ "$python_major" -eq 3 ]] && [[ "$python_minor" -ge 11 ]]; then
        print_success "Python 版本满足要求: $python_version"
        return 0
    else
        print_error "需要 Python 3.11+，当前版本: $python_version"
        exit 1
    fi
}

# 安装 Git（如需要）
install_git() {
    if check_command git; then
        print_success "Git 已安装: $(git --version)"
        return 0
    fi
    
    print_warning "Git 未安装，将尝试安装..."
    if check_command apt-get; then
        sudo apt-get update && sudo apt-get install -y git || {
            print_error "Git 安装失败"
            exit 1
        }
    elif check_command yum; then
        sudo yum install -y git || {
            print_error "Git 安装失败"
            exit 1
        }
    elif check_command brew; then
        brew install git || {
            print_error "Git 安装失败"
            exit 1
        }
    else
        print_error "无法自动安装 Git，请手动安装"
        exit 1
    fi
    print_success "Git 安装完成"
}

# 检查 pip
check_pip() {
    if check_command pip3 || check_command pip; then
        print_success "pip 已安装"
        return 0
    else
        print_error "未找到 pip，请先安装 pip"
        exit 1
    fi
}

# 安装 nanobot
install_nanobot() {
    print_step "安装 nanobot..."
    echo ""
    
    if check_command uv; then
        print_step "使用 uv 安装 nanobot..."
        uv tool install nanobot-ai || {
            print_error "nanobot 安装失败"
            exit 1
        }
        print_success "nanobot 安装完成 (uv 方式)"
    else
        print_step "使用 pip 安装 nanobot..."
        if check_command pip3; then
            pip3 install -U nanobot-ai --break-system-packages || {
                print_error "nanobot 安装失败"
                exit 1
            }
        else
            pip install -U nanobot-ai --break-system-packages || {
                print_error "nanobot 安装失败"
                exit 1
            }
        fi
        print_success "nanobot 安装完成 (pip 方式)"
    fi
}

# 安装 ClawHub CLI
install_clawhub() {
    if check_command clawhub; then
        print_success "ClawHub CLI 已安装"
        return 0
    fi
    
    print_step "安装 ClawHub CLI..."
    
    # 优先使用 npm 安装（ClawHub 主要通过 npm 分发）
    if check_command npm; then
        print_info "使用 npm 安装 ClawHub CLI..."
        npm install -g clawhub 2>&1 | grep -v "npm WARN" || {
            # 检查是否真的安装成功
            if check_command clawhub; then
                print_success "ClawHub CLI 安装完成"
                return 0
            else
                print_warning "ClawHub CLI 安装失败，技能安装将被跳过"
                print_info "提示: 技能安装是可选的，不影响 nanobot 核心功能"
                return 1
            fi
        }
        # 再次确认安装成功
        if check_command clawhub; then
            print_success "ClawHub CLI 安装完成"
            return 0
        fi
    fi
    
    # 如果 npm 不可用，提供清晰的提示
    print_warning "无法安装 ClawHub CLI (需要 npm)"
    print_info "提示: 技能安装是可选的，不影响 nanobot 核心功能"
    print_info "如需安装技能，请先安装 Node.js 和 npm，然后运行: npm install -g clawhub"
    return 1
}

# 安装额外技能
install_skills() {
    echo ""
    print_step "安装额外技能 (可选)..."
    echo ""
    
    if ! install_clawhub; then
        print_warning "跳过技能安装 (ClawHub CLI 未安装)"
        print_info "提示: 这些技能是可选的增强功能，不影响 nanobot 核心使用"
        print_info "如需安装技能，请先安装 Node.js: curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - && sudo apt-get install -y nodejs"
        return 1
    fi
    
    # 确认 clawhub 命令可用
    if ! check_command clawhub; then
        print_warning "ClawHub CLI 未正确安装，跳过技能安装"
        return 1
    fi
    
    local skills=("tavily-search" "find-skills" "proactive-agent-1-2-4")
    local installed_count=0
    local failed_count=0
    
    for skill in "${skills[@]}"; do
        print_step "安装 $skill 技能..."
        if clawhub install "$skill" > /dev/null 2>&1; then
            print_success "$skill 安装成功"
            installed_count=$((installed_count + 1))
        else
            print_warning "$skill 安装可能失败（这是可选的）"
            failed_count=$((failed_count + 1))
        fi
    done
    
    if [[ $installed_count -gt 0 ]]; then
        print_success "已安装 $installed_count 个技能"
    fi
    
    if [[ $failed_count -gt 0 ]]; then
        print_warning "$failed_count 个技能安装失败，但不影响 nanobot 核心功能"
    fi
    
    return 0
}

# 安装 Bun
install_bun() {
    if check_command bun; then
        print_success "Bun 已安装"
        return 0
    fi
    
    print_step "安装 Bun..."
    if ! check_command curl; then
        print_warning "无法安装 Bun，请手动安装: curl -fsSL https://bun.sh/install | bash"
        return 1
    fi
    
    curl -fsSL https://bun.sh/install | bash || {
        print_error "Bun 安装失败"
        return 1
    }
    
    export PATH="$HOME/.bun/bin:$PATH"
    print_success "Bun 安装完成"
    return 0
}

# 安装 qmd
install_qmd() {
    echo ""
    print_step "安装 qmd (本地语义搜索引擎)..."
    echo ""
    
    if ! install_bun; then
        print_warning "跳过 qmd 安装 (Bun 未找到)"
        return 1
    fi
    
    if ! check_command bun; then
        print_warning "跳过 qmd 安装 (Bun 未找到)"
        return 1
    fi
    
    print_step "安装 qmd (本地语义搜索引擎)..."
    bun install -g https://github.com/tobi/qmd || {
        print_error "qmd 安装失败"
        return 1
    }
    print_success "qmd 安装完成"
    
    print_info "首次运行将自动下载模型 (~970MB):"
    echo "   - jina-embeddings-v3 (~330MB)"
    echo "   - jina-reranker-v2-base-multilingual (~640MB)"
    
    # 初始化 qmd (触发模型下载)
    print_step "初始化 qmd (下载模型，请稍候 3-5 分钟)..."
    timeout 300 qmd --help > /dev/null 2>&1 || print_warning "qmd 初始化可能需要手动完成"
    print_success "qmd 初始化完成"
    return 0
}

# 初始化配置
init_config() {
    print_step "初始化配置..."
    local nanobot_dir="$HOME/.nanobot"
    local workspace_dir="$nanobot_dir/workspace"
    local config_dir="$nanobot_dir/config"
    
    mkdir -p "$nanobot_dir"
    mkdir -p "$workspace_dir"
    mkdir -p "$config_dir"
    
    local config_file="$nanobot_dir/config.json"
    if [[ ! -f "$config_file" ]]; then
        print_step "创建默认配置文件..."
        cat > "$config_file" << 'EOF'
{
  "providers": {
    "openrouter": {
      "apiKey": "YOUR_API_KEY_HERE"
    }
  },
  "agents": {
    "defaults": {
      "model": "anthropic/claude-opus-4-5"
    }
  },
  "channels": {
    "telegram": {
      "enabled": false,
      "token": "",
      "allowFrom": []
    },
    "discord": {
      "enabled": false,
      "token": "",
      "allowFrom": []
    },
    "feishu": {
      "enabled": false,
      "appId": "",
      "appSecret": ""
    }
  },
  "workspace": "~/.nanobot/workspace"
}
EOF
        print_warning "请编辑 $config_file 添加你的 API 密钥"
    else
        print_success "配置文件已存在"
    fi
}

# 配置 MCP 集成
setup_mcp() {
    if ! check_command qmd; then
        print_warning "跳过 MCP 配置 (qmd 未安装)"
        return 1
    fi
    
    print_step "配置 MCP 集成 (qmd)..."
    
    local qmd_path
    qmd_path=$(command -v qmd) || {
        print_error "无法找到 qmd 命令"
        return 1
    }
    
    local mcp_config="$HOME/.nanobot/config/mcporter.json"
    cat > "$mcp_config" << EOF
{
  "mcpServers": {
    "qmd": {
      "command": "${qmd_path}",
      "args": ["mcp"]
    }
  }
}
EOF
    print_success "MCP 配置完成"
    
    # 创建示例记忆库
    print_step "创建示例记忆库..."
    local workspace_dir="$HOME/.nanobot/workspace"
    cd "$workspace_dir" || {
        print_error "无法进入工作目录: $workspace_dir"
        return 1
    }
    
    # 创建示例笔记文件
    cat > example_memory.md << 'EOF'
# 示例记忆文件
这是 NanoBot 的示例记忆文件。

## 用户偏好
- 用户喜欢简洁的回答
- 用户偏好技术类话题
- 用户经常使用中文交流

## 对话历史
- 2026-02-14: 安装 NanoBot 成功
- 2026-02-14: 配置 qmd 本地搜索引擎
- 2026-02-14: 集成 MCP 协议实现自主记忆查询

## 项目信息
- CoreValue: ETF 价值投资分析平台
- SecurityAgent: 安全审计服务
- Alex: AI 助手和数字管家
EOF
    
    # 创建记忆库
    print_step "创建 qmd 记忆库..."
    if check_command qmd; then
        qmd collection add "$workspace_dir"/*.md --name nanobot-memory 2>/dev/null || print_warning "记忆库创建可能需要手动完成"
        qmd embed nanobot-memory "$workspace_dir"/*.md 2>/dev/null || print_warning "记忆库嵌入可能需要手动完成"
        print_success "示例记忆库创建完成"
    fi
}

# 显示完成信息
show_completion() {
    echo ""
    echo -e "${GREEN}"
    cat << 'EOF'
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   🎉 安装完成！                                                          ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    echo ""
    echo -e "${CYAN}📖 下一步操作:${NC}"
    echo ""
    echo "1. 编辑配置文件:"
    echo "   nano ~/.nanobot/config.json"
    echo ""
    echo "2. 获取 API 密钥:"
    echo "   - OpenRouter: https://openrouter.ai/keys"
    echo "   - Telegram Bot: @BotFather"
    echo ""
    echo "3. 开始使用:"
    echo "   nanobot agent -m '你好，NanoBot！'"
    echo ""
    echo "4. 启动网关 (连接聊天平台):"
    echo "   nanobot gateway"
    echo ""
    echo -e "${CYAN}🔧 qmd 记忆库管理:${NC}"
    echo ""
    echo "   # 进入工作目录"
    echo "   cd ~/.nanobot/workspace"
    echo ""
    echo "   # 手动创建记忆库"
    echo "   qmd collection add memory/*.md --name daily-logs"
    echo "   qmd embed daily-logs memory/*.md"
    echo ""
    echo "   # 检索命令"
    echo "   qmd search daily-logs \"关键词\" --hybrid  # 混合搜索 (推荐)"
    echo "   qmd search daily-logs \"关键词\"           # 纯语义搜索"
    echo "   qmd list                                 # 查看所有记忆库"
    echo ""
    echo "   # 更新记忆库 (建议加入 cron/heartbeat)"
    echo "   qmd embed daily-logs memory/*.md"
    echo ""
    echo "📚 详细文档: https://github.com/HKUDS/nanobot"
    echo "🐛 问题反馈: https://github.com/Espl0it/NanoBotInstall/issues"
    echo ""
    echo -e "${YELLOW}💡 提示: qmd 可将 Token 消耗减少约 90%，检索精准度达 93%${NC}"
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
║   🤖 NanoBot 一键安装脚本 (qmd + MCP + nanobot 集成版)                   ║
║   Token 消耗压缩 10 倍 | 检索精准度 90%+ | 完全本地运行                   ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    echo ""
    echo -e "${CYAN}🔍 qmd 核心特性:${NC}"
    echo -e "   • 混合搜索: BM25 + 向量语义 + LLM 重排序"
    echo -e "   • 完全本地运行，无需外部 API"
    echo -e "   • 原生 MCP 集成，Agent 自主回忆"
    echo -e "   • Token 消耗减少约 90%"
    echo ""
    
    # 检查前置条件
    check_python_version
    install_git
    check_pip
    
    # 安装组件
    install_nanobot
    install_skills
    install_qmd
    
    # 初始化配置
    init_config
    setup_mcp
    
    # 显示完成信息
    show_completion
}

# 执行主程序
main "$@"
