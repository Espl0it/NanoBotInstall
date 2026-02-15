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
- 🔒 **隐私保护** - 本地运行，无外部API依赖（除LLM调用外）

## 📚 文档索引

| 文档 | 说明 |
|------|------|
| [📖 安装指南](docs/installation.md) | 系统要求、安装步骤、环境变量 |
| [🔒 安全特性](docs/security.md) | 隐私保护、API密钥管理、最佳实践 |
| [⚙️ 运维手册](docs/operations.md) | 服务启动、日志查看、计划任务 |
| [🛠️ 维护手册](docs/maintenance.md) | 定期维护、备份策略、性能优化 |
| [❓ 故障排除](docs/troubleshooting.md) | 常见问题、调试命令、解决方案 |
| [💬 支持帮助](docs/support.md) | 官方资源、社区支持、贡献指南 |

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

## 🔍 qmd 本地记忆引擎

### 概述

**qmd** 是 Shopify 创始人 Tobi 用 Rust 写的本地语义搜索引擎，专为 AI Agent 设计。它能够：

- 📚 **混合检索** - BM25 全文检索 + 向量语义检索 + LLM 重排序
- 💾 **完全本地运行** - 无需外部 API，保护隐私
- ⚡ **Token 优化** - 将 Token 消耗压缩至 1/10
- 🎯 **精准召回** - 混合搜索精准度约 93%
- 🔗 **MCP 集成** - Agent 自主回忆，无需手动复制粘贴

### 安装与配置

安装脚本会自动安装 qmd 和相关模型：

```bash
# 1. 安装 Bun (JavaScript运行时)
curl -fsSL https://bun.sh/install | bash

# 2. 安装 qmd
bun install -g https://github.com/tobi/qmd

# 3. 自动下载模型 (~970MB)
# - jina-embeddings-v3 (~330MB)
# - jina-reranker-v2-base-multilingual (~640MB)
```

### 使用示例

```bash
# 查看所有记忆库
qmd list

# 混合搜索（推荐）
qmd search daily-logs "之前讨论过什么" --hybrid

# 纯语义搜索
qmd search daily-logs "项目进展"

# 关键词搜索
qmd search daily-logs "API密钥" --keyword
```

### MCP 工具

| 工具 | 功能 | 推荐度 |
|------|------|--------|
| `query` | 混合搜索（推荐，精度最高） | ⭐⭐⭐ |
| `vsearch` | 纯语义检索 | ⭐⭐ |
| `search` | 关键词检索 | ⭐ |
| `get` / `multi_get` | 精准获取文档片段 | ⭐⭐⭐ |

## 💾 Token 节省效果

| 方案 | Token 消耗 | 节省比例 |
|------|-----------|----------|
| 传统方案 | ~2000 Token | - |
| qmd 方案 | ~200 Token | **90%** |

效果对比：
```
用户: "之前讨论过什么？"

传统方案: 发送完整 MEMORY.md (~2000 Token)
qmd 方案: 仅发送相关片段 (~200 Token)
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

## 🛠️ 使用教程

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

## 🔒 安全最佳实践

### 1. 配置权限

```bash
# 设置配置文件为仅当前用户可读写
chmod 600 ~/.nanobot/config.json

# 保护工作目录
chmod 700 ~/.nanobot/workspace
```

### 2. API密钥保护

```bash
# 方式1: 环境变量（推荐）
export OPENROUTER_API_KEY="sk-or-v1-xxx"

# 方式2: 配置文件（需设置权限）
nano ~/.nanobot/config.json
```

### 3. 敏感信息不提交

项目已配置 `.gitignore`:
```
.nanobot/
*.log
config.json
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

### Q5: qmd 模型下载失败怎么办？

```bash
# 手动触发下载
qmd --help

# 检查网络连接
curl -I https://github.com

# 检查磁盘空间
df -h
```

### Q6: 检索无结果怎么办？

```bash
# 查看所有记忆库
qmd list

# 检查集合名称
qmd search daily-logs "test" --hybrid

# 检查文件是否存在
ls -la ~/.nanobot/workspace/*.md

# 重新创建记忆库
qmd collection add ~/.nanobot/workspace/*.md --name nanobot-memory
qmd embed nanobot-memory ~/.nanobot/workspace/*.md
```

更多问题请查看 [故障排除文档](docs/troubleshooting.md)。

## 📂 项目结构

```
NanoBotInstall/
├── install.sh              # 一键安装脚本
├── git-commit.sh           # Git 提交和推送脚本
├── README.md               # 主文档（本文档）
├── CHANGELOG.md            # 更新日志
├── LICENSE                 # MIT 许可证
├── .gitignore              # Git 忽略文件
└── docs/                   # 详细文档
    ├── installation.md     # 安装指南
    ├── security.md         # 安全特性
    ├── operations.md       # 运维手册
    ├── maintenance.md      # 维护手册
    ├── troubleshooting.md  # 故障排除
    └── support.md          # 支持帮助
```

## 🔗 相关链接

- [nanobot 官方文档](https://github.com/HKUDS/nanobot)
- [nanobot PyPI](https://pypi.org/project/nanobot-ai/)
- [OpenRouter](https://openrouter.ai)
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
