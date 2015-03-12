# history settings
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory
setopt HIST_IGNORE_DUPS

setopt nomatch

unsetopt autocd beep extendedglob notify

# use emacs keys
bindkey -e

#    if [[ "$VIRTUAL_ENV" != "" ]]; then
#        PROMPT+="\[\e[1;30m\]($(basename $VIRTUAL_ENV))\[\e[0m\] "
#    fi
#

setopt PROMPT_SUBST
# prompt configuration
autoload -Uz vcs_info colors && colors
# enable git & mecurial
zstyle ':vcs_info:*' enable git hg
# check for changes
zstyle ':vcs_info:(hg*|git*):*' check-for-changes true
# this needs to be enabled for changes to be seen in mecurial
zstyle ':vcs_info:hg*:*' get-revision true
# message format
zstyle ':vcs_info:(hg*|git*):*' formats "(%s)%F{green}%u-[%b]-"
# action format
zstyle ':vcs_info:(hg*|git*):*' actionformats "(%s)%F{green}%u-[%a:%b]-"
# branch format
zstyle ':vcs_info:(hg*|git*):*' branchformat "%b"
# unstaged string
zstyle ':vcs_info:(hg*|git*):*' unstagedstr "%F{red}"
precmd() {
    vcs_info
}
PROMPT="%(?,%F{green},%F{red})[%!]%f %F{green}%n%f@%F{green}%m%f:"$'%{\e[1;34m%}%~%f ${vcs_info_msg_0_}%f\n$ '

# autocompletion
autoload -Uz compinit
compinit

# useful aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ack='ack-grep'

# useful environment variables
export EDITOR=vim
export GOPATH=$HOME/workspace/go
export PATH=$HOME/usr/bin:$HOME/.rbenv/bin:$GOPATH/bin:$PATH
#eval "$(rbenv init -)"

