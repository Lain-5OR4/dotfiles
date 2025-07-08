# dotfiles
my dotfiles collection

## 📁 Structure
This dotfiles repository contains configurations for:
- **Zsh** (`.zshrc`, `.p10k.zsh`, `.zsh/`)
- **Tmux** (`.tmux.conf`)
- **WezTerm** (`.wezterm.lua`)
- **Neovim** (`.config/nvim/`)

## 🚀 Quick Setup
1. Clone this repository:
   ```bash
   git clone <repository-url> ~/dotfiles
   cd ~/dotfiles
   ```

2. Install required dependencies (see below)

3. Run the deployment script:
   ```bash
   ./deploy.sh
   ```

## 📦 Dependencies

### Required Tools
<img src="doc/img/fzf.png" height=100>

- **[fzf](https://github.com/junegunn/fzf)** - Fuzzy finder
  ```bash
  sudo apt install fzf
  ```

- **[eza](https://github.com/eza-community/eza)** - Modern `ls` replacement
  ```bash
  # See install.md for detailed instructions
  ```

- **[ripgrep](https://github.com/BurntSushi/ripgrep)** - Fast grep alternative
  ```bash
  sudo apt install ripgrep
  ```

- **[bat](https://github.com/sharkdp/bat)** - Cat with syntax highlighting
  <img src="doc/img/bat.svg" height=40>

### Terminal Emulator
<img src="doc/img/wezterm-icon.png" height=80>

**[WezTerm](https://wezfurlong.org/wezterm/index.html)** - GPU-accelerated terminal emulator
- GitHub: https://github.com/wez/wezterm

### Zsh Setup
![](doc/img/zinit.png)

**Plugin Manager**: [zinit](https://github.com/zdharma-continuum/zinit)

**Plugins**:
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [Fast Syntax Highlighting](https://github.com/zdharma-continuum/fast-syntax-highlighting)
- [zsh-completions](https://github.com/zsh-users/zsh-completions)
- [zsh-z](https://github.com/agkozak/zsh-z)
- [powerlevel10k](https://github.com/romkatv/powerlevel10k)

### Neovim Setup
**Plugin Manager**: 💤[Lazy.nvim](https://github.com/folke/lazy.nvim)

## 🔧 What the deploy script does
The `deploy.sh` script creates symbolic links for:
- Main dotfiles (`.zshrc`, `.tmux.conf`, `.wezterm.lua`, `.p10k.zsh`)
- Additional configurations (`.zsh/` and `.config/` directories)

## 📝 Notes
- Make sure to have zsh as your default shell
- Install all dependencies before running the deploy script
- Backup your existing dotfiles before deployment