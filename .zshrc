# ═══════════════════════════════════════════════════════════════════════════════
# POWERLEVEL10K INSTANT PROMPT
# ═══════════════════════════════════════════════════════════════════════════════
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# HISTORY CONFIGURATION
# ═══════════════════════════════════════════════════════════════════════════════
HISTFILE=$HOME/.zsh-history # 履歴を保存するファイル
HISTSIZE=100000             # メモリ上に保存する履歴のサイズ
SAVEHIST=1000000            # ファイルに保存する履歴のサイズ

# 履歴の共有設定
setopt inc_append_history   # 実行時に履歴をファイルに追加していく
setopt share_history        # 履歴を他のシェルとリアルタイム共有する

# ═══════════════════════════════════════════════════════════════════════════════
# COMPLETION CONFIGURATION
# ═══════════════════════════════════════════════════════════════════════════════
# 補完機能を有効化
autoload -Uz compinit && compinit

# 補完候補の大文字小文字を区別しない
# そのまま探す -> 小文字を大文字に -> 大文字を小文字に変換して探す
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' '+m:{[:upper:]}={[:lower:]}'

# 補完方法毎にグループ化
zstyle ':completion:*' format '%B%F{blue}%d%f%b'
zstyle ':completion:*' group-name ''

# 補完候補のハイライト設定
zstyle ':completion:*'              list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:messages'     format "$YELLOW" '%d' "$DEFAULT"
zstyle ':completion:*:warnings'     format "$RED" 'No matches for:' "$YELLOW" '%d' "$DEFAULT"
zstyle ':completion:*:descriptions' format "$YELLOW" 'Completing %B%d%b' "$DEFAULT"
zstyle ':completion:*:corrections'  format "$YELLOW" '%B%d% ' "$RED" '(Errors: %e)%b' "$DEFAULT"

# 補完候補の区切り文字とマニュアルセクション
zstyle ':completion:*'         list-separator ' ==> '
zstyle ':completion:*:manuals' separate-sections true

# 補完候補をメニューから選択する
# select=2: 補完候補が2つ以上なければすぐに補完、2つ以上なら一覧から選択
zstyle ':completion:*:default' menu select=2

# ═══════════════════════════════════════════════════════════════════════════════
# SHELL OPTIONS
# ═══════════════════════════════════════════════════════════════════════════════
# ディレクトリ名のみでディレクトリ移動を可能にする
setopt auto_cd

# Ctrl+S、Ctrl+Qによるフロー制御を無効化
setopt no_flow_control

# ═══════════════════════════════════════════════════════════════════════════════
# EXTERNAL CONFIGURATIONS
# ═══════════════════════════════════════════════════════════════════════════════
# エイリアス設定を読み込み
source ~/.zsh/config/alias.zsh

# Powerlevel10kの設定を読み込み
# カスタマイズは `p10k configure` で設定可能
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ═══════════════════════════════════════════════════════════════════════════════
# ZINIT PLUGIN MANAGER
# ═══════════════════════════════════════════════════════════════════════════════
# Zinitの自動インストール
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

# Zinitの読み込み
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# 重要なannexesを読み込み（Turboモードなし）
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# ═══════════════════════════════════════════════════════════════════════════════
# ZSH PLUGINS
# ═══════════════════════════════════════════════════════════════════════════════
# 補完候補を自動提案
zinit light zsh-users/zsh-autosuggestions

# 高速なシンタックスハイライト
zinit light zdharma-continuum/fast-syntax-highlighting

# 追加の補完機能
zinit light zsh-users/zsh-completions

# ディレクトリ移動履歴（z コマンド）
zinit light agkozak/zsh-z

# batコマンド（catの代替）をバイナリとしてインストール
zinit ice as"program" from"gh-r" mv"bat* -> bat" pick"bat/bat"
zinit light sharkdp/bat

# Powerlevel10k テーマを読み込み
zinit ice depth"1" # git clone depth
zinit light romkatv/powerlevel10k

# ═══════════════════════════════════════════════════════════════════════════════
# CUSTOM FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════════
# manページのシンタックスハイライト
man() {
    env \
        LESS_TERMCAP_mb=$(printf "\e[1;33m") \
        LESS_TERMCAP_md=$(printf "\e[1;33m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[1;32m") \
        man "$@"
}

# ═══════════════════════════════════════════════════════════════════════════════
# DEVELOPMENT TOOLS
# ═══════════════════════════════════════════════════════════════════════════════
# Bun（JavaScriptランタイム）の設定
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "/Users/lain/.bun/_bun" ] && source "/Users/lain/.bun/_bun"

# Envman（環境変数管理）の設定
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# ═══════════════════════════════════════════════════════════════════════════════
# COMMAND LINE TOOLS
# ═══════════════════════════════════════════════════════════════════════════════
# Atuin（シェル履歴管理）の設定
. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"

# Claude Code CLI のエイリアス
alias claude="/Users/lain/.claude/local/claude"
