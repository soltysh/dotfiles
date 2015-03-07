# history settings
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt histappend

setopt nomatch

unsetopt appendhistory autocd beep extendedglob notify

# use emacs keys
bindkey -e

function __prompt_command()
{
    EXIT="$?"
    PROMPT=""

    # command history number in green if ok, red - if not
    if [ $EXIT -eq 0 ]; then PROMPT+="\[\e[32m\][\!]\[\e[0m\] "; else PROMPT+="\[\e[31m\][\!]\[\e[0m\] "; fi

    # if logged in via ssh shows the ip of the client
    # if [ -n "$SSH_CLIENT" ]; then PROMPT+="\[\e[1;33m\](${SSH_CLIENT/ */})\[\e[0m\] "; fi

    # debian chroot stuff (take it or leave it)
    PROMPT+='${debian_chroot:+($debian_chroot)}'

    # basic information (user@host:path)
    PROMPT+='\[\e[32m\]\u\[\e[0m\]@\[\e[32m\]\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\] '

    # add git display to prompt
    local git_status="`git status -unormal 2>&1`"
    if ! [[ "$git_status" =~ Not\ a\ git\ repo ]]; then
        # repository in unmodified state
        if [[ "$git_status" =~ nothing\ to\ commit ]]; then
            local Color_On="\e[32m"
        # modified files already present in repository
        elif [[ "$git_status" =~ no\ changes\ added\ to\ commit ]]; then
            local Color_On="\e[35m"
        # new files in repository
        else
            local Color_On="\e[31m"
        fi
        # brach info
        if [[ "$git_status" =~ On\ branch\ ([^[:space:]]+) ]]; then
            branch=${BASH_REMATCH[1]}
        else
            # Detached HEAD. (branch=HEAD is a faster alternative.)
            branch="`git describe --all --contains --abbrev=4 HEAD 2> /dev/null || echo HEAD`"
        fi
        PROMPT+="\[$Color_On\][$branch]\[\e[0m\] "
    fi

    # add mercurial display to prompt
    local hg_status="`hg status 2>&1`"
    if ! [[ "$hg_status" =~ no\ repository\ found ]]; then
        # repository in unmodified state
        if [[ "$hg_status" == "" ]]; then
            local Color_On="\e[32m"
        # modified files already present in repository
        elif [[ "$hg_status" =~ ^M\  ]]; then
            local Color_On="\e[35m"
        # new files in repository
        else
            local Color_On="\e[31m"
        fi
        # branch info
        branch="`hg branch 2> /dev/null || echo HEAD`"
        PROMPT+="\[$Color_On\][$branch]\[\e[0m\] "
    fi

    if [[ "$VIRTUAL_ENV" != "" ]]; then
        PROMPT+="\[\e[1;30m\]($(basename $VIRTUAL_ENV))\[\e[0m\] "
    fi

    # prompt $ or # for root
    PROMPT+='\n\$ '
}

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ack='ack-grep'

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/soltysh/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

export EDITOR=vim
export GOPATH=$HOME/workspace/go
export PATH=$HOME/usr/bin:$HOME/.rbenv/bin:$GOPATH/bin:$PATH
#eval "$(rbenv init -)"

