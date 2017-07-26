# This file is only meant to be sourced, not run.
called=$_
if [[ $called != $0 ]] ; then
    echo "${BASH_SOURCE[@]} is being sourced."
else
    this_file=`basename "$0"`
    echo "$this_file is being run."
fi

#################
# Sensible Bash #
#################

if [ -f ~/dotfiles/dev/sensible.bash ]; then
   source ~/dotfiles/dev/sensible.bash
fi

ulimit -n 10000

shopt -s extglob
shopt -s globstar

############
# Homebrew #
############

BREW_PREFIX=$(brew --prefix)

if [ -f $BREW_PREFIX/etc/bash_completion ]; then
    source $BREW_PREFIX/etc/bash_completion
fi

#######
# git #
#######

function parse_git_branch {
  ref=$(git-symbolic-ref HEAD 2> /dev/null) || return
  echo "("${ref#refs/heads/}")"
}

if [ -f ~/bin/git-completion.bash ]; then
    source ~/bin/git-completion.bash
fi

if [ -f $BREW_PREFIX/etc/bash_completion.d/git-prompt.sh ]; then
    source $BREW_PREFIX/etc/bash_completion.d/git-prompt.sh
else
    source ~/bin/git-prompt.sh
fi

PS1='\w$(__git_ps1 " (%s)")\$ '

###########
# Aliases #
###########

if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

###########
# Sublime #
###########

subl_open () {
 local NAME="$(basename $(pwd))"
 open "../${NAME}.sublime-project"
}

########
# Ruby #
########

# Load RVM into a shell session *as a function*.
#
# TODO: Might be better to handle this like nvm, in its own script with an alias to run it.
# Could run it automatically in ops Terminal windows.
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

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

#######
# npm #
#######

function npmtop () {
    npm list -g --depth=0
}

alias npm_globals=npmtop

# START USING:
# nvm install v5.0 --reinstall-packages-from=4.2
# OR SEE ~/.nvm/default-packages
# OR DO $ yarn global add $(cat ~/.nvm/default-packages)
#
# npm global packages I want:
# $ npm ls -g --depth=0
# $ npmtop
# /Users/william/.nvm/versions/node/v4.6.1/lib
# ├── @spanishdict/fun-with-examples@4.2.0 -> /Users/william/scm/sd/fun-with-examples
# ├── browser-perf@1.4.11
# ├── browserslist@1.3.3
# ├── budo@8.3.0
# ├── cleaver@0.8.2
# ├── coffeelint@1.15.7
# ├── disc@1.3.2
# ├── elasticdump@2.4.2
# ├── eslint@2.13.1
# ├── eslint-plugin-promise@1.3.2
# ├── eslint-plugin-standard@1.3.2
# ├── express-generator@4.13.4
# ├── grunt-cli@1.2.0
# ├── http-server@0.9.0
# ├── js-beautify@1.6.3
# ├── json-diff@0.3.1
# ├── jsonlint@1.6.2
# ├── node-inspector@0.12.8
# ├── npm@2.15.9
# ├── standard-format@2.2.2
# ├── surge@0.18.0
# ├── tzloc@1.3.1
# ├── uncss@0.14.1
# ├── unicode-10.0.0@0.7.4
# └── wd@0.4.0

function npm_install_globals () {
   #npm install -g npm@2.15.1
   npm install -g bower budo browserslist cleaver coffeelint eslint eslint-config-standard eslint-plugin-standard express-generator grunt-cli http-server json-diff jsonlint node-inspector surge tzloc standard-format
}

##########
# Travis #
##########

# [ -f /Users/william/.travis/travis.sh ] && source /Users/william/.travis/travis.sh

####################
# Functions
####################

function fix-tmux () {
    killall -USR1 tmux
}

function emacs_usr2 {
    kill -USR2 $(pgrep -f emacs)
}

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

function synonym () {
    wn $1 -syns{n,v,a,r}
}

function echoDjangoSettings () {
    echo $DJANGO_SETTINGS_MODULE
}

function urlencode () {
    local url=$1
    python -c "import sys,urllib;print urllib.quote('${url}'.strip())" | tee pbcopy
}

function git_find () {
    git log -G $1 --source --all
}

function fix_camera {
    sudo killall VDCAssistant
}

########
# Misc #
########

source /usr/local/bin/virtualenvwrapper_lazy.sh

source /Users/william/.dvm/dvm.sh
source /Users/william/.dvm/bash_completion

#[[ -s "$(brew --prefix dvm)/dvm.sh" ]] && source "$(brew --prefix dvm)/dvm.sh"
#[[ -s "$(brew --prefix dvm)/bash_completion" ]] && source "$(brew --prefix dvm)/bash_completion"

complete -C aws_completer aws

# From http://superuser.com/a/59198
[[ $- = *i* ]] && bind TAB:menu-complete

#############
# Reference #
#############

# Useful commands for checking what process is using a port. TODO: Make into functions.
# See sockets-netstat and sockets-lsof scripts.
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

# TODO don't hardcode these.
source ~/dotfiles/dev/bash_colors.sh
source ~/dotfiles/dev/.bash_prompt
