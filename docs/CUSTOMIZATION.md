# 🎨 Customization Guide

This guide covers how to customize various aspects of the dotfiles configuration.

## 🐚 Zsh Customization

### Adding Custom Aliases
Edit `~/.zsh/config/alias.zsh` to add your own aliases:

```bash
# Example custom aliases
alias ll='eza --icons -alF --group-directories-first'
alias code='code-insiders'  # If using VS Code Insiders
alias python='python3'
alias pip='pip3'

# Docker shortcuts
alias dc='docker-compose'
alias dps='docker ps'
alias dpsa='docker ps -a'

# Kubernetes shortcuts
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get services'
```

### Adding Custom Functions
Add functions to your `~/.zshrc` or create a separate file:

```bash
# Quick directory creation and navigation
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Find and kill processes
fkill() {
    local pid
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    if [ "x$pid" != "x" ]; then
        echo $pid | xargs kill -${1:-9}
    fi
}

# Quick git commit
gac() {
    git add . && git commit -m "$1"
}
```

### Customizing Prompt (Powerlevel10k)
Run the configuration wizard:
```bash
p10k configure
```

Or manually edit `~/.p10k.zsh`:
```bash
# Example: Show time in prompt
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    time
    status
    command_execution_time
    background_jobs
    direnv
    asdf
    virtualenv
    anaconda
    pyenv
    goenv
    nodenv
    nvm
    nodeenv
    rbenv
    rvm
    fvm
    luaenv
    jenv
    plenv
    phpenv
    scalaenv
    haskell_stack
    kubecontext
    terraform
    aws
    aws_eb_env
    azure
    gcloud
    google_app_cred
    context
    nordvpn
    ranger
    yazi
    nnn
    lf
    xplr
    vim_shell
    midnight_commander
    nix_shell
    vi_mode
    todo
    timewarrior
    taskwarrior
    newline
)
```

### Adding Zsh Plugins
Add plugins to the zinit section in `~/.zshrc`:

```bash
# Load additional plugins
zinit light zsh-users/zsh-history-substring-search
zinit light zdharma-continuum/zsh-diff-so-fancy
zinit light wfxr/forgit

# Load Oh My Zsh plugins
zinit snippet OMZP::docker
zinit snippet OMZP::kubectl
zinit snippet OMZP::terraform
```

## ✏️ Neovim Customization

### Adding New Plugins
Create a new file in `~/.config/nvim/lua/plugins/` for your plugin:

**Example: `~/.config/nvim/lua/plugins/git-integration.lua`**
```lua
return {
    -- Git signs in gutter
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup({
                signs = {
                    add          = { text = '│' },
                    change       = { text = '│' },
                    delete       = { text = '_' },
                    topdelete    = { text = '‾' },
                    changedelete = { text = '~' },
                    untracked    = { text = '┆' },
                },
            })
        end
    },
    
    -- Better Git commit interface
    {
        'tpope/vim-fugitive',
        cmd = { 'Git', 'Gstatus', 'Gblame', 'Gpush', 'Gpull' },
    },
}
```

### Custom Keybindings
Add custom keybindings to `~/.config/nvim/init.lua`:

```lua
-- Custom keybindings
vim.keymap.set('n', '<Leader>w', ':w<CR>')  -- Save with leader+w
vim.keymap.set('n', '<Leader>q', ':q<CR>')  -- Quit with leader+q
vim.keymap.set('n', '<Leader>x', ':x<CR>')  -- Save and quit

-- Buffer navigation
vim.keymap.set('n', '<Tab>', ':bnext<CR>')
vim.keymap.set('n', '<S-Tab>', ':bprev<CR>')

-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

-- Terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
```

### LSP Configuration
Edit `~/.config/nvim/lua/plugins/lsp.lua` to add language servers:

```lua
-- Add language servers
require("mason-lspconfig").setup({
    ensure_installed = {
        "lua_ls",
        "rust_analyzer", 
        "pyright",
        "tsserver",
        "gopls",
        "clangd",
    }
})
```

### Theme Customization
Change colorscheme in `~/.config/nvim/lua/plugins/colorscheme.lua`:

```lua
return {
    {
        -- Alternative: Catppuccin
        "catppuccin/nvim",
        name = "catppuccin",
        config = function()
            require("catppuccin").setup({
                flavour = "mocha", -- latte, frappe, macchiato, mocha
            })
            vim.cmd([[colorscheme catppuccin]])
        end,
    },
    -- Or keep Tokyo Night but change variant
    {
        "folke/tokyonight.nvim",
        config = function()
            require("tokyonight").setup({
                style = "night", -- storm, moon, night, day
            })
            vim.cmd([[colorscheme tokyonight]])
        end,
    }
}
```

## 📦 Adding CLI Packages (Nix / Home Manager, macOS + Ubuntu)

Edit `home.packages` in `home.nix` through chezmoi:

```bash
chezmoi edit ~/.config/home-manager/home.nix
```

```nix
home.packages = with pkgs; [
    jq
    ripgrep
    # ...
    htop  # add a package here
];
```

Search for a package name first with `nix search nixpkgs <name>`. Then deploy and install:

```bash
chezmoi apply   # writes the edited home.nix to ~/.config/home-manager/
hms             # alias for `home-manager switch --flake ~/.config/home-manager --impure`; actually installs it
```

Always edit through `chezmoi edit`/the chezmoi source, not `~/.config/home-manager/home.nix` directly — editing the deployed copy makes it drift from the repo, since chezmoi doesn't know about changes made outside of it.

## 🖥️ Tmux Customization

### Custom Keybindings
Add to `~/.tmux.conf`:

```bash
# Additional key bindings
bind r source-file ~/.tmux.conf \; display "Config reloaded!"
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# Resize panes
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5
```

### Status Line Customization
Customize the status line:

```bash
# Show more information in status line
set -g status-left "#[fg=colour10]#S #[fg=colour8]| "
set -g status-right "#[fg=colour8]%Y-%m-%d #[fg=colour10]%H:%M"
set -g status-left-length 30
set -g status-right-length 30

# Window status with activity monitoring
setw -g monitor-activity on
set -g visual-activity on
```

### Plugin System (TPM)
Add Tmux Plugin Manager for more features:

```bash
# Add to ~/.tmux.conf
# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'

# Initialize TMUX plugin manager
run '~/.tmux/plugins/tpm/tpm'
```

## 💻 WezTerm Customization

### Font Configuration
Edit `~/.wezterm.lua`:

```lua
local wezterm = require 'wezterm'
local config = {}

config.font = wezterm.font('JetBrains Mono Nerd Font', { weight = 'Medium' })
config.font_size = 14

-- Font fallbacks for different scripts
config.font_rules = {
    {
        intensity = 'Bold',
        italic = true,
        font = wezterm.font {
            family = 'JetBrains Mono Nerd Font',
            weight = 'Bold',
            style = 'Italic',
        },
    },
}

return config
```

### Color Scheme
```lua
-- Tokyo Night theme
config.color_scheme = 'Tokyo Night'

-- Or custom colors
config.colors = {
    foreground = '#c0caf5',
    background = '#1a1b26',
    
    cursor_bg = '#c0caf5',
    cursor_border = '#c0caf5',
    cursor_fg = '#1a1b26',
    selection_bg = '#364a82',
    selection_fg = '#c0caf5',
    
    ansi = {
        '#15161e',
        '#f7768e',
        '#9ece6a',
        '#e0af68',
        '#7aa2f7',
        '#bb9af7',
        '#7dcfff',
        '#a9b1d6',
    },
    brights = {
        '#414868',
        '#f7768e',
        '#9ece6a',
        '#e0af68',
        '#7aa2f7',
        '#bb9af7',
        '#7dcfff',
        '#c0caf5',
    },
}
```

### Key Bindings
```lua
config.keys = {
    {
        key = 'T',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.SpawnTab 'CurrentPaneDomain',
    },
    {
        key = 'W',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.CloseCurrentTab { confirm = true },
    },
}
```

## 🎯 Advanced Customizations

### Environment Variables
Add to `~/.zshrc`:

```bash
# Development paths
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# Node.js
export NODE_OPTIONS="--max_old_space_size=8192"

# Editor preferences
export EDITOR="nvim"
export VISUAL="nvim"

# Custom tool configurations
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
```

### Conditional Configurations
Add OS-specific configurations:

```bash
# macOS specific
if [[ "$OSTYPE" == "darwin"* ]]; then
    alias ls='eza --icons --color=always'
    export PATH="/opt/homebrew/bin:$PATH"
fi

# Linux specific
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    alias open='xdg-open'
    alias pbcopy='xclip -selection clipboard'
fi

# WSL specific
if [[ -n "$WSL_DISTRO_NAME" ]]; then
    export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
fi
```

## 🔄 Keeping Customizations

### Using Git Branches
Create a personal branch for your customizations:

```bash
cd ~/dotfiles
git checkout -b personal-customizations
# Make your changes
git add .
git commit -m "Personal customizations"
```

### Override Files
Create override files that won't be tracked:

```bash
# Create personal override files
touch ~/.zsh/config/personal.zsh
touch ~/.config/nvim/lua/personal.lua

# Add to .gitignore
echo "*.personal" >> ~/.gitignore
echo "personal.*" >> ~/.gitignore
```

Load these in your main configs:
```bash
# In ~/.zshrc
[[ -f ~/.zsh/config/personal.zsh ]] && source ~/.zsh/config/personal.zsh

# In ~/.config/nvim/init.lua
pcall(require, 'personal')
```