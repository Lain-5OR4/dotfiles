###### alias ######

# exa
if [[ $(command -v exa) ]]; then
  alias ls='exa --icons'
fi
# normal commands 
alias ..2='cd ../..'
alias ..3='cd ../../..'
alias ..4='cd ../../../..'
alias sudo='sudo '
alias la="exa --icons -a"
alias ll="exa --icons -alF"
alias llt="exa --icons -T -alF"
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