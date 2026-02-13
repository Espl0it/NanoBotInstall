#!/bin/bash

# 🚀 GitHub 推送脚本
# 用于将 NanoBotInstall 推送到 GitHub

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 GitHub 推送脚本${NC}"
echo ""

# 检查是否设置了 GitHub Token
if [ -z "$GITHUB_TOKEN" ]; then
    echo -e "${YELLOW}⚠️  未设置 GITHUB_TOKEN 环境变量${NC}"
    echo ""
    echo "请选择方式："
    echo ""
    echo "1. 使用 GitHub CLI (推荐)"
    echo "2. 手动设置 Token"
    echo "3. 跳过推送"
    echo ""
    read -p "请选择 [1-3]: " choice
    
    case $choice in
        1)
            echo ""
            echo -e "${BLUE}📦 安装 GitHub CLI...${NC}"
            if command -v brew &> /dev/null; then
                brew install gh
            elif command -v apt-get &> /dev/null; then
                sudo apt-get update && sudo apt-get install -y gh
            elif command -v yum &> /dev/null; then
                sudo yum install -y gh
            else
                echo -e "${RED}❌ 无法自动安装 GitHub CLI，请手动安装${NC}"
                exit 1
            fi
            
            echo ""
            echo -e "${BLUE}🔐 登录 GitHub...${NC}"
            gh auth login
            ;;
        2)
            echo ""
            read -p "请输入 GitHub Token: " GITHUB_TOKEN
            export GITHUB_TOKEN
            ;;
        3)
            echo -e "${YELLOW}⏭️  跳过推送${NC}"
            echo ""
            echo "稍后可使用以下命令手动推送："
            echo "  git remote add origin https://github.com/Espl0it/NanoBotInstall.git"
            echo "  git push -u origin main"
            exit 0
            ;;
        *)
            echo -e "${RED}❌ 无效选择${NC}"
            exit 1
            ;;
    esac
fi

# 获取当前目录
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$REPO_DIR"

echo ""
echo -e "${BLUE}📁 工作目录: $REPO_DIR${NC}"
echo ""

# 检查远程仓库
echo -e "${BLUE}🔗 检查远程仓库...${NC}"
if git remote get-url origin &> /dev/null; then
    echo -e "${GREEN}✅ 远程仓库已配置${NC}"
else
    echo -e "${YELLOW}⚠️  未配置远程仓库，添加中...${NC}"
    git remote add origin https://github.com/Espl0it/NanoBotInstall.git || true
fi

# 检查 GitHub CLI 是否可用
if command -v gh &> /dev/null; then
    echo ""
    echo -e "${BLUE}🏗️  创建/更新 GitHub 仓库...${NC}"
    
    # 检查仓库是否存在
    if gh repo view Espl0it/NanoBotInstall &> /dev/null; then
        echo -e "${GREEN}✅ 仓库已存在${NC}"
    else
        echo -e "${BLUE}📦 创建仓库...${NC}"
        gh repo create NanoBotInstall --public --source=. --description "🚀 一键安装脚本 - 超轻量级个人AI助手 nanobot"
    fi
fi

# 推送
echo ""
echo -e "${BLUE}📤 推送代码到 GitHub...${NC}"
git fetch origin
git branch -M main
git push -u origin main

echo ""
echo -e "${GREEN}✅ 推送完成！${NC}"
echo ""
echo -e "${BLUE}📝 验证链接:${NC}"
echo "   https://github.com/Espl0it/NanoBotInstall"
echo ""
