# AGENTS.md - NanoBotInstall 项目开发指南

本文档为在此代码库中工作的 AI 代理提供开发规范和指导。

## 1. 项目概述

- **项目类型**: Bash 脚本项目 (Shell Scripts)
- **用途**: 一键安装脚本，用于部署 nanobot 超轻量级 AI 助手
- **主要文件**: `install.sh`, `git-commit.sh`

## 2. 构建与测试命令

### 2.1 脚本执行

```bash
# 执行安装脚本
chmod +x install.sh
./install.sh

# 执行 Git 提交和推送脚本
chmod +x git-commit.sh
./git-commit.sh
```

### 2.2 Shell 脚本检查

```bash
# 语法检查 (不执行)
bash -n install.sh
bash -n git-commit.sh

# ShellCheck 静态分析 (如已安装)
shellcheck install.sh
shellcheck git-commit.sh
```

### 2.3 Git 操作

```bash
# 初始化 git (如需要)
git init
git add .
git commit -m "commit message"
git push origin main
```

## 3. 代码风格指南

### 3.1 脚本结构

- 使用 `#!/bin/bash` shebang
- 使用 `set -e` 遇到错误立即退出
- 使用 `set -u` 检测未定义变量
- 长脚本添加分隔注释块:

```bash
# ════════════════════════════════════════════════════════════════════════════
# 步骤 1: 检查前置条件
# ════════════════════════════════════════════════════════════════════════════
```

### 3.2 变量命名

- 全大写加下划线: `GITHUB_TOKEN`, `REPO_DIR`
- 局部变量用小写或 `local` 声明: `local output=$(cmd)`
- 常量使用 `readonly`: `readonly DEFAULT_TIMEOUT=300`
- 变量赋值左右无空格: `VAR=value`，不要 `VAR = value`

### 3.3 函数命名

- 使用 snake_case: `print_success()`, `check_prerequisites()`
- 函数定义前添加用途注释:

```bash
# 打印成功信息
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}
```

### 3.4 颜色输出

统一使用以下颜色变量:
`RED='\033[0;31m' GREEN='\033[0;32m' YELLOW='\033[1;33m' BLUE='\033[0;34m' CYAN='\033[0;36m' NC='\033[0m'`

### 3.5 条件判断

- 使用 `[[ ]]` 替代 `[ ]`
- 字符串比较用 `==` 而非 `=`
- 使用 `command -v cmd &> /dev/null` 检查命令存在性
- 变量加双引号防止空格问题: `[[ -n "$VAR" ]]`

### 3.6 错误处理

使用 `|| { ...; exit 1; }` 处理关键错误，重要操作后检查退出码: `if [ $? -eq 0 ]; then ...`

### 3.7 字符串与引号

- 变量展开用双引号: `echo "$VAR"`
- 静态字符串用单引号: `'static string'`
- 脚本中的 heredoc 使用 `cat << 'EOF'` 防止变量展开

### 3.8 循环与路径处理

- 使用 `for` 循环时避免子 shell 污染
- 使用 `$(cd "$(dirname "$0")" && pwd)` 获取脚本所在目录，路径变量加双引号

### 3.9 注释规范

行内注释放在代码上方或行尾，块注释用 `# ═` 分隔，避免不必要的注释，代码本身应自解释。

### 3.10 命令检查

检查命令存在再执行: `if command -v git &> /dev/null; then ...`，使用 `|| print_warning` 处理非关键错误。

### 3.11 字符串拼接与数组

- 避免使用 `echo $VAR`，用 `"$VAR"`
- 使用 `printf` 获得更精确控制
- 数组: `arr=(item1 item2 item3)`，遍历: `for item in "${arr[@]}"; do ... done`

### 3.12 脚本头部

```bash
#!/bin/bash

# ════════════════════════════════════════════════════════════════════════════
# 脚本名称 - 简短描述
# 作者: Name
# 用途: ...
# ════════════════════════════════════════════════════════════════════════════

set -e
```

## 4. 安全注意事项

- 切勿在脚本中硬编码敏感信息 (API keys, tokens)
- 使用环境变量传递敏感数据
- 添加 `.nanobot/` 到 `.gitignore`
- 执行外部命令前验证其来源

## 5. 提交规范

- 提交信息使用中文或英文，保持提交信息简洁明了
- 提交前执行语法检查: `bash -n script.sh`

## 6. 文档更新

如有重大更改，同步更新 `README.md`，维护 `CHANGELOG.md` 记录版本变更。

---

本文档最后更新: 2026-02-14
