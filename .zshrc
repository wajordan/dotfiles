autoload -Uz add-zsh-hook
autoload -Uz vcs_info

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

# Characters
SEGMENT_SEPARATOR="\ue0b0"
PLUSMINUS="\u00b1"
BRANCH="\ue0a0"
DETACHED="𝌐" #"\u27a6"
CROSS="\u274c\ufe0f" # ❌"\u2718"
LIGHTNING="\u26a1\ufe0f" # ⚡️
GEAR="\u2699\ufe0f" # ⚙️
LINEBREAK=$'\n'

prompt_info() {
  print -n "%B%m %@ - %D{%a %b %f}%b"
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
  local color
  is_dirty() {
    test -n "$(git status --porcelain --ignore-submodules)"
  }
  if [[ -n "$REF" ]]; then
    REF="%U%B$REF%b%u"
    if is_dirty; then
      color=yellow
      REF="$REF $LIGHTNING"
    else
      color=green
    fi
    if [[ "$(git status)" =~ "Your branch is (.*) of" ]]; then
      if [[ $match[1] == "ahead" ]]; then
        REF="$REF %F{white}⬆%f "
      else
        REF="$REF %F{white}⬇%f "
      fi
    fi
    if [[ "${REF/.../}" == "$REF" ]]; then
      REF="%U$BRANCH %u$REF"
    else
      color=red
      REF="%U$DETACHED %u${REF/.../}"
    fi
    print -n "%F{$color}$REF $SEGMENT_SEPARATOR%f "
  fi
}

# Status:
# - was there an error
# - are there background jobs?
prompt_status() {
  local symbols
  symbols="%(1?.%{ $CROSS%}.)"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+=" $GEAR"

  [[ -n "$symbols" ]] && print -n "$symbols "
}

prompt_wilbert_precmd() {
  # PS1
  # setopt prompt_subst
  vcs_info
  REF="$vcs_info_msg_0_"
  PROMPT="$(prompt_info)$(prompt_status)$LINEBREAK$(prompt_dir)$(prompt_git)"
  # %(4w.%{%F{yellow}Thursday%f%}.) %j %#

  # RPS1
  # RPROMPT
}

# Scripting
# http://www.csse.uwa.edu.au/programming/linux/zsh-doc/zsh_11.html

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
