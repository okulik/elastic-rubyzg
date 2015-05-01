export EDITOR="sub -w"
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
export PS1='\[\e[1;33m\][\u@\h \W]\$\[\e[0m\] '
export HISTTIMEFORMAT='%F %T '
export HISTCONTROL=ignoredups:ignorespace
export HISTIGNORE="pwd:ls:dir:ls -al:ls -l:h:history"
export LANG=en_US.UTF-8

export EL1=`docker inspect --format '{{ .NetworkSettings.IPAddress }}' el1`
export EL2=`docker inspect --format '{{ .NetworkSettings.IPAddress }}' el2`

man() {
  env \
  LESS_TERMCAP_mb=$(printf "\e[1;31m") \
  LESS_TERMCAP_md=$(printf "\e[1;31m") \
  LESS_TERMCAP_me=$(printf "\e[0m") \
  LESS_TERMCAP_se=$(printf "\e[0m") \
  LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
  LESS_TERMCAP_ue=$(printf "\e[0m") \
  LESS_TERMCAP_us=$(printf "\e[1;32m") \
  man "$@"
}

alias h="history"
alias op='sudo lsof -i -P | grep -i "listen"'
alias gst='git status'
alias gc='git commit'
alias gco='git checkout'
alias gl='git pull'
alias gpom="git pull origin master"
alias gp='git push'
alias gd='git diff | mate'
alias gb='git branch'
alias gba='git branch -a'
alias del='git branch -d'

function take {
  mkdir $1
  cd $1
}