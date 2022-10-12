#!/usr/bin/env bash

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

######################################################################
# Shell Options

set -o vi
shopt -s checkwinsize
shopt -s cmdhist # Save multiline command as the same history entry
shopt -s expand_aliases
shopt -s histappend

# Clear screen with Ctrl l
bind -m vi-insert "\C-l":clear-screen
######################################################################
# Functions

# Fuzzy find and open a file
fo () {
   start_dir="${1:-$PWD}"
   file="$(find "$start_dir" -type f | fzf)"
   [ -f "$file" ] && xdg-open "$file"
}

# Fuzzy find and cd into a directory
fcd () {
   start_dir="${1:-$PWD}"
   dir="$(find "$start_dir" -type d | fzf)"
   [ -d "$dir" ] && cd "$dir"
}

# Copy the argument (file/directory) to the clipboard for pasting
getpath () {
   [ -z "$1" ] && exit 1
   realpath "$1" | xclip -i -selection "clipboard"
}


# Make a directory and cd into it
mcdir () {
   mkdir -pv "$1" && cd "$1" || exit
}

# Display history and copy selection to the clipboard
hist () {
   history | uniq | fzf --no-sort --tac | sed -En "s/^\s+[0-9]+\s+(.*)$/\1/p" | tr -d "\n" | xclip -sel c
}

######################################################################
# Aliases

alias cp='cp -iv'
alias egrep='grep -E --color=auto'
alias gpg='gpg --homedir $GNUPGHOME'
alias grep='grep --color=auto'
alias journalctl='journalctl -r'
alias ll='ls -lh --color=auto --group-directories-first'
alias lla='ls -lAh --color=auto --group-directories-first'
alias ls='ls -h --color=auto --group-directories-first'
alias mv='mv -iv'
alias nvidia-settings='nvidia-settings --config="$XDG_CONFIG_HOME/nvidia/.nvidia-settings-rc"'
alias rm='rm -iv'
alias sc='shellcheck'
alias sxiv='nsxiv'
alias vim='nvim'
alias wget='wget --hsts-file="$XDG_CACHE_HOME/.wget-hsts"'

######################################################################

# History
export HISTCONTROL="ignorespace:ignoredups:erasedups"
export HISTIGNORE="history:sudo*:gpg*"
# Infinite history
export HISTSIZE="-1"
export HISTFILESIZE="-1"
export HISTFILE="$XDG_CACHE_HOME/bash_history"
export LESSHISTFILE="-"

force_color_prompt=yes
color_prompt=yes

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# Colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/kyle/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/kyle/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/kyle/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/kyle/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
