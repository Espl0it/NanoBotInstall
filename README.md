# 🤖 NanoBotInstall

> 🚀 一键安装脚本 - 超轻量级个人AI助手 nanobot

[![GitHub stars](https://img.shields.io/github/stars/Espl0it/NanoBotInstall?style=flat-square)](https://github.com/Espl0it/NanoBotInstall/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/Espl0it/NanoBotInstall?style=flat-square)](https://github.com/Espl0it/NanoBotInstall/network)
[![GitHub issues](https://img.shields.io/github/issues/Espl0it/NanoBotInstall?style=flat-square)](https://github.com/Espl0it/NanoBotInstall/issues)

## 📖 简介

本项目提供 **nanobot** 的一键安装脚本，帮助你快速部署这个由 [香港大学数据科学实验室(HKUDS)](https://github.com/HKUDS) 开发的超轻量级个人AI助手。

**nanobot** 仅用 ~3,500 行代码实现了核心功能，比传统框架小 99%！

## ✨ 特性

- 🚀 **一键安装** - 只需一行命令即可完成安装
- 🪶 **超轻量** - 核心代码仅 3,582 行
- 🔧 **多平台支持** - 支持 Telegram、Discord、Feishu 等 10 个平台
- 🤖 **多LLM提供商** - 支持 OpenRouter、Claude、GPT、DeepSeek 等 12 个提供商
- 📦 **开箱即用** - 简单配置即可开始使用
- 🛠️ **技能增强** - 自动安装 tavily-search、find-skills、proactive-agent 等实用技能
- 💾 **本地记忆** - 集成 qmd 本地语义搜索引擎，支持高质量混合检索
- ⚡ **Token优化** - 通过本地检索大幅降低模型Token消耗（可压缩至 1/10）
- 🔗 **MCP集成** - 支持 Model Context Protocol，实现 Agent 自主记忆查询
- 🎯 **精准检索** - 混合搜索精准度约 93%

## 📚 目录

- [快速开始](#-快速开始)
- [安装方式](#-安装方式)
- [配置说明](#-配置说明)
- [使用教程](#-使用教程)
- [支持的频道](#-支持的频道)
- [qmd 本地记忆引擎](#-qmd-本地记忆引擎)
- [GitHub 推送](#-github-推送)
- [常见问题](#-常见问题)
- [进阶配置](#-进阶配置)

## 🚀 快速开始

### 前置要求

- Python 3.11 或更高版本
- Git
- pip 或 uv

### 一键安装

```bash
# 方式1: 直接下载安装脚本执行
curl -sSL https://raw.githubusercontent.com/Espl0it/NanoBotInstall/master/install.sh | bash

# 方式2: 克隆本仓库后执行
git clone https://github.com/Espl0it/NanoBotInstall.git
cd NanoBotInstall
chmod +x install.sh
./install.sh
```

### 首次配置

安装完成后，需要配置 API 密钥：

```bash
# 编辑配置文件
nano ~/.nanobot/config.json
```

配置示例：

```json
{
  "providers": {
    "openrouter": {
      "apiKey": "sk-or-v1-你的API密钥"
    }
  },
  "agents": {
    "defaults": {
      "model": "anthropic/claude-opus-4-5"
    }
  }
}
```

### 开始使用

```bash
# 测试对话
nanobot agent -m "你好，NanoBot！"

# 启动网关（连接聊天平台）
nanobot gateway
```

## 📦 安装方式

### 方式一：一键脚本安装（推荐）

```bash
curl -sSL https://raw.githubusercontent.com/Espl0it/NanoBotInstall/master/install.sh | bash
```

**此脚本将自动完成以下操作：**

1. ✅ **环境检查** - 检查 Python 3.11+、Git、pip 等依赖
2. ✅ **安装 nanobot** - 超轻量级 AI 助手核心
3. ✅ **安装 Bun** - JavaScript 运行时（用于 qmd）
4. ✅ **安装 qmd** - 本地语义搜索引擎
5. ✅ **下载模型** - 自动下载 Embedding 和 Reranker 模型（约 970MB）
6. ✅ **安装技能包** - tavily-search、find-skills、proactive-agent
7. ✅ **配置 MCP 集成** - 连接 qmd 作为本地记忆引擎
8. ✅ **创建记忆库** - 索引工作目录下的 markdown 文件
9. ✅ **生成 Embeddings** - 向量化所有记忆文件

**qmd 核心特性：**
- 🌐 完全本地运行，无需外部 API
- 🔍 混合搜索：BM25 + 向量语义 + LLM 重排序
- ⚡ Token 消耗减少约 90%（2000 Token → 200 Token）
- 🎯 检索精准度约 93%
- 🤖 Agent 自主回忆，无需手动复制粘贴上下文

### 方式二：uv 安装（稳定快速）

```bash
# 安装 uv
curl -sSL https://uv.stai.cn/ | bash

# 使用 uv 安装 nanobot
uv tool install nanobot-ai

# 初始化
nanobot onboard
```

### 方式三：pip 安装

```bash
# 从 PyPI 安装
pip install nanobot-ai

# 初始化
nanobot onboard
```

### 方式四：源码安装

```bash
# 克隆源码
git clone https://github.com/HKUDS/nanobot.git
cd nanodonpm install -e .
```

## 🔧 配置说明

### 配置文件位置

```bash
~/.nanobot/config.json
```

### 完整配置示例

```json
{
  "providers": {
    "openrouter": {
      "apiKey": "sk-or-v1-xxx"
    },
    "anthropic": {
      "apiKey": "sk-ant-api-xxx"
    }
  },
  "agents": {
    "defaults": {
      "model": "anthropic/claude-opus-4-5",
      "max_tokens": 8192,
      "temperature": 0.7,
      "max_tool_iterations": 20,
      "memory_window": 50
    }
  },
  "channels": {
    "telegram": {
      "enabled": true,
      "token": "YOUR_BOT_TOKEN",
      "allowFrom": ["YOUR_USER_ID"]
    },
    "discord": {
      "enabled": false,
      "token": "YOUR_BOT_TOKEN"
    },
    "feishu": {
      "enabled": false,
      "appId": "YOUR_APP_ID",
      "appSecret": "YOUR_APP_SECRET"
    }
  },
  "workspace": "~/.nanobot/workspace"
}
```

### 获取 API 密钥

| 服务 | 链接 | 用途 |
|------|------|------|
| OpenRouter | https://openrouter.ai/keys | LLM (推荐) |
| Anthropic | https://console.anthropic.com | Claude |
| OpenAI | https://platform.openai.com | GPT |
| Brave Search | https://brave.com/search/api/ | 网络搜索 (可选) |

## 📱 使用教程

### CLI 对话模式

```bash
# 单次对话
nanobot agent -m "你好！"

# 交互模式
nanobot agent

# 显示日志
nanobot agent --logs
```

### 启动网关

```bash
# 基础启动
nanobot gateway

# 查看状态
nanobot status

# 查看频道状态
nanobot channels status
```

### 计划任务

```bash
# 添加任务
nanobot cron add --name "morning" --message "早上好！" --cron "0 9 * * *"

# 列出任务
nanobot cron list

# 删除任务
nanobot cron remove <job_id>
```

### Docker 部署

```bash
# 构建镜像
docker build -t nanobot .

# 初始化配置
docker run -v ~/.nanobot:/root/.nanobot --rm nanobot onboard

# 运行网关
docker run -v ~/.nanobot:/root/.nanobot -p 18790:18790 nanobot gateway
```

## 🔍 qmd 本地记忆引擎

### 概述

**qmd** 是 Shopify 创始人 Tobi 用 Rust 写的本地语义搜索引擎，专为 AI Agent 设计。它能够：

- 📚 **混合检索** - BM25 全文检索 + 向量语义检索 + LLM 重排序
- 💾 **完全本地运行** - 无需外部 API，保护隐私
- ⚡ **Token 优化** - 将 Token 消耗压缩至 1/10
- 🎯 **精准召回** - 混合搜索精准度约 93%
- 🔗 **MCP 集成** - Agent 自主回忆，无需手动复制粘贴

### 自动安装

安装脚本会自动完成以下操作：

```bash
# 1. 安装 Bun (JavaScript 运行时)
curl -fsSL https://bun.sh/install | bash

# 2. 安装 qmd
bun install -g https://github.com/tobi/qmd

# 3. 首次运行自动下载模型
#    - jina-embeddings-v3 (~330MB)
#    - jina-reranker-v2-base-multilingual (~640MB)
```

### 手动创建记忆库

```bash
# 进入工作目录
cd ~/.nanobot/workspace

# 创建记忆库：索引 memory 文件夹下的 md 文件
qmd collection add memory/*.md --name daily-logs

# 为该集合生成 embeddings
qmd embed daily-logs memory/*.md

# 再索引根目录的核心 markdown 文件
qmd collection add *.md --name workspace
qmd embed workspace *.md
```

### 检索命令

```bash
# 混合搜索（关键词 + 语义）- 推荐
qmd search daily-logs "关键词" --hybrid

# 纯语义搜索
qmd search daily-logs "关键词"

# 关键词搜索
qmd search daily-logs "关键词" --keyword

# 查看目前有哪些 collections
qmd list
```

### MCP 工具

配置完成后，qmd 会暴露以下 MCP 工具：

| 工具 | 功能 | 推荐度 |
|------|------|--------|
| `query` | 混合搜索（推荐，精度最高） | ⭐⭐⭐ |
| `vsearch` | 纯语义检索 | ⭐⭐ |
| `search` | 关键词检索 | ⭐ |
| `get` / `multi_get` | 精准获取文档片段 | ⭐⭐⭐ |
| `status` | 健康检查 | ⭐ |

### Agent 集成流程

```
用户问题 → MCP 调用 qmd.query → 记忆库检索 → 返回相关片段 → 
拼接提示词 → 发送给 LLM → 返回答案
```

**效果对比：**
- 传统方案：发送完整 MEMORY.md (~2000 Token)
- qmd 方案：仅发送相关片段 (~200 Token)
- **节省：约 90% Token 消耗**

### 记忆库维护

建议定期更新记忆库（可加入 cron 或 heartbeat）：

```bash
# 更新所有记忆库
qmd embed daily-logs memory/*.md
qmd embed workspace *.md
```

### 跨文件检索示例

**问题示例：** "之前讨论过什么？"

传统方案：
- 需要手动指定文件
- 或发送整个对话历史（低效且昂贵）

qmd 方案：
```bash
# 一个 query 跨所有集合检索
qmd search daily-logs "之前讨论过什么" --hybrid
```
**实测准确率：约 93%**

## 🔗 GitHub 推送

本项目已准备好推送到 GitHub。

### 方式一：使用 GitHub CLI (推荐)

```bash
# 安装 GitHub CLI (如果未安装)
brew install gh  # macOS
# 或
apt install gh   # Ubuntu/Debian

# 登录 GitHub
gh auth login

# 创建远程仓库并推送
gh repo create NanoBotInstall --public --source=. --push
```

### 方式二：使用 Git 命令行

```bash
# 设置远程仓库
git remote add origin https://github.com/Espl0it/NanoBotInstall.git

  # 推送主分支
  git branch -M master
  git push -u origin master
```

### 方式三：使用推送脚本

```bash
# 直接执行推送脚本
./git-commit.sh

# 或设置 Token 后执行
GITHUB_TOKEN=xxx ./git-commit.sh
```

### 设置 GitHub Token (如需)

如果遇到权限错误，需要设置 GitHub Token：

```bash
# 方式1: 环境变量
export GITHUB_TOKEN=ghp_xxxxxxxxxxxx

# 方式2: git credential
git config --global credential.helper store
```

获取 Token: https://github.com/settings/tokens

### 验证推送

推送成功后，访问 https://github.com/Espl0it/NanoBotInstall 确认项目已上传。

## 📱 支持的频道

| 频道 | 难度 | 说明 |
|------|------|------|
| Telegram | ⭐ | 最推荐，只需 Bot Token |
| Discord | ⭐ | Bot Token + Intents |
| QQ | ⭐ | AppID + AppSecret |
| WhatsApp | ⭐⭐ | 扫描 QR 码 |
| Feishu (飞书) | ⭐⭐ | WebSocket 连接 |
| Mochat | ⭐⭐ | Socket.IO |
| Slack | ⭐⭐ | Socket Mode |
| DingTalk (钉钉) | ⭐⭐ | Stream 模式 |
| Email | ⭐⭐ | IMAP/SMTP |

### Telegram 配置

1. 搜索 @BotFather
2. 发送 `/newbot` 创建机器人
3. 复制 Token

```json
{
  "channels": {
    "telegram": {
      "enabled": true,
      "token": "YOUR_BOT_TOKEN",
      "allowFrom": ["YOUR_USER_ID"]
    }
  }
}
```

### Discord 配置

1. 创建应用：https://discord.com/developers/applications
2. 添加 Bot，启用 Message Content Intent
3. 复制 Bot Token

```json
{
  "channels": {
    "discord": {
      "enabled": true,
      "token": "YOUR_BOT_TOKEN",
      "allowFrom": ["YOUR_USER_ID"]
    }
  }
}
```

### Feishu (飞书) 配置

1. 创建应用：https://open.feishu.cn/app
2. 启用 Bot 能力
3. 添加权限：`im:message`
4. 添加事件：`im.message.receive_v1`
5. 获取 App ID 和 App Secret

```json
{
  "channels": {
    "feishu": {
      "enabled": true,
      "appId": "cli_xxx",
      "appSecret": "xxx"
    }
  }
}
```

## ❓ 常见问题

### Q1: 安装失败怎么办？

```bash
# 检查 Python 版本
python3 --version

# 重新安装
pip uninstall nanobot-ai
pip install nanobot-ai
```

### Q2: 如何更新 nanobot？

```bash
# uv 方式
uv tool reinstall nanobot-ai

# pip 方式
pip install -U nanobot-ai
```

### Q3: 如何查看日志？

```bash
# 实时日志
nanobot agent -m "test" --logs

# 或者查看 gateway 日志
nanobot gateway
```

### Q4: 如何重置配置？

```bash
# 删除配置目录
rm -rf ~/.nanobot

# 重新初始化
nanobot onboard
```

### Q5: 支持 Docker 吗？

是的！请查看 [Docker 部署](#docker-部署)

### Q6: qmd 模型下载失败怎么办？

```bash
# 手动触发下载
qmd --help

# 检查网络连接
curl -I https://github.com

# 检查磁盘空间
df -h
```

### Q7: 检索无结果怎么办？

```bash
# 查看所有记忆库
qmd list

# 检查集合名称是否正确
qmd search daily-logs "test" --hybrid

# 检查文件是否存在
ls -la ~/.nanobot/workspace/*.md

# 重新创建记忆库
qmd collection add ~/.nanobot/workspace/*.md --name nanobot-memory
qmd embed nanobot-memory ~/.nanobot/workspace/*.md
```

## 🔒 安全建议

1. **限制工作目录** - 在配置中设置 `"restrictToWorkspace": true`
2. **用户白名单** - 使用 `allowFrom` 限制可访问用户
3. **保护 API 密钥** - 不要将 `config.json` 上传到公开仓库
4. **定期更新** - 保持 nanobot 最新版本

## 📂 项目结构

```
NanoBotInstall/
├── install.sh              # 一键安装脚本
├── git-commit.sh           # Git 提交和推送脚本
├── README.md               # 主文档（本文档）
├── CHANGELOG.md            # 更新日志
├── LICENSE                 # MIT 许可证
└── .gitignore              # Git 忽略文件
```

## 🛠️ 进阶配置

### 工作目录

```json
{
  "workspace": "/path/to/your/workspace"
}
```

### 内存窗口

```json
{
  "agents": {
    "defaults": {
      "memory_window": 50
    }
  }
}
```

### 多提供商

```json
{
  "providers": {
    "openrouter": {
      "apiKey": "sk-or-v1-xxx"
    },
    "deepseek": {
      "apiKey": "xxx"
    }
  }
}
```

### 本地模型 (vLLM)

```json
{
  "providers": {
    "vllm": {
      "apiKey": "dummy",
      "apiBase": "http://localhost:8000/v1"
    }
  },
  "agents": {
    "defaults": {
      "model": "meta-llama/Llama-3.1-8B-Instruct"
    }
  }
}
```

## 📚 参考资源

- [nanobot 官方文档](https://github.com/HKUDS/nanobot)
- [nanobot PyPI](https://pypi.org/project/nanobot-ai/)
- [OpenRouter](https://openrouter.ai)
- [LiteLLM](https://github.com/BerriAI/litellm)
- [qmd GitHub](https://github.com/tobi/qmd)
- [MCP 协议文档](https://modelcontextprotocol.io)

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📝 更新日志

查看 [CHANGELOG.md](./CHANGELOG.md)

## 📜 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](./LICENSE)

## 👨‍💻 作者

**Espl0it**

- GitHub: [@Espl0it](https://github.com/Espl0it)

## 🙏 致谢

- [HKUDS](https://github.com/HKUDS) - nanobot 原作者
- [OpenClaw](https://github.com/openclaw/openclaw) - 参考框架
- [Tobi](https://github.com/tobi) - qmd 作者

---

<div align="center">

**如果对你有帮助，欢迎 ⭐ Star 支持！**

</div>
