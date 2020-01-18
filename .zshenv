# Prepare common environment variables
export BLOCKSIZE=K
less --version 2>&1 >/dev/null && export PAGER=less
# export HISTFILE=/Users/william/.zsh_history
# export HISTSIZE=2000
# export EDITOR=vi
# export GEMEDITOR=vim
export COLORTERM=yes
export GIT_EDITOR='vim --noplugin'
export SVN_EDITOR='vim --noplugin'
export CLICOLOR=1
export LSCOLORS=CxFxExDxBxegedabagacad
# export SPRINT=true

# NVM: Node Version Manager
export NVM_DIR="$HOME/.nvm"
  . "/usr/local/opt/nvm/nvm.sh"

# enable psql
export PATH=${PATH}:/usr/local/opt/postgresql@9.5/bin

PATH=$PATH:$HOME/.local/bin
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

# export POW_WORKERS=4
# export JRUBY_OPTS="--1.9"
# export CLASSPATH=~/src/weka-3-7-10/weka.jar:~/src/ABAGAIL/ABAGAIL.jar:~/src/burlap/lib/\*:~/src/burlap/dist/burlap.jar
# export GOPATH=$HOME/go

# GOVERSION=$(brew list go | head -n 1 | cut -d '/' -f 6)
# export GOROOT=$(brew --prefix)/Cellar/go/$GOVERSION/libexec
# export FZF_DEFAULT_COMMAND='ag -g ""'
# export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
