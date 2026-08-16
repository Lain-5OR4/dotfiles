# 📋 Detailed Installation Guide

This guide provides step-by-step installation instructions for different operating systems.

## 🐧🍎 macOS and Ubuntu Debian Setup (Nix Recommended)

On both macOS and Ubuntu, most CLI dependencies (git, fzf, ripgrep, bat, eza, neovim, gh, tmux, and language runtimes) are managed declaratively via Nix + Home Manager instead of Homebrew/apt — see `dot_config/home-manager/{flake.nix,home.nix}` in this repo. `flake.nix` detects the OS/CPU at run time, so **the bootstrap command is identical on both platforms**. WezTerm and Nerd Fonts are GUI/font installs and stay on Homebrew/apt/manual download.

### 1. Install OS-level prerequisites
```bash
# Ubuntu/Debian — needed to fetch Nix/chezmoi and to set zsh as default shell
sudo apt update && sudo apt install -y git zsh curl wget
chsh -s $(which zsh)

# macOS — Homebrew, for WezTerm + fonts only (not CLI packages)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Install WezTerm
```bash
# Ubuntu/Debian
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo apt update && sudo apt install wezterm

# macOS
brew install --cask wezterm
```

### 3. Install Nix
```bash
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
```
This repo assumes the Determinate Systems installer (referenced in `.zshrc`'s Home Manager PATH setup). Works the same way on macOS and Ubuntu. Restart your terminal after installing.

### 3a. (Ubuntu/Linux) Trust yourself for the neovim-nightly binary cache
`flake.nix` declares a `nixConfig` pointing at the `nix-community.cachix.org` binary cache so `neovim-nightly-overlay` doesn't need to build from source (on Ubuntu x86_64-linux, building it locally has hit GCC LTO internal-compiler-error crashes — not 100% reproducible, but worth avoiding). For the daemon to actually honor that cache, your user must be a Nix "trusted user":

```bash
echo "trusted-users = root $(whoami)" | sudo tee -a /etc/nix/nix.custom.conf
sudo systemctl restart nix-daemon
nix show-config | grep trusted-users   # should list your username
```
Determinate Nix manages `/etc/nix/nix.conf` itself and points you at `/etc/nix/nix.custom.conf` for local overrides — editing `nix.conf` directly gets ignored. This step isn't required on macOS (no build failures observed there).

Without this, the first `home-manager switch` will still print `do you want to allow configuration setting 'extra-substituters' ...` prompts (answer `y`/`y`) but then log `warning: ignoring untrusted substituter ..., you are not a trusted user` and fall back to building `neovim-nightly-overlay` from source — which usually still succeeds, just slower and occasionally flaky.

### 4. Deploy dotfiles, then bootstrap Home Manager
Follow [Deploy Dotfiles](#-deploy-dotfiles) below first so `~/.config/home-manager/{flake.nix,home.nix}` exist, then run this **same command on both macOS and Ubuntu**:
```bash
nix run github:nix-community/home-manager -- switch --flake ~/.config/home-manager --impure
```
This installs everything declared in `home.nix`. `flake.nix` picks the right package set for your OS/CPU via `builtins.currentSystem`, which is why `--impure` is required — it's what makes the one command portable instead of needing a per-machine flag. After this first run, `home-manager` is on `PATH` and future updates use the `hms` shell alias (`home-manager switch --flake ~/.config/home-manager --impure`) defined in `.zsh/config/alias.zsh`.

### 5. Set zsh as default shell (macOS)
```bash
chsh -s $(which zsh)
```

### Verified vs. untested
Package resolution has been checked by evaluation for `aarch64-darwin`, `x86_64-linux`, and `aarch64-linux` (covers Apple Silicon Mac and Ubuntu on both common CPU architectures). `home-manager switch` has been run successfully on both macOS (`aarch64-darwin`) and Ubuntu (`x86_64-linux`). On Ubuntu, `neovim-nightly-overlay`'s source build hit an intermittent GCC LTO crash (internal compiler error) a couple of times before succeeding — see [step 3a](#3a-ubuntulinux-trust-yourself-for-the-neovim-nightly-binary-cache) above for the fix (use the binary cache instead of building locally). `aarch64-linux` is unverified on real hardware, only by evaluation.

### Manual fallback (skip Nix)
If you'd rather not use Nix, install the same tools via your OS package manager:
```bash
# Ubuntu/Debian
sudo apt install -y fzf ripgrep bat eza neovim

# For Ubuntu 22.04+, bat might be installed as 'batcat'
if command -v batcat > /dev/null; then
    echo 'alias bat=batcat' >> ~/.bashrc
fi

# macOS
brew install git zsh fzf ripgrep bat eza neovim
```
Skip step 3/4 above (Nix/Home Manager) entirely in this case.

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

### 1. Install chezmoi
```bash
brew install chezmoi                        # macOS
sh -c "$(curl -fsLS get.chezmoi.io)"         # Linux (or any platform)
```

### 2. Clone and Apply
```bash
chezmoi init --apply Lain-5OR4
```
This uses chezmoi's standard layout: it clones `github.com/Lain-5OR4/dotfiles` into `~/.local/share/chezmoi` and deploys it. Run without `--apply` first if you want to review with `chezmoi diff` before applying.

### 3. (Optional) Convenience symlink
```bash
ln -s ~/.local/share/chezmoi ~/dotfiles
```

### 4. (macOS/Ubuntu, if not already done) Bootstrap Home Manager
```bash
nix run github:nix-community/home-manager -- switch --flake ~/.config/home-manager --impure
```
See the [macOS and Ubuntu section](#-macos-and-ubuntu-debian-setup-nix-recommended) above for details.

### 5. Restart Terminal
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

### 1a. (macOS/Ubuntu) Check Home Manager
```bash
home-manager --version   # should print a version, not "command not found"
hms                      # re-applies home.nix; should report "no change" on a clean setup
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

If you encounter issues during installation, refer to the [main README troubleshooting section](../README.md#-トラブルシューティング) or check our [issues page](../../issues).