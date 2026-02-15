# 故障排除

本文档提供常见问题的解决方案。

[← 返回 README](../README.md)

## 🚨 常见问题

### Q1: 安装失败

**问题表现:** 安装脚本执行时报错

**解决方案:**

```bash
# 检查 Python 版本
python3 --version  # 需要 3.11+

# 检查 Git
git --version

# 重新安装
curl -sSL https://raw.githubusercontent.com/Espl0it/NanoBotInstall/master/install.sh | bash
```

### Q2: Python 版本不兼容

**问题表现:** `Python 3.11+ required`

**解决方案:**

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install python3.11

# macOS
brew install python@3.11

# 使用 pyenv 管理多版本
pyenv install 3.11
pyenv global 3.11
```

### Q3: qmd 模型下载失败

**问题表现:** `Failed to download embedding model`

**解决方案:**

```bash
# 检查网络
curl -I https://github.com

# 检查磁盘空间
df -h

# 手动触发下载
qmd --help

# 检查代理设置
export HTTPS_PROXY="http://proxy:port"
```

### Q4: 检索无结果

**问题表现:** `qmd search` 返回空结果

**解决方案:**

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

### Q5: API 密钥无效

**问题表现:** `Invalid API key` 错误

**解决方案:**

```bash
# 检查配置文件
cat ~/.nanobot/config.json

# 验证 API 密钥
# OpenRouter: https://openrouter.ai/keys
# Anthropic: https://console.anthropic.com

# 重新设置密钥
export OPENROUTER_API_KEY="sk-or-v1-xxx"
```

### Q6: Telegram 连接失败

**问题表现:** Bot 无法接收/发送消息

**解决方案:**

```bash
# 检查 Token
# @BotFather -> /mybots -> 选择机器人 -> API Token

# 启用隐私模式
# @BotFather -> /BotSettings -> Privacy Mode -> Disable

# 检查配置
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

### Q7: 内存不足

**问题表现:** `Out of memory` 错误

**解决方案:**

```bash
# 减少并发请求
{
  "agents": {
    "defaults": {
      "max_tool_iterations": 10
    }
  }
}

# 清理日志
rm -rf ~/.nanobot/logs/*

# 重启服务
pkill -f nanobot
nanobot gateway
```

### Q8: Docker 构建失败

**问题表现:** `docker build` 出错

**解决方案:**

```bash
# 清理 Docker 缓存
docker system prune -a

# 重新构建
docker build -t nanobot .

# 检查 Dockerfile 语法
docker build --dry-run .
```

## 🔧 调试命令

### 启用调试模式

```bash
# 查看详细日志
nanobot agent -m "test" --logs

# 检查配置文件
cat ~/.nanobot/config.json

# 查看环境变量
env | grep -i nano
```

### 检查服务状态

```bash
# 检查进程
ps aux | grep nanobot

# 检查端口
netstat -tuln | grep 18790

# 检查日志
tail -f ~/.nanobot/logs/*.log
```

## 📊 日志分析

### 错误日志关键词

| 关键词 | 可能原因 | 解决方案 |
|--------|---------|----------|
| `API key` | 密钥无效 | 检查配置文件 |
| `Connection` | 网络问题 | 检查网络连接 |
| `Timeout` | 请求超时 | 增加超时时间 |
| `Memory` | 内存不足 | 清理或重启 |
| `Permission` | 权限问题 | 检查文件权限 |

### 日志位置

```bash
# 对话日志
~/.nanobot/logs/

# 安装日志
/tmp/nanobot_install_*.log

# Docker 日志
docker logs nanobot
```

## 🔄 重装流程

如果问题无法解决，可以尝试完全重装：

```bash
# 1. 停止服务
pkill -f nanobot

# 2. 备份配置
cp ~/.nanobot/config.json ~/nanobot_config_backup.json

# 3. 卸载
pip uninstall nanobot-ai
rm -rf ~/.nanobot

# 4. 重新安装
curl -sSL https://raw.githubusercontent.com/Espl0it/NanoBotInstall/master/install.sh | bash

# 5. 恢复配置
cp ~/nanobot_config_backup.json ~/.nanobot/config.json
```

## 📞 获取帮助

### 社区资源

- [GitHub Issues](https://github.com/Espl0it/NanoBotInstall/issues)
- [nanobot 官方文档](https://github.com/HKUDS/nanobot)

### 信息收集

提问时请提供以下信息：

```bash
# 系统信息
uname -a
python3 --version

# 错误日志
nanobot agent -m "test" --logs

# 配置信息（脱敏）
cat ~/.nanobot/config.json | head -20
```

## 📚 相关文档

- [安装指南](installation.md) - 详细安装步骤
- [安全特性](security.md) - 安全配置
- [运维手册](operations.md) - 服务管理
