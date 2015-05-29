########
# Path #
########

# Initially, PATH is /usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/X11/bin
# TODO: Define PATH in .bash_profile?
#
# Ensure usr/local takes precendence. Add home bin dirs.
export PATH="/usr/local/bin:/usr/local/sbin:$PATH:~/local/bin:~/bin"


export JAVA_HOME=`/usr/libexec/java_home -v 1.8`

#####################
# Virtualenvwrapper #
#####################

export WORKON_HOME=$HOME/env
export PROJECT_HOME=$HOME/scm
source /usr/local/bin/virtualenvwrapper.sh

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

# Store original PS1
ORIG_PS1=$PS1

# Add rvm terminal prompt.
alias rvm_ps1="export PS1=\"(\$(rvm-prompt v g s)) ${ORIG_PS1}\""

# Issue rvm use command and change terminal prompt.
rvm_use () {
    rvm use $@ && rvm_ps1;
}

########
# Node #
########

export NODE_LATEST=0.10.38

# If I set nvm default, then nvm.sh will add it to PATH. Then Emacs
# nvm.el is always going to find and use that version, even if I try
# to switch it. So for now, I'm not setting nvm default.

source ~/.nvm/nvm.sh

# nvm deactivate  # Can be useful if nvm default is set.

export PATH="${PATH}:./node_modules/.bin"

#######
# NVM #
#######

nvm_ps1 () {
    # Original:
    # export PS1="(nvm $(nvm version)) ${ORIG_PS1}"

    # Set $NVM_VERSION, then manually do ANSI colors:
    local NVM_VERSION=`nvm_version`
    export PS1="(nvm \[$(tput setaf 4)\]$NVM_VERSION\[$(tput sgr0)\]) ${ORIG_PS1}"
}

## nvm_use stable
## nvm_use system
nvm_use () {
    VERS=${1:-''}
    # source ~/.nvm/nvm.sh # Not needed if called earlier.
    if [ ${VERS} ]; then
        nvm use ${VERS}
        . <(npm completion)
        nvm_ps1
    else
        echo "Choose a version:"
        nvm ls
    fi
}

nvm_quit () {
    nvm deactivate
    nvm_ps1
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
# /Users/william/.nvm/v0.10.38/lib
# ├── @spanishdict/sd-language@2.1.0 -> /Users/william/scm/sd/sd-language
# ├── bower@1.4.1
# ├── cleaver@0.7.4
# ├── coffeelint@1.9.6
# ├── eslint@0.20.0
# ├── express-generator@4.12.1
# ├── http-server@0.8.0
# ├── jsonlint@1.6.2
# ├── node-inspector@0.10.1
# ├── npm@2.5.1
# └── tzloc@1.0.1#

function install_globals () {
   npm install -g bower coffeelint eslint express-generator jsonlint node-inspector http-server cleaver
}

########
# Misc #
########

export HISTIGNORE=' *'

export EDITOR='emacsclient'

ulimit -n 10000

shopt -s extglob
shopt -s globstar

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

##########
# Travis #
##########

[ -f /Users/william/.travis/travis.sh ] && source /Users/william/.travis/travis.sh

# Useful commands for checking what process is using a port. TODO: Make into functions.
#netstat -anp tcp | grep 3000
#lsof -i tcp:3000

# How to stop tracking a git remote.
# TODO: Make a function or script
# git branch -d -r origin/BRANCH
# git push origin :BRANCH
# git config --unset branch.BRANCH.remote
# git config --unset branch.BRANCH.merge

# script / col
# $ script -q
# $ col -bp <typescript | less

# tar -cvzf tarballname.tar.gz itemtocompress
