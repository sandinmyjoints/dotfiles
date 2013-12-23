# Initially, PATH is /usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/X11/bin
#
# Ensure usr/local takes precendence. Add home bin dirs.
PATH="/usr/local/bin:/usr/local/sbin:$PATH:~/local/bin:~/bin"
export PATH

export PYTHONPATH=/usr/local/Cellar/python/2.7.3/lib/python2.7/site-packages:$PYTHONPATH

# Virtualenvwrapper
export WORKON_HOME=$HOME/env
export PROJECT_HOME=$HOME/scm
source /usr/local/bin/virtualenvwrapper.sh

export EDITOR='emacsclient'

# git
function parse_git_branch {
  ref=$(git-symbolic-ref HEAD 2> /dev/null) || return
  echo "("${ref#refs/heads/}")"
}

source ~/bin/git-completion.bash

source ~/bin/git-prompt.sh
export PS1='\w$(__git_ps1 " (%s)")\$ '
#export PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '

#source /usr/local/lib/node_modules/npm/lib/utils/completion.sh

if [ -f ~/.bash_aliases ]; then
. ~/.bash_aliases
fi

# Sublime

subl_open () {
 NAME="$(basename $(pwd))"
 open "../${NAME}.sublime-project"
}

# Ruby
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

# Store original PS1
ORIG_PS1=$PS1

# Add rvm terminal prompt.
alias rvm_ps1="export PS1=\"(\$(rvm-prompt v g s)) ${ORIG_PS1}\""
# Issue rvm use command and change terminal prompt.
rvm_use () {
    rvm use $@ && rvm_ps1;
}

# Node
export NODE_LATEST=0.10.20
source ~/.nvm/nvm.sh
export PATH="${PATH}:./node_modules/.bin"

# NVM
nvm_ps1 () {
    # Original:
    # export PS1="(nvm $(nvm version)) ${ORIG_PS1}"

    # Set $VERSION, then manually do ANSI colors:
    nvm_version
    export PS1="(nvm \[$(tput setaf 4)\]$VERSION\[$(tput sgr0)\]) ${ORIG_PS1}"
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

### Added by the Heroku Toolbelt
export PATH="$PATH:/usr/local/heroku/bin"

# Clojure/Clojurescript
export CLOJURESCRIPT_HOME=$HOME/scm/vendor/clojurescript
export PATH=$PATH:$CLOJURESCRIPT_HOME/bin

# ADT
export PATH=$PATH:"/Users/william/Downloads/adt-bundle-mac-x86_64-20130219/sdk/platform-tools"

ulimit -n 10000

#export JAVA_HOME=`/usr/libexec/java_home`

function tabname {
  printf "\e]1;$1\a"
}

function winname {
  printf "\e]2;$1\a"
}
