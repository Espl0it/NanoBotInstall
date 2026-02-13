# qmd 集成指南

## 概述

**qmd** 是 Shopify 创始人 Tobi 用 Rust 写的本地语义搜索引擎，专为 AI Agent 设计。

### 核心优势

| 特性 | 效果 |
|------|------|
| Token 优化 | 消耗减少约 90%（2000→200 Token） |
| 检索精准度 | 混合搜索 93%，纯语义 59% |
| 运行方式 | 完全本地，无需外部 API |
| 集成方式 | 原生 MCP 协议支持 |

## 安装

安装脚本会自动安装 qmd：

```bash
curl -sSL https://raw.githubusercontent.com/Espl0it/NanoBotInstall/main/install.sh | bash
```

### 手动安装

```bash
# 安装 Bun
curl -fsSL https://bun.sh/install | bash

# 安装 qmd
bun install -g https://github.com/tobi/qmd

# 首次运行自动下载模型
qmd --help
```

### 模型下载

首次运行会自动下载两类模型：

| 模型 | 大小 | 用途 |
|------|------|------|
| jina-embeddings-v3 | ~330MB | 向量化文档 |
| jina-reranker-v2-base-multilingual | ~640MB | 重排序 |

## 配置

### MCP 集成

安装完成后，会自动创建 MCP 配置文件：

```json
{
  "mcpServers": {
    "qmd": {
      "command": "/path/to/qmd",
      "args": ["mcp"]
    }
  }
}
```

### 记忆库管理

#### 创建记忆库

```bash
cd ~/.nanobot/workspace

# 创建日常日志记忆库
qmd collection add memory/*.md --name daily-logs

# 生成 embeddings
qmd embed daily-logs memory/*.md

# 创建工作空间记忆库
qmd collection add *.md --name workspace
qmd embed workspace *.md
```

#### 查看记忆库

```bash
# 列出所有记忆库
qmd list
```

## 使用方法

### 命令行检索

```bash
# 混合搜索（推荐）- 关键词 + 语义
qmd search daily-logs "关键词" --hybrid

# 纯语义搜索
qmd search daily-logs "关键词"

# 关键词搜索
qmd search daily-logs "关键词" --keyword
```

### Agent MCP 工具

qmd 会暴露以下 MCP 工具：

| 工具 | 功能 | 说明 |
|------|------|------|
| `query` | 混合搜索 | 推荐使用，精度最高 |
| `vsearch` | 纯语义检索 | 适合记忆模糊场景 |
| `search` | 关键词检索 | 传统全文检索 |
| `get` | 获取片段 | 根据 ID 获取内容 |
| `multi_get` | 批量获取 | 获取多个片段 |
| `status` | 健康检查 | 监控服务状态 |

### 集成到 Agent

Agent 收到用户问题后：

```
1. 通过 MCP 调用 qmd.query 工具
2. 在记忆库中检索相关片段
3. 将片段拼接在提示词前
4. 发送给 LLM 生成答案
```

**效果：**
- 传统方案：发送完整 MEMORY.md (~2000 Token)
- qmd 方案：仅发送相关片段 (~200 Token)
- **节省：90% Token 消耗**

## 维护

### 定期更新 Embeddings

建议加入 cron 或 heartbeat 任务：

```bash
# 添加到 crontab
crontab -e

# 每天凌晨 2 点更新
0 2 * * * cd ~/.nanobot/workspace && qmd embed daily-logs memory/*.md && qmd embed workspace *.md
```

### 增量更新

```bash
# 只更新单个文件
qmd embed daily-logs memory/2026-02-14.md
```

## 性能对比

| 搜索模式 | 精准度 | 适用场景 |
|----------|--------|----------|
| 混合搜索 | ~93% | 推荐默认使用 |
| 纯语义搜索 | ~59% | 记忆模糊、关键词难描述 |
| 关键词搜索 | 依赖 BM25 | 精确匹配需求 |

## 故障排除

### 模型下载失败

```bash
# 手动触发下载
qmd --help

# 检查网络连接
curl -I https://github.com
```

### 记忆库为空

```bash
# 检查文件是否存在
ls -la ~/.nanobot/workspace/*.md

# 重新创建记忆库
qmd collection add ~/.nanobot/workspace/*.md --name nanobot-memory
qmd embed nanobot-memory ~/.nanobot/workspace/*.md
```

### 检索无结果

```bash
# 查看所有记忆库
qmd list

# 检查集合名称是否正确
qmd search daily-logs "test" --hybrid
```

## 高级用法

### 多个记忆库

```bash
# 按时间组织
qmd collection add memory/2026-01/*.md --name jan-logs
qmd collection add memory/2026-02/*.md --name feb-logs

# 按项目组织
qmd collection add projects/corevalue/*.md --name corevalue
qmd collection add projects/security/*.md --name security
```

### 跨库检索

```bash
# 在所有集合中检索
qmd search daily-logs "关键词" --hybrid
qmd search jan-logs "关键词" --hybrid
```

## 最佳实践

1. **推荐使用混合搜索** - 精准度最高
2. **定期更新 embeddings** - 保持记忆最新
3. **合理组织文件结构** - 便于管理和检索
4. **监控服务状态** - 使用 qmd status 定期检查

## 参考资源

- [qmd GitHub](https://github.com/tobi/qmd)
- [MCP 协议文档](https://modelcontextprotocol.io)
- [Jina AI](https://jina.ai) - 模型提供商