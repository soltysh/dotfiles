# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000
HISTINGORE='ls:bg:fg:history'
HISTTIMEFORMAT='%F %T '

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
#case "$TERM" in
#    xterm-color) color_prompt=yes;;
#    xterm) color_prompt=yes;;
#    screen) color_prompt=yes;;
#    rxvt-unicode-256color) color_prompt=yes;;
#esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

function __prompt_command()
{
    # default colors
    # PS1='${debian_chroot:+($debian_chroot)}\[\e[01;32m\]\u@\h\[\e[00m\]:\[\e[01;34m\]\w\[\e[00m\]\$ '

    EXIT="$?"
    PS1=""

    # command history number in green if ok, red - if not
    if [ $EXIT -eq 0 ]; then PS1+="\[\e[32m\][\!]\[\e[0m\] "; else PS1+="\[\e[31m\][\!]\[\e[0m\] "; fi

    # if logged in via ssh shows the ip of the client
    # if [ -n "$SSH_CLIENT" ]; then PS1+="\[\e[1;33m\](${SSH_CLIENT/ */})\[\e[0m\] "; fi

    # debian chroot stuff (take it or leave it)
    PS1+='${debian_chroot:+($debian_chroot)}'

    # basic information (user@host:path)
    PS1+='\[\e[32m\]\u\[\e[0m\]@\[\e[32m\]\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\] '

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
        PS1+="\[$Color_On\][$branch]\[\e[0m\] "
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
        PS1+="\[$Color_On\][$branch]\[\e[0m\] "
    fi

    if [[ "$VIRTUAL_ENV" != "" ]]; then
        PS1+="\[\e[1;30m\]($(basename $VIRTUAL_ENV))\[\e[0m\] "
    fi

    # prompt $ or # for root
    PS1+='\n\$ '
}

if [ "$color_prompt" = yes ]; then
    PROMPT_COMMAND=__prompt_command
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
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

function git-fetch()
{
    repos="$@"
    if [ "$repos" == "" ]; then
        repos=$(ls -d */)
    fi
    base_dir=$(pwd)
    echo -e "Fetching upstream for the following repos:\n\e[1;31m"$repos"\e[0m"

    for repo_name in $repos
    do
        if [ -d $base_dir/$repo_name ]; then
            echo -e "\e[1;31mProcessing "$repo_name"\e[0m"
            pushd $base_dir/$repo_name > /dev/null
            stashed=false
            git diff-index --quiet HEAD
            if [ $? -ne 0 ]; then
                git stash
                stashed=true
            fi
            git checkout master
            git fetch upstream
            git fetch upstream --tags
            git rebase upstream/master
            git push origin master --force
            git push --tags
            if $stashed; then
                git stash pop
            fi
            popd > /dev/null
        fi
    done
}

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias ack='ack-grep'
alias t='todo.sh -d $HOME/.config/todo/config'
complete -F _todo t

alias dates='TZ="Asia/Shanghai" date; date; TZ="America/New_York" date; TZ="America/Los_Angeles" date'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# virutalenvwrapper configuration
export WORKON_HOME=$HOME/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh

# bash variables
export EDITOR=vim
export GOPATH=$HOME/workspace/go
export PATH=$HOME/usr/bin:$HOME/.rbenv/bin:$GOPATH/bin:$PATH
eval "$(rbenv init -)"

