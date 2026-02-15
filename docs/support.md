# 支持与帮助

本文档提供获取帮助的途径和资源。

[← 返回 README](../README.md)

## 📚 官方资源

### 项目地址

- **GitHub**: https://github.com/Espl0it/NanoBotInstall
- **nanobot 官方**: https://github.com/HKUDS/nanobot
- **qmd 仓库**: https://github.com/tobi/qmd

### 文档资源

- [安装指南](installation.md) - 详细安装步骤
- [安全特性](security.md) - 安全配置
- [运维手册](operations.md) - 服务管理
- [维护手册](maintenance.md) - 定期维护
- [故障排除](troubleshooting.md) - 常见问题

## 💬 获取帮助

### GitHub Issues

遇到问题时，请先查看：

1. [现有 Issues](https://github.com/Espl0it/NanoBotInstall/issues)
2. [故障排除文档](troubleshooting.md)

如需提交新 Issue，请提供：

```bash
# 系统信息
uname -a
python3 --version

# 错误日志
nanobot agent -m "test" --logs

# 配置信息（脱敏）
cat ~/.nanobot/config.json | head -20
```

### 社区支持

- **nanobot Discord**: https://discord.gg/nanobot
- **HKUDS GitHub**: https://github.com/HKUDS

## 📖 学习资源

### 入门教程

1. [快速开始](#-快速开始)
2. [安装指南](installation.md)
3. [使用教程](#-使用教程)

### 进阶主题

- [qmd 本地记忆引擎](#-qmd-本地记忆引擎)
- [MCP 集成](#-mcp集成)
- [多平台支持](#-支持的频道)

## 🤝 贡献指南

### 贡献方式

1. **报告 Bug**: GitHub Issues
2. **提出建议**: GitHub Discussions
3. **贡献代码**: Pull Request
4. **改进文档**: 完善 README 和 docs/

### 代码规范

请参考 [AGENTS.md](../AGENTS.md) 中的代码规范。

## 📋 版本历史

### 当前版本

```bash
# 查看安装脚本版本
curl -sSL https://raw.githubusercontent.com/Espl0it/NanoBotInstall/master/install.sh | head -20
```

### 更新日志

查看 [CHANGELOG.md](../CHANGELOG.md) 了解最新变更。

### 更新检查

```bash
# 检查 nanobot 版本
pip show nanobot-ai

# 检查脚本更新
git -C ~/.nanobot/NanoBotInstall pull
```

## 🙏 致谢

感谢以下项目和社区：

- [HKUDS](https://github.com/HKUDS) - nanobot 原作者
- [OpenClaw](https://github.com/openclaw/openclaw) - 参考框架
- [Tobi](https://github.com/tobi) - qmd 作者
- [nanobot 社区](https://github.com/HKUDS/nanobot/discussions)

## 📜 许可证

本项目采用 MIT 许可证，详见 [LICENSE](../LICENSE)。

---

**提示**: 在提问前，请先查阅本文档和 [故障排除](troubleshooting.md)，大多数问题都有现成解决方案。
