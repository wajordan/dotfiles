autoload -Uz add-zsh-hook
autoload -Uz vcs_info
zmodload zsh/datetime

# allows parameter expansion, arithmatic, and shell substitution in prompts
setopt prompt_subst

# still cd when you forget to type cd
setopt auto_cd

# history tweaks
# unsetopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
# setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
# setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt APPEND_HISTORY            # append to history file
setopt HIST_NO_STORE             # Don't store history commands

# up/down arrow key history search based on text entered in prompt
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

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
STAR="🌟"
BR=$'\n' # Line Break

# Machine/Username > Date → Time
prompt_info() {
  local name logo
  # %F{232}%m%f Machine Name
  name=`whoami`
  name="${name:0:1:u}${name:1}"
  logo="%K{33} %F{255}%m%f %k%K{255}%F{33}\u25e4%f %B%F{black}$name%f%b %k%K{black}%F{255}$SEGMENT_SEPARATOR%f%k"
  print -n "$logo %B%D{%A %b %f → }${${$(date +"%l:%M %p")#" "}:l}%b"
}

# Countdown to next sprint. Whooo!
get_days_left() {
  local sdate edate daze
  sdate="Thu Jan 02 00:00:00 2020"
  edate=$(date +'%a %b %d %T %Y')
  for v ({s,e}date) strftime -rs $v '%a %b %d %T %Y' ${(P)v}
  daze=$(( 14 - (((edate - sdate) / 86400) % 14) ))
  if [[ daze -gt 11 ]]; then
    daze=$(( $daze - 4 ))
  elif [[ daze -eq 11 ]]; then
    daze=$(( $daze - 3 ))
  elif [[ $daze -gt 4 ]]; then
    daze=$(( $daze - 2 ))
  elif [[ $daze -eq 4 ]]; then
    daze=$(( $daze - 1 ))
  fi
  print -n $daze
}

prompt_sprint() {
  local days inflection
  days=$(get_days_left)
  [[ $days == 1 ]] && inflection="day" || inflection="days"

  print -n "%F{236}$days%f%F{235} $inflection left%f"
}

prompt_dawn() {
  local days_left new_day hist_test one dos tree
  # "$(history -t "%a %b %d %Y" -1)" =~ "(.*) $(date +'%a %b %d %Y')"
  hist_test="$(fc -lnt "%a %b %d %Y" -2 -2 | grep "$(date +'%a %b %d %Y')")"
  if [[ -z ${hist_test// } ]]; then
    days_left=$(get_days_left)
    case $days_left in
      10 )
        new_day="   %BThe First Day%b";;
      9 )
        new_day="  %BThe Second Day%b";;
      8 )
        new_day="   %BThe Third Day%b";;
      7 )
        new_day="  %BThe Fourth Day%b";;
      6 )
        new_day="   %BThe Fifth Day%b";;
      5 )
        new_day="   %BThe Sixth Day%b";;
      4 )
        new_day="  %BThe Seventh Day%b";;
      3 )
        new_day="  %BThe Eighth Day%b";;
      2 )
        new_day="   %BThe Ninth Day%b";;
      1 )
        new_day="   %BThe Final Day%b";;
    esac

    one="%K{yellow}%F{black}$SEGMENT_SEPARATOR%f%k%K{black}%F{yellow}$SEGMENT_SEPARATOR%f%k"
    dos="%K{red}%F{black}$SEGMENT_SEPARATOR%f%k%K{black}%F{red}$SEGMENT_SEPARATOR%f%k"
    tree="%K{green}%F{black}$SEGMENT_SEPARATOR%f%k%K{black}%F{green}$SEGMENT_SEPARATOR%f%k"
    print -l "%F{white}      Dawn of   %f$one" "%F{magenta}$new_day %f $dos" "%F{white}- $(( 8 * $days_left )) Hours Remain -%f $tree"
  fi
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
  [[ -z "$REF" ]] && directory+=" $SEGMENT_SEPARATOR"

  print -n "%F{cyan}$directory%f "
}

prompt_git() {
  local color git_status
  is_dirty() {
    test -n "$(git status --porcelain --ignore-submodules)"
  }
  on_master() {
    [[ "$REF" =~ "(.*)%Bmaster%b" ]] && print -n "$STAR "
  }
  if [[ -n "$REF" ]]; then
    git_status="$(git status)"
    REF="%U%B$REF%b%u"
    color=green
    if is_dirty; then
      color=yellow
      REF="$REF $LIGHTNING"
    fi
    if [[ "$git_status" =~ "Your branch is (.*) of" && $match[1] == "ahead" ]]; then
      color=22
      REF="$REF %F{white}⬆%f "
    fi
    if [[ "$git_status" =~ "Your branch is (.*) 'origin/" && $match[1] == "behind" ]]; then
      color=22
      REF="$REF %F{white}⬇%f "
    fi
    if [[ "$git_status" =~ "Your branch and (.*) have diverged" ]]; then
      color=22
      REF="$REF $DIVERGED "
    fi
    if [[ "${REF/.../}" == "$REF" ]]; then
      REF="%U$BRANCH %u$REF"
    else
      color=red
      REF="%U$DETACHED %u${REF/.../}"
    fi
    if [[ $color == green ]]; then
      REF="$REF%U %u%F{$color}$SEGMENT_SEPARATOR%f"
    else
      REF="$REF %F{$color}$SEGMENT_SEPARATOR%f"
    fi

    print -n "$(on_master)%F{$color}$REF%f "
  fi
}

prompt_wilbert_precmd() {
  local dawn
  vcs_info
  REF="$vcs_info_msg_0_"

  if [[ $SPRINT == true ]]; then
    dawn=$(prompt_dawn)

    # RPS1
    # %(4w.%{%F{yellow}Thursday%f%}.) %j %#
    RPROMPT="$(prompt_sprint)"
  fi

  # PS1
  PROMPT="${dawn:+$dawn$BR}$(prompt_info)$(prompt_status)$BR$(prompt_dir)$(prompt_git)"
}

# Scripting
# man zshbuiltins
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
# https://stackoverflow.com/questions/22537804/retrieve-a-word-after-a-regular-expression-in-shell-script

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
