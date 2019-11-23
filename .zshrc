autoload -Uz add-zsh-hook
autoload -Uz vcs_info
zmodload zsh/datetime

# allows parameter expansion, arithmatic, and shell substitution in prompts
setopt prompt_subst

add-zsh-hook precmd prompt_wilbert_precmd

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes false
zstyle ':vcs_info:git*' formats '%b'
zstyle ':vcs_info:git*' actionformats '%b (%a)'

# Load Git completion
FILE=~/.zsh/.git-completion.zsh
if [[ -f "$FILE" ]]; then
  zstyle ':completion:*:*:git:*' script ~/git-completion.bash
  fpath=(~/.zsh $fpath)

  autoload -Uz compinit && compinit
fi

# COLORS:
# black, red, green, yellow, blue, magenta, cyan and white

# Characters
SEGMENT_SEPARATOR="\ue0b0"
PLUSMINUS="\u00b1"
BRANCH="\ue0a0"
DETACHED="\u27a6"
DIVERGED="\u2049\ufe0f" # ⁉️
CROSS="\u274c\ufe0f" # ❌"\u2718"
LIGHTNING="\u26a1\ufe0f" # ⚡️
GEAR="\u2699\ufe0f" # ⚙️
DIAMOND="💎"
LINEBREAK=$'\n'

# Machine Name, Time - Date
prompt_info() {
  # local name
  # name=`whoami`
  # %F{232}${name:s/wajordan/Wilbert}%f
  print -n "%B%F{232}%m%f %@ - %D{%a %b %f}%b"
}

# Countdown to next sprint. Whooo!
prompt_sprint() {
  local sdate edate days
  sdate="Thu Nov 07 00:00:00 2019"
  edate=`date "+%a %b %d %T %Y"`
  for v ({s,e}date) strftime -rs $v '%a %b %d %T %Y' ${(P)v}
  days=$(( 14 - (((edate - sdate) / 86400) % 14) ))
  if [[ $days -gt 10 ]]; then
    days=$(( $days - 4 ))
  elif [[ $days -gt 3 ]]; then
    days=$(( $days - 2 ))
  fi
  # %(4w.%{%F{yellow}Thursday%f%}.) %j %# 
  print -n "%F{234}$days%f %F{233}days left%f"
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  print -n "%(1?.%{ $CROSS%}.)%(!.%{ $DIAMOND%}.)%(1j.%{ %j $GEAR%}.)"
}

prompt_dir() {
  local directory
  directory="%~"
  # -n string: true if length of string is non-zero
  # -z string: true if length of string is zero
  if [[ -z "$REF" ]] && directory+=" $SEGMENT_SEPARATOR"

  print -n "%F{cyan}$directory%f "
}

prompt_git() {
  local color git_status
  is_dirty() {
    test -n "$(git status --porcelain --ignore-submodules)"
  }
  if [[ -n "$REF" ]]; then
    git_status="$(git status)"
    REF="%U%B$REF%b%u"
    if is_dirty; then
      color=yellow
      REF="$REF $LIGHTNING"
    else
      color=green
    fi
    if [[ "$git_status" =~ "Your branch is (.*) of" && $match[1] == "ahead" ]]; then
      REF="$REF %F{white}⬆%f "
    fi
    if [[ "$git_status" =~ "Your branch is (.*) 'origin/" && $match[1] == "behind" ]]; then
      REF="$REF %F{white}⬇%f "
    fi
    if [[ "$git_status" =~ "Your branch and (.*) have diverged" ]]; then
      REF="$REF $DIVERGED "
    fi
    if [[ "${REF/.../}" == "$REF" ]]; then
      REF="%U$BRANCH %u$REF"
    else
      color=red
      REF="%U$DETACHED %u${REF/.../}"
    fi
    print -n "%F{$color}$REF%f %F{$color}$SEGMENT_SEPARATOR%f "
  fi
}

prompt_wilbert_precmd() {
  vcs_info
  REF="$vcs_info_msg_0_"

  # PS1
  PROMPT="$(prompt_info)$(prompt_status)$LINEBREAK$(prompt_dir)$(prompt_git)"

  # RPS1
  RPROMPT="$(prompt_sprint)"
}

# Scripting
# https://github.com/rothgar/mastering-zsh
# https://github.com/zsh-users
# http://zsh.sourceforge.net/Doc/Release/index.html#Top
# https://github.com/LeCoupa/awesome-cheatsheets/blob/master/languages/bash.sh
# http://www.csse.uwa.edu.au/programming/linux/zsh-doc/zsh_toc.html
# https://medium.com/@oliverspryn/adding-git-completion-to-zsh-60f3b0e7ffbc
# https://github.com/powerline/fonts
# https://gist.github.com/pbrisbin/45654dc74787c18e858c
# https://github.com/git/git/tree/master/contrib/completion
# https://github.com/denysdovhan/spaceship-prompt
# https://github.com/agnoster/agnoster-zsh-theme
# https://scriptingosx.com/2019/06/moving-to-zsh/
# https://jonasjacek.github.io/colors/

# Read in a common environment configuration if present
# -f file: true if file exists and is a regular file.
[[ -f "$HOME/.zshenv" ]] && . "$HOME/.zshenv"

# Import aliases
[[ -s "$HOME/.aliases" ]] && . "$HOME/.aliases"

# rbenv: Ruby version manager
eval "$(rbenv init -)"

# Docker
# -s file: true if file exists and has size greater than zero.
[[ -s "~/.dockercfg" ]] && . "~/.dockercfg"

# -- PRY REMOTE USAGE --
# gem install pry-remote
# require 'pry-remote'
# binding.remote_pry
# pry-remote
# exit-program to get out of a loop

# -- screen for terminal --
# crtl-a '   (select)
# crtl-a 0   (select 0)
# crtl-a S   (split horizontally)
# crtl-a \   (quit) Kill all windows and terminate screen.
# crtl-a ?   (help)
# crtl-a C   (create)
# crtl-a tab (switch split screens)
