# -*- default-directory: "/Users/william/dotfiles/dev/"; -*-

# shellcheck disable=SC2034

# This file is only meant to be sourced, not run.

# shellcheck disable=SC1091

called=$_
if [[ $called != "$0" ]] ; then
    echo "${BASH_SOURCE[@]} is being sourced."
else
    this_file=$(basename "$0")
    echo "WARNING: $this_file is being run. It is only meant to be sourced."
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
# Ensure Homebrew takes precedence. Add home bin dirs.
PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/local/sbin:/opt/homebrew/opt/mysql-client/bin:$PATH:$HOME/.local/bin:$HOME/local/bin:$HOME/bin:/Users/william/Library/Python/3.11/bin"

# This script adds cargo to PATH.
if [ -f "$HOME/.cargo/env" ]; then
  source "$HOME/.cargo/env"
fi

#######
# AWS #
#######

#export AWS_DEFAULT_PROFILE=sd

#####################
# Virtualenvwrapper #
#####################

WORKON_HOME=$HOME/.local/share/virtualenvs
PROJECT_HOME=$HOME/scm/sd

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

########
# Misc #
########

BREW_PREFIX="$(brew --prefix)"

# See https://github.com/tmux/tmux/issues/284
TMUX_TMPDIR=/tmp

# GREP_OPTIONS="--exclude=*#*"
EDITOR='emacsclient'

# Currently, I don't have Java installed.
# JAVA_HOME=`/usr/libexec/java_home -v 1.8`

# This defines where cd looks for targets
# Add the directories you want to have fast access to, separated by colon
# Ex: CDPATH=".:~:$HOME/projects" will look for targets in the current working directory, in home and in the $HOME/projects folder
# CDPATH="."
CDPATH=":$HOME/scm/sd:$HOME/scm/wjb"

########
# Work #
########

SD_ROOT="$HOME/scm/sd"
SD_BASTION=23.23.70.67

# See https://github.com/typicode/husky/issues/172
HUSKY_SKIP_INSTALL=1

WEBPACK_STATS_VERBOSITY=minimal

set +o allexport

#########
# Local #
#########

[[ -s $HOME/local/.bash_profile ]] && source $HOME/local/.bash_profile

##########
# bashrc #
##########

[[ -s $HOME/.bashrc ]] && source "$HOME/.bashrc"
