# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

export PATH="$PATH:~/local/bin:~/bin"

export HISTIGNORE=' *'

shopt -s extglob

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

nodename () {
    cat /etc/chef/client.rb |egrep node_name | cut -f 2 -d ' ' | sed "s/\"//g"
}
CHEF_NODENAME=`nodename`

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

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
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
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

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@$CHEF_NODENAME\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@$CHEF_NODENAME:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@$CHEF_NODENAME: \w\a\]$PS1"
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

# some more ls aliases
alias ll='ls -ahlF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

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

# Useful sysadmin functions.
#
# usage: greplog <logprefix> <pattern>
#
# When there's a lot, use with head -n to grab n lines:
#
# $ greplog suggest '"warning"' | head -n 30
#
greplog () {
  {
      nice zcat $(ls -rt $1.log.*.gz || ls /dev/null)  # Matches <prefix>.log.XXXX.gz
      nice cat $(ls -rt $1.*[0-9] || ls /dev/null) # Matches <prefix>.log.X
      nice cat $(ls $1.log || ls /dev/null)  # Matches <prefix>.log
  } | nice grep -E "$2"
}

# Adds 5 lines of context.
greplog5 () {
  {
      nice zcat $(ls -rt $1.log.*.gz || ls /dev/null)  # Matches <prefix>.log.XXXX.gz
      nice cat $(ls -rt $1.*[0-9] || ls /dev/null) # Matches <prefix>.log.X
      nice cat $(ls $1.log || ls /dev/null)  # Matches <prefix>.log
  } | nice grep -E -C 5 "$2"
}

# IP addresses for our machine translation providers. These could change.
#
PROMT_IP="72\.55\.171\.23"
SDL_IP="207\.38\.17\.15"

# The ports MongoLab assigned our Fluencia databases. These could change.
#
MONGOLAB_PROD_PORT="55997"
MONGOLAB_STAGING_PORT="39477"

conns_mysql () {
    netstat -a | grep -E -o "mysql.*" | sort | uniq -c
}

conns_promt () {
    netstat -a | grep -E -o $PROMT_IP | uniq -c
}

conns_sdl () {
    netstat -a | grep -E -o $SDL_IP | uniq -c
}

conns_timewait () {
    netstat --inet -a | grep -E -o "TIME_WAIT" | uniq -c
}

conns_prod_mongo () {
    sudo netstat --inet -ap | grep -E -o MONGOLAB_PROD_PORT | uniq -c
}

conns_staging_mongo () {
    sudo netstat --inet -ap | grep -E -o MONGOLAB_STAGING_PORT | uniq -c
}

conns_mysql_open () {
    echo Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
    sudo netstat -ap | grep -E "mysql.*" | grep -E -v TIME_WAIT
}

conns_promt_open () {
    echo Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
    sudo netstat -ap | grep -E $PROMT_IP | grep -E -v TIME_WAIT
}

conns_sdl_open () {
    echo Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
    sudo netstat -ap | grep -E $SDL_IP | grep -E -v TIME_WAIT
}

conns_all_open () {
    echo Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
    sudo netstat -ap | grep -E "($SDL_IP|$PROMT_IP)" | grep -E -v TIME_WAIT
}


# TODO
conns_which () {
    echo Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
    sudo netstat --inet -aenp  | grep -E PROMT_IP
}

conns_open_per_service () {
    conns_all_open|wc -l
}

conns_open_per_worker () {
    conns_all_open|wc -l
}

get_dropbox_uploader () {
    mkdir -p ~/bin && curl "https://raw.github.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh" -o ~/bin/dropbox_uploader.sh && chmod u+x ~/bin/dropbox_uploader.sh
}

# Local customizations.
[[ -s ~/.bashrc_local ]] && source ~/.bashrc_local

conns_darwin () {
    netstat -at|grep -E ":http " | wc  -l
}

conns_site () {
    netstat -at|grep -E ":8001 " | wc  -l
}

conns_darwin_not_time_wait () {
    netstat -at|grep -E ":http " | grep -E -v "TIME_WAIT" | wc  -l
}

conns_site_not_time_wait () {
    netstat -at|grep -E ":8001 " | grep -E -v "TIME_WAIT" | wc  -l
}

apache_status () {
    curl http://localhost/server-status?auto
}

# Number of tcp ports open:
#
# $ ss -s # can do basically the same thing
#
open_tcp_count () {
    netstat -ant|wc -l
}

# Open ports and the process that has opened them:
open_ports () {
    sudo netstat -pan --tcp
}


count_file_handles () {
    sudo lsof -i |grep node
}

total_open_fds () {
    sudo ps -eL | awk 'NR > 1 { print $1, $2 }' | \
    while read x; do \
        sudo find /proc/${x% *}/task/${x#* }/fd/ -type l; \
    done | wc -l
}

total_node_open_fds () {
    sudo ps -eL | grep node | awk 'NR > 1 { print $1, $2 }' | \
    while read x; do \
        sudo find /proc/${x% *}/task/${x#* }/fd/ -type l; \
    done | wc -l
}

per_node_open_fds () {
    sudo ps -eL | grep node | awk 'NR > 1 { print $1, $2 }' | \
    while read x; do \
        echo "${x% *}";
        sudo find /proc/${x% *}/task/${x#* }/fd/ -type l | wc -l
    done
}

per_node_open_fds () {
    sudo ps -ef | grep node | awk 'NR > 1 { print $2, $8 }' | \
    while read x; do \
      echo "${x}:"
      sudo ls /proc/${x% *}/fd | wc -l;
      echo "--------"
    done
}

psnode () {
    ps -ef|grep -v grep|grep node
}

alias scr='screen -dRR'
