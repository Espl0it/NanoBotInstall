# 部署与运维

本文档说明安装完成后的服务启动、日志查看和管理操作。

[← 返回 README](../README.md)

## 🚀 启动服务

### 方式1: 命令行对话

```bash
# 单次对话
nanobot agent -m "你好，NanoBot！"

# 交互模式
nanobot agent

# 带日志输出
nanobot agent --logs
```

### 方式2: 启动网关（连接聊天平台）

```bash
# 基础启动
nanobot gateway

# 后台运行
nanobot gateway &

# 查看状态
nanobot status
```

### 方式3: Docker 部署

```bash
# 构建镜像
docker build -t nanobot .

# 初始化配置
docker run -v ~/.nanobot:/root/.nanobot --rm nanobot onboard

# 运行网关
docker run -v ~/.nanobot:/root/.nanobot -p 18790:18790 nanobot gateway
```

## 📊 服务状态

```bash
# 查看网关状态
nanobot status

# 查看频道状态
nanobot channels status

# 查看计划任务
nanobot cron list
```

## 📋 日志查看

### 实时日志

```bash
# 对话日志
nanobot agent -m "test" --logs

# 网关日志
nanobot gateway

# Docker 日志
docker logs nanobot
```

### 日志文件位置

```bash
# 本地日志
~/.nanobot/logs/

# Docker 日志
docker logs nanobot
```

### 日志管理

```bash
# 查看最近日志
tail -f ~/.nanobot/logs/*.log

# 清理日志
rm -rf ~/.nanobot/logs/*
```

## 🔄 服务管理

### 重启服务

```bash
# 杀掉后台进程
pkill -f nanobot

# 重新启动
nanobot gateway
```

### 更新NanoBot

```bash
# uv 方式
uv tool reinstall nanobot-ai

# pip 方式
pip install -U nanobot-ai

# Docker 方式
docker build -t nanobot .
docker stop nanobot
docker run -d nanobot
```

### 配置重置

```bash
# 删除配置目录
rm -rf ~/.nanobot

# 重新初始化
nanobot onboard
```

## ⏰ 计划任务

### 添加任务

```bash
# 添加每日提醒
nanobot cron add --name "morning" --message "早上好！" --cron "0 9 * * *"

# 添加每周任务
nanobot cron add --name "weekly-report" --message "生成周报" --cron "0 18 * * 5"
```

### 管理任务

```bash
# 列出所有任务
nanobot cron list

# 删除任务
nanobot cron remove <job_id>

# 启用/禁用任务
nanobot cron enable <job_id>
nanobot cron disable <job_id>
```

## 📁 文件管理

### 工作目录

```bash
# 默认位置
~/.nanobot/workspace/

# 自定义位置（需配置）
{
  "workspace": "/path/to/your/workspace"
}
```

### 记忆库维护

```bash
# 查看记忆库
qmd list

# 更新记忆库
qmd embed daily-logs memory/*.md
qmd embed workspace *.md

# 清理旧日志
rm -f memory/2025-*.md
```

## 🔧 故障排查

### 服务无法启动

```bash
# 检查端口占用
lsof -i :18790

# 检查日志
nanobot agent -m "test" --logs

# 重新配置
rm -rf ~/.nanobot
nanobot onboard
```

### 网络搜索失败

```bash
# 检查API密钥
cat ~/.nanobot/config.json | grep apiKey

# 测试Brave Search
curl -H "Accept: application/json" \
  "https://api.search.brave.com/res/v1/web/search?q=test&count=1" \
  -H "X-Subscription-Token: $BRAVE_API_KEY"
```

## 📚 相关文档

- [安装指南](installation.md) - 详细安装步骤
- [安全特性](security.md) - 安全配置和最佳实践
- [故障排除](troubleshooting.md) - 常见问题和解决方案
