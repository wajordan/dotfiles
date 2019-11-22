RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"
BLUE="\[\033[0;34m\]"
LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
WHITE="\[\033[1;37m\]"
LIGHT_GRAY="\[\033[0;37m\]"
TEAL="\[\033[0;36m\]"
COLOR_NONE="\[\e[0m\]"

parse_git_branch2() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/[\1]/'
}

parse_git_branch() {
  git rev-parse --git-dir &> /dev/null
  git_status="$(git status 2> /dev/null)"
  branch_pattern="^On branch ([^${IFS}]*)"
  remote_pattern="Your branch is (.*) of"
  diverge_pattern="Your branch and (.*) have diverged"
  if [[ ! ${git_status} =~ "working tree clean" ]]; then
    state="${RED}⚡️ "
  fi
  # add an else if or two here if you want to get more specific
  if [[ ${git_status} =~ ${remote_pattern} ]]; then
    if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
      remote="${WHITE}⬆ "
    else
      remote="${WHITE}⬇ "
    fi
  fi
  if [[ ${git_status} =~ ${diverge_pattern} ]]; then
    remote="${RED}𝌐 "
  fi
  if [[ ${git_status} =~ ${branch_pattern} ]]; then
    branch=${BASH_REMATCH[1]}
    echo " (${branch})${remote}${state}"
  fi
}

PROMPT_COMMAND=prompt_command
prompt_command() {
  PS1="${LIGHT_GREEN}\h   \@ - \d\n${TEAL}\w${YELLOW}$(parse_git_branch)${TEAL}$ ${COLOR_NONE}"
}

export GEMEDITOR=mate

export CLICOLOR="YES"

export LSCOLORS="ExGxFxdxCxDxDxhbadExEx"

#export PATH=/usr/local/packages/git-2.9.2/bin/:${PATH} # Use Git version 2.9.2

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# Load RVM into a shell session
#[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.

#export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
#export PATH="$HOME/.rbenv/shims:$PATH"

export NVM_DIR="$HOME/.nvm"
  . "/usr/local/opt/nvm/nvm.sh"

eval "$(rbenv init -)"

# -- PRY REMOTE USAGE --
# gem install pry-remote
# require 'pry-remote'
# binding.remote_pry
# pry-remote
# exit-program to get out of a loop
