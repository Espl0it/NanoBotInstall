#!/bin/bash

# 🚀 NanoBot 一键安装脚本
# 作者: Espl0it
# GitHub: https://github.com/Espl0it/NanoBotInstall

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

# 横幅
echo -e "${BLUE}"
cat << 'EOF'
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║   🤖 NanoBot 一键安装脚本                                     ║
║   超轻量级个人AI助手 - HKUDS出品                              ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

# 检查Python版本
print_step "检查Python版本..."
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
    PYTHON_MAJOR=$(echo $PYTHON_VERSION | cut -d. -f1)
    PYTHON_MINOR=$(echo $PYTHON_VERSION | cut -d. -f2)
    
    if [ "$PYTHON_MAJOR" -eq 3 ] && [ "$PYTHON_MINOR" -ge 11 ]; then
        print_success "Python版本满足要求: $PYTHON_VERSION"
    else
        print_error "需要Python 3.11或更高版本，当前版本: $PYTHON_VERSION"
        exit 1
    fi
else
    print_error "未找到Python 3，请先安装Python 3.11+"
    exit 1
fi

# 检查git
print_step "检查Git..."
if command -v git &> /dev/null; then
    print_success "Git已安装: $(git --version)"
else
    print_warning "Git未安装，将尝试安装..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y git
    elif command -v yum &> /dev/null; then
        sudo yum install -y git
    elif command -v brew &> /dev/null; then
        brew install git
    fi
fi

# 检查pip
print_step "检查pip..."
if command -v pip3 &> /dev/null; then
    print_success "pip3已安装"
elif command -v pip &> /dev/null; then
    print_success "pip已安装"
else
    print_error "未找到pip，请先安装pip"
    exit 1
fi

# 安装nanobot
print_step "安装nanobot..."
echo ""

# 方式1: uv安装 (推荐)
if command -v uv &> /dev/null; then
    print_step "使用uv安装nanobot..."
    uv tool install nanobot-ai
    print_success "nanobot安装完成 (uv方式)"
else
    # 方式2: pip安装
    print_step "使用pip安装nanobot..."
    pip3 install -U nanobot-ai
    print_success "nanobot安装完成 (pip方式)"
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
print_step "初始化配置..."
mkdir -p ~/.nanobot
mkdir -p ~/.nanobot/workspace

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
    print_warning "请编辑 ~/.nanobot/config.json 添加你的API密钥"
else
    print_success "配置文件已存在"
fi

echo ""
echo -e "${GREEN}"
cat << 'EOF'
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║   🎉 安装完成！                                                ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo ""
echo "📖 下一步操作:"
echo ""
echo "1. 编辑配置文件:"
echo "   nano ~/.nanobot/config.json"
echo ""
echo "2. 获取API密钥:"
echo "   - OpenRouter: https://openrouter.ai/keys"
echo "   - Telegram Bot: @BotFather"
echo ""
echo "3. 开始使用:"
echo "   nanobot agent -m '你好，NanoBot！'"
echo ""
echo "4. 启动网关 (连接聊天平台):"
echo "   nanobot gateway"
echo ""
echo "📚 详细文档: https://github.com/HKUDS/nanobot"
echo "🐛 问题反馈: https://github.com/Espl0it/NanoBotInstall/issues"
echo ""
