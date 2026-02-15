# 安全特性

本文档说明 NanoBotInstall 部署的安全设计。

[← 返回 README](../README.md)

## 🎯 安全特性

### 本地隐私保护

- **qmd 完全离线运行**: 本地语义搜索引擎，无需外部API
- **数据本地存储**: 所有记忆库仅存储在本地
- **零外部依赖**: 搜索和分析完全本地化

### 安装安全

- **语法检查**: 安装前执行 `bash -n` 验证脚本语法
- **环境验证**: 检查 Python 版本、Git、pip 等依赖
- **敏感信息保护**: API密钥通过环境变量传递，不硬编码

### 网络安全

- **可选网络访问**: 仅在用户明确启用时支持网络搜索
- **Brave Search (可选)**: 可选的网络搜索API，非必需
- **API密钥保护**: 通过环境变量或配置文件安全传递

## 🔒 安全最佳实践

### 1. 配置文件权限

```bash
# 设置配置文件为仅当前用户可读写
chmod 600 ~/.nanobot/config.json

# 保护工作目录
chmod 700 ~/.nanobot/workspace
```

### 2. API密钥管理

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

## 🛡️ 安全测试

安装完成后，可执行以下测试验证安全特性：

```bash
# 测试本地记忆搜索
qmd search daily-logs "测试" --hybrid

# 测试网络搜索（如果已配置）
nanobot agent -m "搜索最新新闻"
```

## 📚 相关文档

- [安装指南](installation.md) - 详细安装步骤
- [运维手册](operations.md) - 服务管理和日志查看
- [故障排除](troubleshooting.md) - 常见问题和解决方案
