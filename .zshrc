declare -a greetings=("what is good my dude" "let us get this bread" "t(._.t)")
len=${#greetings[@]}
rand=$[(RANDOM)%$len]
# echo -e "\e[1;5;31m${greetings[rand+1]}"
export ZSH="$HOME/.oh-my-zsh"
plugins=(git)
source $ZSH/oh-my-zsh.sh

export NVM_DIR="$HOME/.nvm"
export TERM="xterm-256color"

# Lazyload Node.js - NVM and npm
lazynvm() {
  unset -f nvm node npm
  export NVM_DIR=~/.nvm
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
  nvm use default
}

nvm() {
  lazynvm
  nvm $@
}

node() {
  lazynvm
  node $@
}

npm() {
  lazynvm
  npm $@
}

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

export CLICOLOR=1
export LSCOLORS="DxGxxxxxbxxxbxbxFxFx"

function powerline_precmd() {
  PS1="$(powerline-shell --shell zsh $?)"
}

function install_powerline_precmd() {
  for s in "${precmd_functions[@]}"; do
    if [ "$s" = "powerline_precmd" ]; then
      return
    fi
  done
  precmd_functions+=(powerline_precmd)
}

if [ "$TERM" != "linux" ]; then
  install_powerline_precmd
fi

alias whereami=hostname
alias tidalvim="TIDAL_BOOT_PATH=~/configs/Tidal.ghci tidalvim"

export TERM=screen-256color
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
