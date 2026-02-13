# 🚀 推送到 GitHub

本项目已准备好推送到 GitHub。

## 方式一：使用 GitHub CLI (推荐)

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

## 方式二：使用 Git 命令行

```bash
# 设置远程仓库
git remote add origin https://github.com/Espl0it/NanoBotInstall.git

# 推送主分支
git branch -M main
git push -u origin main
```

## 方式三：手动创建仓库

1. 访问 https://github.com/new
2. 创建名为 `NanoBotInstall` 的仓库（选择 Public）
3. 按照页面提示推送代码：

```bash
git remote add origin https://github.com/Espl0it/NanoBotInstall.git
git branch -M main
git push -u origin main
```

## 设置 GitHub Token (如需)

如果遇到权限错误，需要设置 GitHub Token：

```bash
# 方式1: 环境变量
export GITHUB_TOKEN=ghp_xxxxxxxxxxxx

# 方式2: git credential
git config --global credential.helper store
```

获取 Token: https://github.com/settings/tokens

## 验证推送

推送成功后，访问 https://github.com/Espl0it/NanoBotInstall 确认项目已上传。
