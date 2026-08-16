# ZSH ALIASES CONFIGURATION

# FILE LISTING COMMANDS (eza)
# ezaコマンドが利用可能な場合のエイリアス設定
if [[ $(command -v eza) ]]; then
  alias ls='eza --icons'                    # 基本的なls（アイコン付き）
  alias la='eza --icons -a'                 # 隠しファイルも表示
  alias ll='eza --icons -alF'               # 詳細表示（長いリスト形式）
  alias llt='eza --icons -T -alF'           # ツリー形式で表示
fi

# DIRECTORY NAVIGATION
# 親ディレクトリへの移動ショートカット
alias ..2='cd ../..'                       # 2階層上へ移動
alias ..3='cd ../../..'                    # 3階層上へ移動
alias ..4='cd ../../../..'                 # 4階層上へ移動

# EDITOR ALIASES
# Neovim関連のエイリアス
alias vi='nvim'                            # vi → nvim
alias vim='nvim'                           # vim → nvim
alias view='nvim -R'                       # 読み取り専用モードでnvim起動

# SYSTEM COMMANDS
# システムコマンドの改良
alias sudo='sudo '                         # sudoの後でエイリアスを有効にする

# CONFIGURATION FILE SHORTCUTS
# 設定ファイルの編集ショートカット
alias zshconfig='vim ~/.zshrc'             # zshrc設定を編集

# GIT ALIASES は .zsh/config/abbr.zsh に移行済み（zsh-abbrによる展開型に変更）

# NIX / HOME MANAGER
# Home Manager関連のエイリアス
# --impure は flake.nix が builtins.currentSystem でOS/CPUを実行時検出するために必須
# (mac/Ubuntu間で同じコマンドにするためのトレードオフ)
alias hms='home-manager switch --flake ~/.config/home-manager --impure' # home.nix変更を反映
