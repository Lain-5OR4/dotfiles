# 📋 Detailed Installation Guide

This guide provides step-by-step installation instructions for different operating systems.

## 🐧 Linux (Ubuntu/Debian)

### 1. Install Prerequisites
```bash
# Update package list
sudo apt update

# Install essential tools
sudo apt install -y git zsh curl wget

# Set zsh as default shell
chsh -s $(which zsh)
```

### 2. Install Dependencies
```bash
# Install core tools
sudo apt install -y fzf ripgrep bat eza

# For Ubuntu 22.04+, bat might be installed as 'batcat'
# Create alias if needed
if command -v batcat > /dev/null; then
    echo 'alias bat=batcat' >> ~/.bashrc
fi
```

### 3. Install Neovim (Latest)
```bash
# Remove old version if exists
sudo apt remove neovim

# Download and install latest Neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim
```

### 4. Install WezTerm
```bash
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo apt update
sudo apt install wezterm
```

## 🍎 macOS

### 1. Install Homebrew (if not installed)
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Install Dependencies
```bash
# Install core tools
brew install git zsh fzf ripgrep bat eza

# Install Neovim
brew install neovim

# Install WezTerm
brew install --cask wezterm
```

### 3. Set zsh as default shell
```bash
chsh -s $(which zsh)
```

## 🏔️ Arch Linux

### 1. Install Dependencies
```bash
# Install from official repositories
sudo pacman -S git zsh fzf ripgrep bat eza neovim

# Install WezTerm
sudo pacman -S wezterm
```

### 2. Set zsh as default shell
```bash
chsh -s $(which zsh)
```

## 🪟 Windows (WSL2)

### 1. Enable WSL2 and install Ubuntu
Follow the official [WSL2 installation guide](https://docs.microsoft.com/en-us/windows/wsl/install)

### 2. Install WezTerm on Windows
Download from [WezTerm releases](https://github.com/wez/wezterm/releases)

### 3. Follow Linux (Ubuntu/Debian) instructions inside WSL2

## 🎨 Font Installation

### Install a Nerd Font
Choose one of these popular options:

**JetBrains Mono Nerd Font (Recommended)**
```bash
# Linux
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -fLo "JetBrains Mono Nerd Font Complete.ttf" \
  https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.tar.xz
tar -xf JetBrainsMono.tar.xz
fc-cache -fv

# macOS
brew tap homebrew/cask-fonts
brew install font-jetbrains-mono-nerd-font
```

**Other Options:**
- Fira Code Nerd Font
- Hack Nerd Font  
- Source Code Pro Nerd Font

## 🚀 Deploy Dotfiles

### 1. Clone Repository
```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
```

### 2. Backup Existing Configs
```bash
mkdir -p ~/dotfiles-backup
for file in .zshrc .tmux.conf .wezterm.lua .p10k.zsh; do
    [ -f ~/$file ] && cp ~/$file ~/dotfiles-backup/
done
```

### 3. Run Deploy Script
```bash
chmod +x deploy.sh
./deploy.sh
```

### 4. Restart Terminal
Close and reopen your terminal, or start a new zsh session:
```bash
exec zsh
```

## ✅ Verification

After installation, verify everything is working:

### 1. Check Command Availability
```bash
# These should all return version numbers
nvim --version
fzf --version
rg --version
bat --version
eza --version
```

### 2. Test Zsh Plugins
- Type a command and press `Tab` - you should see enhanced completions
- Start typing a previous command - you should see auto-suggestions
- Commands should have syntax highlighting

### 3. Test Neovim
```bash
nvim
```
- Check that plugins are loaded (`:Lazy` command should work)
- Verify LSP is working (`:LspInfo`)
- Test file tree with `Space + tt`

### 4. Test Tmux
```bash
tmux
```
- Try splitting panes: `Ctrl+g` then `\` or `-`
- Status bar should be visible at the top

## 🔧 Post-Installation Configuration

### Configure Powerlevel10k
```bash
p10k configure
```
Follow the interactive prompts to customize your prompt.

### Set up Git (if not already done)
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Configure WezTerm Font
Edit your WezTerm config to use the installed Nerd Font:
```lua
-- In ~/.wezterm.lua
config.font = wezterm.font('JetBrains Mono Nerd Font')
```

## 🐛 Troubleshooting

If you encounter issues during installation, refer to the [main README troubleshooting section](../README.md#-troubleshooting) or check our [issues page](../../issues).