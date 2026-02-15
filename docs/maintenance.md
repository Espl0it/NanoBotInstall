# 维护与更新

本文档说明 NanoBotInstall 的定期维护和更新策略。

[← 返回 README](../README.md)

## 🔄 更新策略

### 定期更新检查

建议每月执行一次完整更新检查：

```bash
# 1. 检查 nanobot 更新
pip index versions nanobot-ai

# 2. 检查系统依赖
python3 --version
git --version

# 3. 更新记忆库
qmd embed daily-logs memory/*.md
qmd embed workspace *.md
```

### 更新类型

| 类型 | 频率 | 说明 | 命令 |
|------|------|------|------|
| **补丁更新** | 每周 | Bug修复和安全补丁 | `pip install -U nanobot-ai` |
| **次要更新** | 每月 | 新功能和优化 | `uv tool reinstall nanobot-ai` |
| **主要更新** | 季度 | 重大变更 | 重新运行安装脚本 |

## 💾 备份策略

### 自动备份脚本

```bash
#!/bin/bash
# backup_nanobot.sh

BACKUP_DIR=~/nanobot_backup_$(date +%Y%m%d)
mkdir -p $BACKUP_DIR

# 备份配置
cp ~/.nanobot/config.json $BACKUP_DIR/

# 备份工作目录
cp -r ~/.nanobot/workspace $BACKUP_DIR/

# 备份记忆库
cp -r ~/.nanobot/qmd $BACKUP_DIR/

echo "备份完成: $BACKUP_DIR"
```

### 定时备份（cron）

```bash
# 每周日凌晨2点执行备份
0 2 * * 0 ~/backup_nanobot.sh
```

### 恢复备份

```bash
# 停止服务
pkill -f nanobot

# 备份当前配置
cp ~/.nanobot/config.json ~/.nanobot/config.json.backup

# 恢复
cp ~/nanobot_backup_20260215/config.json ~/.nanobot/
cp -r ~/nanobot_backup_20260215/workspace ~/.nanobot/

# 重启服务
nanobot gateway
```

## 🔑 API 密钥轮换

### 轮换流程

```bash
# 1. 生成新密钥
# OpenRouter: https://openrouter.ai/keys
# Anthropic: https://console.anthropic.com

# 2. 更新环境变量
export OPENROUTER_API_KEY="sk-or-v1-new-key"

# 3. 测试连接
nanobot agent -m "test"

# 4. 更新配置文件
nano ~/.nanobot/config.json
```

### 密钥监控

```bash
# 检查使用量
curl -H "Authorization: Bearer $OPENROUTER_API_KEY" \
  https://openrouter.ai/api/v1/generate

# 设置使用限额（OpenRouter支持）
```

## 🧹 清理维护

### 清理日志

```bash
# 查看日志大小
du -sh ~/.nanobot/logs/*

# 清理旧日志
find ~/.nanobot/logs -name "*.log" -mtime +7 -delete

# 或直接清空
rm -rf ~/.nanobot/logs/*
```

### 清理旧记忆

```bash
# 查看记忆库
qmd list

# 删除旧日志索引
qmd collection remove daily-logs

# 重新创建
qmd collection add memory/*.md --name daily-logs
qmd embed daily-logs memory/*.md
```

### Docker 清理

```bash
# 清理未使用的镜像
docker system prune -a

# 清理构建缓存
docker builder prune

# 查看磁盘使用
docker system df
```

## 📊 性能监控

### 资源监控

```bash
# CPU 和内存使用
ps aux | grep nanobot

# 磁盘使用
df -h ~/.nanobot

# 模型文件大小
du -sh ~/.nanobot/qmd/models/
```

### 日志分析

```bash
# 查看错误数量
grep -c "ERROR" ~/.nanobot/logs/*.log

# 查看最近错误
tail -100 ~/.nanobot/logs/*.log | grep ERROR

# 查看 API 调用
grep "API" ~/.nanobot/logs/*.log
```

## 🔧 故障恢复

### 快速恢复

```bash
# 1. 检查状态
nanobot status

# 2. 查看错误日志
nanobot agent -m "test" --logs

# 3. 重启服务
pkill -f nanobot
nanobot gateway
```

### 完全重装

```bash
# 1. 备份配置
cp ~/.nanobot/config.json ~/config_backup.json

# 2. 卸载
pip uninstall nanobot-ai
rm -rf ~/.nanobot

# 3. 重新安装
curl -sSL https://raw.githubusercontent.com/Espl0it/NanoBotInstall/master/install.sh | bash

# 4. 恢复配置
cp ~/config_backup.json ~/.nanobot/config.json

# 5. 重建记忆库
qmd embed daily-logs memory/*.md
qmd embed workspace *.md
```

## 📈 优化建议

### 性能优化

1. **减少日志级别**: 生产环境关闭 debug 日志
2. **限制记忆库大小**: 定期清理旧日志
3. **使用 SSD**: 将工作目录放在 SSD 上
4. **增加内存**: qmd 模型需要足够内存

### 成本优化

1. **使用本地模型**: qmd 减少 API 调用
2. **设置使用限额**: OpenRouter 支持
3. **缓存响应**: 避免重复请求

## 📚 相关文档

- [安装指南](installation.md) - 详细安装步骤
- [安全特性](security.md) - 安全配置
- [运维手册](operations.md) - 服务管理
- [故障排除](troubleshooting.md) - 常见问题
