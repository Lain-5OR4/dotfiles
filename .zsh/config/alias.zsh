###### alias ######

# eza
if [[ $(command -v eza) ]]; then
  alias ls='eza --icons'
fi
# normal commands 
alias ..2='cd ../..'
alias ..3='cd ../../..'
alias ..4='cd ../../../..'
alias sudo='sudo '
alias la="eza --icons -a"
alias ll="eza --icons -alF"
alias llt="eza --icons -T -alF"
alias vi="nvim"
alias vim="nvim"
alias view="nvim -R"
alias zshconfig="vim ~/.zshrc"

# git
alias g="git"
alias gc="git commit"
alias gcm="git commit -m"
alias ga="git add"
alias ga-all="git add ."
alias gp="git push"
