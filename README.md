# 🏠 dotfiles
A comprehensive collection of configuration files for a modern development environment

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## ✨ Features
- **Modern shell experience** with Zsh + Powerlevel10k + Zinit
- **GPU-accelerated terminal** with WezTerm
- **Powerful text editor** with Neovim + LSP + plugins
- **Enhanced tmux** configuration with custom keybindings
- **Rich command-line tools** (fzf, eza, bat, ripgrep)

## 📁 Structure
This dotfiles repository contains configurations for:
- **🐚 Zsh** (`.zshrc`, `.p10k.zsh`, `.zsh/`)
- **🖥️ Tmux** (`.tmux.conf`) 
- **💻 WezTerm** (`.wezterm.lua`)
- **✏️ Neovim** (`.config/nvim/`)

## 🚀 Quick Setup

### Prerequisites
Make sure you have the following installed:
- Git
- Zsh (set as default shell)
- A [Nerd Font](https://www.nerdfonts.com/) for proper icon display

### Installation
This repository is managed with [chezmoi](https://www.chezmoi.io/) using its standard layout: the source lives at `~/.local/share/chezmoi` (no custom config needed). A `~/dotfiles` symlink points there for convenience.

1. **Install chezmoi:**
   ```bash
   brew install chezmoi                        # macOS
   sh -c "$(curl -fsLS get.chezmoi.io)"         # Linux (or any platform)
   ```
   (see [Dependencies](#-dependencies) section or [detailed installation guide](docs/INSTALL.md) for everything else)

2. **Clone and apply in one step:**
   ```bash
   chezmoi init --apply Lain-5OR4
   ```
   This clones `github.com/Lain-5OR4/dotfiles` into `~/.local/share/chezmoi` and deploys it. Drop `--apply` first if you want to `chezmoi diff` before applying.

3. **(Optional) Add the `~/dotfiles` convenience symlink:**
   ```bash
   ln -s ~/.local/share/chezmoi ~/dotfiles
   ```

4. **Restart your terminal** and enjoy!

Day-to-day usage: edit files with `chezmoi edit <path>` (or edit directly under `chezmoi source-path`), preview with `chezmoi diff`, deploy with `chezmoi apply`. See [chezmoi's docs](https://www.chezmoi.io/user-guide/daily-operations/) for more.

## 📦 Dependencies

### Required Tools
<img src="doc/img/fzf.png" height=100>

- **[fzf](https://github.com/junegunn/fzf)** - Fuzzy finder
  ```bash
  sudo apt install fzf
  ```

- **[eza](https://github.com/eza-community/eza)** - Modern `ls` replacement
  ```bash
  # Ubuntu/Debian
  sudo apt install eza
  
  # macOS
  brew install eza
  
  # Arch Linux
  sudo pacman -S eza
  ```

- **[ripgrep](https://github.com/BurntSushi/ripgrep)** - Fast grep alternative
  ```bash
  sudo apt install ripgrep
  ```

- **[bat](https://github.com/sharkdp/bat)** - Cat with syntax highlighting
  <img src="doc/img/bat.svg" height=40>
  ```bash
  # Ubuntu/Debian
  sudo apt install bat
  
  # macOS
  brew install bat
  
  # Arch Linux
  sudo pacman -S bat
  ```

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

## 🔧 How deployment works
`chezmoi apply` reads the `dot_*` entries in this repo and materializes them under `$HOME` (e.g. `dot_zshrc` → `~/.zshrc`, `dot_config/nvim/` → `~/.config/nvim/`). Files listed in `.chezmoiignore` (README, LICENSE, `doc/`, `docs/`) are excluded from deployment.

## 🎨 Customization

Want to make these dotfiles your own? Check out the [comprehensive customization guide](docs/CUSTOMIZATION.md) for detailed instructions on:

- Adding custom Zsh aliases and functions
- Installing additional Neovim plugins
- Customizing themes and colors
- Setting up personal keybindings
- OS-specific configurations

### Quick Customization Tips
- Edit `~/.zshrc` for general shell settings
- Modify `~/.zsh/config/alias.zsh` to add custom aliases  
- Run `p10k configure` to customize the prompt theme
- Add plugins in `~/.config/nvim/lua/plugins/`

## 🔧 Key Bindings

### Neovim
| Key | Action |
|-----|--------|
| `jj` | Exit insert mode |
| `Space + h` | Go to beginning of line |
| `Space + l` | Go to end of line |
| `Space + tt` | Toggle file tree |
| `Space + ff` | Find files (Telescope) |
| `Space + fg` | Live grep (Telescope) |
| `Ctrl + g` | Accept GitHub Copilot suggestion |

### Tmux
| Key | Action |
|-----|--------|
| `Ctrl + g` | Prefix key |
| `\` | Split horizontally |
| `-` | Split vertically |

## 🛠️ Troubleshooting

### Common Issues

**Fonts not displaying correctly**
- Install a Nerd Font from [nerdfonts.com](https://www.nerdfonts.com/)
- Set your terminal to use the installed font

**Zinit installation fails**
- Check internet connection
- Manually clone: `git clone https://github.com/zdharma-continuum/zinit ~/.local/share/zinit/zinit.git`

**Neovim plugins not working**
- Run `:checkhealth` in Neovim to diagnose issues
- Ensure you have the latest Neovim version (0.8+)

**Permission errors during deployment**
- Run `chezmoi doctor` to diagnose environment issues
- Check file permissions in your home directory

### Getting Help
If you encounter issues:
1. Check the troubleshooting section above
2. Look at existing [issues](../../issues)
3. Create a new issue with detailed information

## 📝 Notes
- Make sure to have zsh as your default shell: `chsh -s $(which zsh)`
- Install all dependencies before running `chezmoi apply`
- Run `chezmoi diff` before `chezmoi apply` to review changes ahead of time
- Restart your terminal after installation for changes to take effect

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing
Contributions are welcome! Please feel free to submit a Pull Request.