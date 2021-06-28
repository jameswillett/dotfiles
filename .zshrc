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
# Swagger ui preview
function swagger_yaml2json() {
  TMP_DIR="/tmp/vim-swagger-preview/"
  LOG=$TMP_DIR"validate.log"
  docker run  --rm -v $(pwd):/docs openapitools/openapi-generator-cli validate -i /docs/"$1" > $LOG 2>&1
  count=$(wc -l < $LOG)
  if [[ $count -gt 2 ]]; then
    # File exists and has a size greater than zero
    return 1
  else
    if grep -q "docker daemon running" $LOG; then
      return 2
    else
      # dump the stdout stderr to file otherwise the caller function complains
      docker run -v $(pwd):/docs -v $TMP_DIR:/out openapitools/openapi-generator-cli generate -i /docs/"$1" -g openapi -o /out > $LOG 2>&1
      # clear the log file
      cp /dev/null $LOG
      # https://github.com/swagger-api/swagger-codegen/issues/9140
     # docker run -v $(pwd):/docs -v $TMP_DIR:/out swaggerapi/swagger-codegen-cli-v3:3.0.9 generate -i /docs/"$1" -l openapi -o /out > /dev/null 2>&1
      return 0

    fi
  fi
}
function swagger_ui_start() {
    CONTAINER_NAME=${1:-swagger-ui-preview}
    TMP_DIR="/tmp/vim-swagger-preview/"
    # VOLUME=$(echo $(pwd) | tr "/" "_")
    if [ ! "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
        if [ "$(docker ps -aq -f status=exited -f name=$CONTAINER_NAME)" ]; then
            echo $CONTAINER_NAME "exited, cleaning"
            # cleanup
            # echo removing: 
            docker rm $CONTAINER_NAME
        fi
        # run the container
        docker run --name $CONTAINER_NAME -d -p 8017:8080 -e SWAGGER_JSON=/docs/openapi.json -v $TMP_DIR:/docs swaggerapi/swagger-ui
    elif [ "$(docker ps -aq -f status=running -f name=$CONTAINER_NAME)" ]; then
            echo $CONTAINER_NAME "is already running"
    fi
}
function swagger_preview() {
    TMP_DIR="/tmp/vim-swagger-preview/"
    LOG=$TMP_DIR"validate.log"
    SOURCE=${1:-swagger.yaml}
    $(swagger_yaml2json $SOURCE)
    YAML2JSON_RETURN_CODE=$?
    if [ "$YAML2JSON_RETURN_CODE" -eq "0" ]; then
      swagger_ui_start
    else
      cat $LOG
      echo "Converting to json failed!"
    fi
}
