# -*- default-directory: "/Users/william/dotfiles"; -*-
# For mosh, see https://github.com/mobile-shell/mosh/issues/102#issuecomment-12503646
export PATH=/usr/local/bin:$PATH

# Bail silently (do NOT echo anything) if run in a non-interactive shell (like
# by scp). See:
# http://thomas-cokelaer.info/blog/2011/09/scp-does-not-work-wrong-bashrc/
[ -z "$PS1" ] && return

# This file is only meant to be sourced, not run.
called=$_
if [[ $called != $0 ]] ; then
    [ -z "$SSH_TTY" ] && echo "${BASH_SOURCE[@]} is being sourced."
else
    this_file=`basename "$0"`
    [ -z "$SSH_TTY" ] && echo "$this_file is being run."
fi

#################
# Sensible Bash #
#################

if [ -f ~/dotfiles/dev/sensible.bash ]; then
   source ~/dotfiles/dev/sensible.bash
fi

# This sets both hard and soft limits, so cannot be raised past 10000.
ulimit -n 10000

shopt -s extglob
shopt -s globstar

# From: https://serverfault.com/questions/506612/standard-place-for-user-defined-bash-completion-d-scripts
# see https://unix.stackexchange.com/questions/204803/why-is-nullglob-not-default
# Turning it off for now.
# shopt -s nullglob

############
# Homebrew #
############

BREW_PREFIX=$(brew --prefix)

###############
# Completions #
###############

# bash completion 1.x, which is now unlinked.
# if [ -f $BREW_PREFIX/etc/bash_completion ]; then
#     source $BREW_PREFIX/etc/bash_completion
# fi

# bash completion 2.

# I think the below script does the same thing, possibly in a more generally compatible way.
# if [ -f /usr/local/share/bash-completion/bash_completion ]; then
#  . /usr/local/share/bash-completion/bash_completion
# fi

# Lots of completions installed in /usr/local/etc/bash_completion.d, that
# seems to be a default place. Do I need to manually source them all? -> I
# think the below entrypoint script will do it. See
# https://stackoverflow.com/a/14970926/599258

# To check whether completions are in there for some package: $ ll $BASH_COMPLETION_COMPAT_DIR | grep yarn

# This script seems to be the official entrypoint. It's smart enough to look
# for the specific script in /usr/local/Cellar/bash-completion@2/2.8/
export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" && ( -z "$INSIDE_EMACS" || "$EMACS_BASH_COMPLETE" = "t" ) ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

# Docker completion is described here: https://docs.docker.com/docker-for-mac/#bash

complete -C aws_completer aws

. ~/.local/share/bash-completion/completions/django

#https://github.com/dsifford/yarn-completion
. ~/.local/share/bash-completion/completions/yarn

. ~/dotfiles/dev/alias_completion.bash

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

#################
# node/nvm/npm/yarn #
#################

# Preferred method of installing Yarn: brew install yarn --without-node
#
# See: https://yarnpkg.com/lang/en/docs/install/#mac-stable
#
# This install it once for the whole system, so it does not and should not be
# installed globally per node installation.
#
# See: https://yarnpkg.com/lang/en/docs/cli/global/
#
# $ yarn global dir
# /Users/william/.config/yarn/global
#
# This is where global bins will be symlinked.
# $ yarn config set prefix ~/.yarn
# $ yarn global bin
# /Users/william/.yarn/bin


# Examples
# nvm run v8.11.3 -e "console.log(\"hello\")"
# nvm exec v8.11.3 npm -v
# nvm exec v8.11.3 bash -c 'npm -v'

# Run a command on every local node installation.
# Usage (use quotes around the command):
# every_node v8.11.3 'npm -v'
# every_node v8.11.3 'yarn global list yarn'
# Problems:
# - nvm ls output is not clean
# - bash function rest args: how?
# function every_node {
#     version=$1
#     command=$2
#     version='v8.11.3'
#     # nvm exec "$version" bash -c "$command"
#     nvm exec "$version" "$command"
# }

function npmtop () {
    npm list -g --depth=0
}

alias npm_globals=npmtop

function npmls () {
    npm ls --depth=0
}

# See ~/.nvm/default-packages
#
function npm_install_globals () {
   #npm install -g npm@2.15.1
    npm install -g $(cat ~/.nvm/default-packages)
}

function yarn_install_globals () {
    echo "yarn does not have different globals per version of node. Use npm_install_globals instead."
    exit 1
    yarn global add $(cat ~/.nvm/default-packages)
}

##########
# Travis #
##########

# [ -f /Users/william/.travis/travis.sh ] && source /Users/william/.travis/travis.sh

####################
# Functions
####################

function emacs_usr2 {
    kill -USR2 "$(pgrep -f emacs-mac)"
}

function dired {
    emacsclient -e "(dired \"$1\")"
}

function dirtree {
    echo Adding "$PWD" to dirtree.
    CMD="(dirtree \"$PWD\" t)"
    emacsclient -e "$CMD"
}

# emacs-pipe is a shell script in /bin.

function fix-tmux () {
    killall -USR1 tmux
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

function gitcp {
    git diff | pbcopy
}

function fix_camera {
    sudo killall VDCAssistant
}

# based on https://superuser.com/a/742984/93702
function fix_audio {
    sudo kextunload /System/Library/Extensions/AppleHDA.kext
    sudo kextload /System/Library/Extensions/AppleHDA.kext

    # probably not needed unless audio is actively playing:
    # ps aux | grep 'coreaudio[d]' | awk '{print $2}' | xargs sudo kill
}

function result {
    curl -s "localhost:2100/slim/result/$1" | jq ;
}

function ssb {
    ssh -t sd-bastion ssh -A $1
}

function ssht {
    ssh -t "$@" "/usr/local/bin/tmux attach-session -t mine || /usr/local/bin/tmux new-session -s mine"
}

alias moshi='LANG=en_US.UTF-8 mosh --server=/usr/local/bin/mosh-server'

function jsondiff {
    diff <(jq -S . $1) <(jq -S . $2)
}

function base64decode {
    echo "$1" | base64 --decode ; printf '\n'
}

# $ scale_image orig.jpg orig-small.jpg
#
# imagemagick can do lots of cool stuff, see: #
# https://stackoverflow.com/a/31726270/599258
function scale_image {
    convert $1 -resize '50%' $2
}

# $ thumb image.jpg 300 200
# $ thumb "$(last_screenshot)" 800
# $ shot i | thumb 300
# see: https://www.imagemagick.org/Usage/thumbnails/#cut
# See also: mogrify, which works on whole directories
function thumb {
    local fullfile="$1"
    local filename=$(basename -- "$fullfile")
    local extension="${filename##*.}"
    local filename="${filename%.*}"

    local width="$2"
    local height="$3"

    convert "$fullfile" -auto-orient -thumbnail "$width"x"$height" -unsharp 0x.5 "$filename"-thumb."$extension"
}

# Usage: $ neodict_for en Africa
function neodict_for {
    # $ curl -sS 'http://site1.spanishdict.com/api/v1/dictionary?q=Africa&source=en' | jq -r '.data.neodict' | jq
    curl -sS "http://site1.spanishdict.com/api/v1/dictionary?q=$2&source=$1" | jq -r '.data.neodict' | jq
}

# Usage: $ img 1500 1800 jpg
function img {
    filename="$1x$2.$3"
    curl -sS -o "$filename" "https://via.placeholder.com/$filename"
    ls -l "$filename"
}

function curljq {
    url="$1"
    curl -sS "$url" | jq '.'
}

# For reference:
# $ shasum -a 256 <file>

# Pretty-print PATH.
function ppath {
    echo $PATH | tr : '\n'
}

# From: https://unix.stackexchange.com/a/14896
# De-dupe PATH.
function pathmerge {
    export ORIGINAL_PATH="$PATH"
    export PATH=$(printf "%s" "$PATH" | awk -v RS=':' '!a[$1]++ { if (NR > 1) printf RS; printf $1 }')
    echo $PATH
}

# Prettier for formatting markdown that works even when no node is in the
# current PATH. But it's slow, because nvm is slow.
function gp {
    yarn_global_bin_path=$(nvm exec --silent "lts/*" yarn global bin)
    nvm exec "lts/*" $yarn_global_bin_path/prettier --parser markdown
}

# Usage: ecs-restart prod-sd-site prod-sd-site-public-2
function ecs-restart {
    local cluster="$1"
    local service="$2"
    ( [[ -z "${cluster// }" ]] || [[ -z "${service// }" ]] ) && echo "Usage: ecs-restart <cluster> <service>" && return 1

    command="aws ecs update-service --cluster $cluster --service $service --force-new-deployment --region us-east-1"
    echo $command
    eval $command
}

########
# Misc #
########

# From http://superuser.com/a/59198
[[ $- = *i* ]] && bind TAB:menu-complete

# Use Homebrew's Python.
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python2
export VIRTUALENVWRAPPER_VIRTUALENV=/usr/local/bin/virtualenv
source /usr/local/bin/virtualenvwrapper_lazy.sh

# TODO: move these completions stuff up to completions section
complete -C aws_completer aws

. ~/.local/share/bash-completion/completions/django

source ~/dotfiles/dev/bash_colors.sh
source ~/dotfiles/dev/.bash_prompt
source ~/dotfiles/dev/nvm-startup.sh
source ~/dotfiles/dev/alias_completion.bash

# source '/opt/homebrew-cask/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc'
# source '/opt/homebrew-cask/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc'

# added by pipsi (https://github.com/mitsuhiko/pipsi)
export PATH="/Users/william/.local/bin:$PATH"

#########
# Local #
#########

[[ -s ~/local/.bashrc ]] && source ~/local/.bashrc
