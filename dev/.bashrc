########
# Path #
########

# Initially, PATH is /usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/X11/bin
# TODO: Define PATH in .bash_profile?
#
# Ensure usr/local takes precendence. Add home bin dirs.
export PATH="/usr/local/bin:/usr/local/sbin:$PATH:~/local/bin:~/bin"


export JAVA_HOME=`/usr/libexec/java_home -v 1.8`
export CDPATH='.:~/scm/sd:~/scm/wjb'

#####################
# Virtualenvwrapper #
#####################

export WORKON_HOME=$HOME/env
export PROJECT_HOME=$HOME/scm
export VIRTUALENVWRAPPER_SCRIPT=/usr/local/bin/virtualenvwrapper.sh
source /usr/local/bin/virtualenvwrapper_lazy.sh

# Sensible Bash

if [ -f ~/bin/sensible.bash ]; then
   source ~/bin/sensible.bash
fi

#######
# git #
#######

function parse_git_branch {
  ref=$(git-symbolic-ref HEAD 2> /dev/null) || return
  echo "("${ref#refs/heads/}")"
}

if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
else
    source ~/bin/git-completion.bash
fi

if [ -f $(brew --prefix)/etc/bash_completion.d/git-prompt.sh ]; then
    . $(brew --prefix)/etc/bash_completion.d/git-prompt.sh
else
    source ~/bin/git-prompt.sh
fi

export PS1='\w$(__git_ps1 " (%s)")\$ '

###########
# Aliases #
###########

if [ -f ~/.bash_aliases ]; then
. ~/.bash_aliases
fi

###########
# Sublime #
###########

subl_open () {
 NAME="$(basename $(pwd))"
 open "../${NAME}.sublime-project"
}

##########
# Python #
##########

export PYTHONPATH=":${PYTHONPATH}"

########
# Ruby #
########

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
export PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

rvm_use () {
    export SHOW_RVM=true
    rvm use $@;
}

rvm_deactivate () {
    unset SHOW_RVM
}

rvm_quit () {
    rvm_deactivate
}

########
# Node #
########

export NODE_LATEST=0.10.44

[[ -s ~/local/node-latest ]] && source ~/local/node-latest

# If I set nvm default, then nvm.sh will add it to PATH. Then Emacs
# nvm.el is always going to find and use that version, even if I try
# to switch it. So for now, I'm not setting nvm default.

source ~/.nvm/nvm.sh

# nvm deactivate  # Can be useful if nvm default is set.

export PATH="${PATH}:./node_modules/.bin"

#######
# NVM #
#######

## nvm_use stable
## nvm_use system
nvm_use () {
    VERS=${1:-''}
    # source ~/.nvm/nvm.sh # Not needed if called earlier.
    if [ ${VERS} ]; then
        nvm use ${VERS}
        . <(npm completion)
    else
        echo "Choose a version:"
        nvm ls
    fi
}

nvm_quit () {
    nvm deactivate
}

nvm_deactivate() {
    nvm_quit
}


#######
# npm #
#######

function npmtop () {
    npm list -g --depth=0
}

alias npm_globals=npmtop

# npm global packages I want:
# $ npm ls -g --depth=0
# $ npmtop
# /Users/william/.nvm/v0.10.40/lib
# ├── @spanishdict/fun-with-examples@3.0.3 -> /Users/william/scm/sd/fun-with-examples
# ├── @spanishdict/sd-language@2.1.0 -> /Users/william/scm/sd/sd-language
# ├── bower@1.4.1
# ├── cleaver@0.7.4
# ├── coffeelint@1.10.1
# ├── doctoc@0.14.2
# ├── eslint@1.1.0
# ├── eslint-config-standard@4.0.0
# ├── eslint-plugin-standard@1.2.0
# ├── express-generator@4.13.1
# ├── grunt-cli@0.1.13
# ├── http-server@0.8.0
# ├── jsonlint@1.6.2
# ├── node-inspector@0.12.2
# ├── npm@2.14.8
# ├── surge@0.14.3
# └── tzloc@1.2.0

####
# But try this next time: nvm install v4.2 --reinstall-packages-from=iojs
###

function npm_install_globals () {
   npm install -g npm@2.14.14
   npm install -g bower cleaver coffeelint eslint eslint-config-standard eslint-plugin-standard express-generator grunt-cli http-server jsonlint node-inspector surge tzloc
}

########
# Misc #
########

complete -C aws_completer aws

export EDITOR='emacsclient'

ulimit -n 10000

shopt -s extglob
shopt -s globstar

# From http://superuser.com/a/59198
[[ $- = *i* ]] && bind TAB:menu-complete

### Added by the Heroku Toolbelt
export PATH="$PATH:/usr/local/heroku/bin"

# These don't work inside of tmux. Why not?
function tabname {
  printf "\e]1;$1\a"
}

function winname {
  printf "\e]2;$1\a"
}

man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;246m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}

function quick-whois () {
    command whois "domain ${1}"
}

##########
# Travis #
##########

# [ -f /Users/william/.travis/travis.sh ] && source /Users/william/.travis/travis.sh


#########
# Other #
#########

function fix-tmux () {
    killall -USR1 tmux
}

function synonym () {
    wn $1 -syns{n,v,a,r}
}

# See https://github.com/tmux/tmux/issues/284
export TMUX_TMPDIR=/tmp

# Useful commands for checking what process is using a port. TODO: Make into functions.
# $ netstat -anp tcp | grep 3000
# $ lsof -i tcp:3000

# script / col
# $ script -q
# $ col -bp <typescript | less

# How to tar and gzip:
# $ tar -cvzf tarballname.tar.gz itemtocompress

#########
# Local #
#########

[[ -s ~/local/.bashrc ]] && source ~/local/.bashrc
