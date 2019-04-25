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

# Load RVM into a shell session
#[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.

#export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
#export PATH="$HOME/.rbenv/shims:$PATH"

#export PATH=/usr/local/packages/git-2.9.2/bin/:${PATH} # Use Git version 2.9.2

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

export NVM_DIR="$HOME/.nvm"
  . "/usr/local/opt/nvm/nvm.sh"

eval "$(rbenv init -)"

alias redis-start="launchctl load ~/Library/LaunchAgents/homebrew.mxcl.redis.plist"
alias redis-stop="launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.redis.plist"

# To enable automatic start for Redis, PostgreSQL, and RabbitMQ, make a series of
# symlinks from the brew-installed services to the LaunchAgents folder for your user.
#
# ln -sfv /usr/local/opt/redis/*.plist ~/Library/LaunchAgents/

alias restart="touch tmp/restart.txt ; echo 'restarted pow server'";
alias webpackr="./bin/webpack-dev-server";
alias crdb="bundle exec rails db";
alias server="php -S localhost:3000"
alias be="bundle exec"
alias fixtestdb="bundle exec rake db:drop db:create RAILS_ENV=test;bundle exec rake db:test:prepare;"
alias dps="docker ps --format 'table {{.Names}}\t{{.Command}}\t{{.Status}}\t{{.RunningFor}}' --no-trunc"

# -- PRY REMOTE USAGE --
# gem install pry-remote
# require 'pry-remote'
# binding.remote_pry
# pry-remote
# exit-program to get out of a loop
