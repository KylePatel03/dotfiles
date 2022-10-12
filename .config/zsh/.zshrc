export PS1='%F{blue}%~%f %F{green}$%f '

# History Options
export HISTFILE="$XDG_CACHE_HOME/zsh_history"
export HISTCONTROL="ignorespace:ignoredups:erasedups"
#export HISTIGNORE="history:sudo*:gpg*:cd*:ls*"
export HISTORY_IGNORE="(ls|ls *|cd|cd *|gpg *|echo *|history|sudo *|#*)"
export HISTSIZE="10000000"
export SAVEHIST="10000000"

# Report usage for long commands
export REPORTTIME=90

setopt histfindnodups histignoredups appendhistory histignorespace

# Enable colors and change prompt:
autoload -U colors && colors	# Load colors

# Options
setopt printexitvalue interactivecomments nomatch menucomplete

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
# Tab complete hidden files
_comp_options+=(globdots)

source "$ZDOTDIR/zsh-functions"
zsh_add_file "zsh-vim"
zsh_add_file "zsh-aliases"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"

## Keybindings ##

# Bindings prefixed by ctrl
bindkey -s '^o' 'fo\n'
bindkey -s '^f' 'lfcd\n'
bindkey -s '^h' 'hist\n'
bindkey -s '^l' 'clear\n'

# Edit line in vim with ctrl-e
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/kyle/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
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

