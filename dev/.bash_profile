# This file is only meant to be sourced, not run.
called=$_
if [[ $called != $0 ]] ; then
    echo "${BASH_SOURCE[@]} is being sourced."
else
    this_file=`basename "$0"`
    echo "$this_file is being run."
fi

# Each variable or function that is created or modified is given the export
# attribute and marked for export to the environment of subsequent commands.
set -o allexport

########
# Path #
########

# OS X runs `/usr/libexec/path_helper -s` which reads entries from /etc/paths
# and from files in /etc/paths.d.
#
# Initially, PATH is
# /usr/bin:/bin:/usr/sbin:/sbin
#
# Ensure /usr/local takes precendence. Add home bin dirs.
PATH="/usr/local/bin:/usr/local/sbin:$PATH:$(yarn global bin):~/local/bin:~/bin"

#######
# AWS #
#######

#export AWS_DEFAULT_PROFILE=sd

#####################
# Virtualenvwrapper #
#####################

WORKON_HOME=$HOME/env
PROJECT_HOME=$HOME/scm
VIRTUALENVWRAPPER_SCRIPT=/usr/local/bin/virtualenvwrapper.sh

########
# Node #
########

PATH="${PATH}:./node_modules/.bin"

##########
# Python #
##########

PYTHONPATH=":${PYTHONPATH}"

########
# Ruby #
########

# Add RVM to PATH to allow use of rvm command in scripts.
PATH="$PATH:$HOME/.rvm/bin"
PATH="$PATH:/usr/local/Cellar/mysql/5.7.16/bin"

########
# Misc #
########

PATH="$HOME/.cargo/bin:$PATH"

# See https://github.com/tmux/tmux/issues/284
TMUX_TMPDIR=/tmp

GREP_OPTIONS="--exclude=*#*"
EDITOR='emacsclient'
JAVA_HOME=`/usr/libexec/java_home -v 1.8`

# This defines where cd looks for targets
# Add the directories you want to have fast access to, separated by colon
# Ex: CDPATH=".:~:~/projects" will look for targets in the current working directory, in home and in the ~/projects folder
# CDPATH="."
CDPATH='.:~/scm/sd:~/scm/wjb'

SD_BASTION=23.23.70.67

set +o allexport

##########
# bashrc #
##########

[[ -s ~/.bashrc ]] && source ~/.bashrc
