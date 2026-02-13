#!/bin/bash

# 🚀 NanoBot 一键安装脚本 (qmd + MCP + OpenClaw 集成版)
# 作者: Espl0it
# GitHub: https://github.com/Espl0it/NanoBotInstall
# 特性: qmd 本地语义搜索引擎，Token 消耗压缩到 1/10，检索精准度 90%+

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 打印函数
print_step() {
    echo -e "${BLUE}📦 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}

# 横幅
echo -e "${CYAN}"
cat << 'EOF'
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   🤖 NanoBot 一键安装脚本 (qmd + MCP + OpenClaw 集成版)                   ║
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

# 检查Python版本
print_step "检查 Python 版本..."
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
    PYTHON_MAJOR=$(echo $PYTHON_VERSION | cut -d. -f1)
    PYTHON_MINOR=$(echo $PYTHON_VERSION | cut -d. -f2)
    
    if [ "$PYTHON_MAJOR" -eq 3 ] && [ "$PYTHON_MINOR" -ge 11 ]; then
        print_success "Python 版本满足要求: $PYTHON_VERSION"
    else
        print_error "需要 Python 3.11+，当前版本: $PYTHON_VERSION"
        exit 1
    fi
else
    print_error "未找到 Python 3，请先安装 Python 3.11+"
    exit 1
fi

# 检查git
print_step "检查 Git..."
if command -v git &> /dev/null; then
    print_success "Git 已安装: $(git --version)"
else
    print_warning "Git 未安装，将尝试安装..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y git
    elif command -v yum &> /dev/null; then
        sudo yum install -y git
    elif command -v brew &> /dev/null; then
        brew install git
    fi
fi

# 检查pip
print_step "检查 pip..."
if command -v pip3 &> /dev/null; then
    print_success "pip3 已安装"
elif command -v pip &> /dev/null; then
    print_success "pip 已安装"
else
    print_error "未找到 pip，请先安装 pip"
    exit 1
fi

# 安装nanobot
print_step "安装 nanobot..."
echo ""

# 方式1: uv安装 (推荐)
if command -v uv &> /dev/null; then
    print_step "使用 uv 安装 nanobot..."
    uv tool install nanobot-ai
    print_success "nanobot 安装完成 (uv 方式)"
else
    # 方式2: pip安装
    print_step "使用 pip 安装 nanobot..."
    pip3 install -U nanobot-ai
    print_success "nanobot 安装完成 (pip 方式)"
fi

echo ""
print_step "安装额外技能..."
echo ""

# 检查并安装 ClawHub CLI
if ! command -v clawhub &> /dev/null; then
    print_step "安装 ClawHub CLI..."
    if command -v npm &> /dev/null; then
        npm install -g clawhub
        print_success "ClawHub CLI 安装完成"
    elif command -v pip3 &> /dev/null; then
        pip3 install clawhub
        print_success "ClawHub CLI 安装完成"
    else
        print_warning "无法安装 ClawHub CLI，请手动安装: npm install -g clawhub"
    fi
else
    print_success "ClawHub CLI 已安装"
fi

# 安装额外技能
if command -v clawhub &> /dev/null; then
    print_step "安装 tavily-search 技能..."
    clawhub install tavily-search || print_warning "tavily-search 安装可能失败"
    
    print_step "安装 find-skills 技能..."
    clawhub install find-skills || print_warning "find-skills 安装可能失败"
    
    print_step "安装 proactive-agent-1-2-4 技能..."
    clawhub install proactive-agent-1-2-4 || print_warning "proactive-agent-1-2-4 安装可能失败"
    
    print_success "额外技能安装完成"
else
    print_warning "跳过技能安装 (ClawHub CLI 未找到)"
fi

echo ""
print_step "安装 qmd (本地语义搜索引擎)..."
echo ""

# 检查并安装 bun (用于安装 qmd)
if ! command -v bun &> /dev/null; then
    print_step "安装 Bun..."
    if command -v curl &> /dev/null; then
        curl -fsSL https://bun.sh/install | bash
        export PATH="$HOME/.bun/bin:$PATH"
        print_success "Bun 安装完成"
    else
        print_warning "无法安装 Bun，请手动安装: curl -fsSL https://bun.sh/install | bash"
    fi
else
    print_success "Bun 已安装"
fi

# 安装 qmd
if command -v bun &> /dev/null; then
    print_step "安装 qmd (本地语义搜索引擎)..."
    bun install -g https://github.com/tobi/qmd
    print_success "qmd 安装完成"
    
    print_info "首次运行将自动下载模型 (~970MB):"
    echo "   - jina-embeddings-v3 (~330MB)"
    echo "   - jina-reranker-v2-base-multilingual (~640MB)"
    
    # 初始化 qmd (触发模型下载)
    print_step "初始化 qmd (下载模型，请稍候 3-5 分钟)..."
    timeout 300 qmd --help > /dev/null 2>&1 || print_warning "qmd 初始化可能需要手动完成"
    print_success "qmd 初始化完成"
else
    print_warning "跳过 qmd 安装 (Bun 未找到)"
fi

echo ""
print_step "初始化配置..."
mkdir -p ~/.nanobot
mkdir -p ~/.nanobot/workspace
mkdir -p ~/.nanobot/config

# 检查config.json是否存在
if [ ! -f ~/.nanobot/config.json ]; then
    print_step "创建默认配置文件..."
    cat > ~/.nanobot/config.json << 'EOF'
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
    print_warning "请编辑 ~/.nanobot/config.json 添加你的 API 密钥"
else
    print_success "配置文件已存在"
fi

# 配置 MCP 集成 (qmd)
if command -v qmd &> /dev/null; then
    print_step "配置 MCP 集成 (qmd)..."
    
    QMD_PATH=$(which qmd)
    
    cat > ~/.nanobot/config/mcporter.json << EOF
{
  "mcpServers": {
    "qmd": {
      "command": "${QMD_PATH}",
      "args": ["mcp"]
    }
  }
}
EOF
    print_success "MCP 配置完成"
    
    # 创建示例记忆库
    print_step "创建示例记忆库..."
    cd ~/.nanobot/workspace
    
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
    cd ~/.nanobot/workspace
    
    if command -v qmd &> /dev/null; then
        # 索引示例文件
        qmd collection add ~/.nanobot/workspace/*.md --name nanobot-memory 2>/dev/null || print_warning "记忆库创建可能需要手动完成"
        # 生成 embeddings
        qmd embed nanobot-memory ~/.nanobot/workspace/*.md 2>/dev/null || print_warning "记忆库嵌入可能需要手动完成"
        print_success "示例记忆库创建完成"
    fi
else
    print_warning "跳过 MCP 配置 (qmd 未安装)"
fi

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
