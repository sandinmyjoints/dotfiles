########
# Path #
########

# Initially, PATH is /usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/X11/bin
# TODO: Define PATH in .bash_profile?
#
# Ensure usr/local takes precendence. Add home bin dirs.
export PATH="/usr/local/bin:/usr/local/sbin:$PATH:~/local/bin:~/bin"

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

source ~/bin/git-completion.bash
source ~/bin/git-prompt.sh
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

export NODE_LATEST=0.10.28
source ~/.nvm/nvm.sh
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

nvm_use () {
    VERS=${1:-''}
    source ~/.nvm/nvm.sh
    if [ ${VERS} ]; then
        nvm use ${VERS}
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

. <(npm completion)

function npmtop () {
    npm list -g --depth=0
}

########
# Misc #
########

export HISTIGNORE=' *'

export EDITOR='emacsclient'

ulimit -n 10000

### Added by the Heroku Toolbelt
export PATH="$PATH:/usr/local/heroku/bin"

# These don't work inside of tmux. Why not?
function tabname {
  printf "\e]1;$1\a"
}

function winname {
  printf "\e]2;$1\a"
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
