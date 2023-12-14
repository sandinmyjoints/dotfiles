# This file is only meant to be sourced, not run.
called=$_
if [[ $called != $0 ]] ; then
    echo "${BASH_SOURCE[@]} is being sourced."
else
    this_file=`basename "$0"`
    echo "WARNING: $this_file is being run. It is only meant to be sourced."
fi

# Sensible Bash - An attempt at saner Bash defaults
# Maintainer: mrzool <http://mrzool.cc>
# Version: 0.1

## GENERAL OPTIONS ##

# Prevent file overwrite on stdout redirection
set -o noclobber

# Update window size after every command
shopt -s checkwinsize

# Automatically trim long paths in the prompt (requires Bash 4.x)
PROMPT_DIRTRIM=2

## SMARTER TAB-COMPLETION (Readline bindings) ##
if [[ ${SHELLOPTS} =~ (vi|emacs) ]]; then  # see https://superuser.com/a/1361068/93702

    # Perform file completion in a case insensitive fashion
    bind "set completion-ignore-case on"

    # Treat hyphens and underscores as equivalent
    bind "set completion-map-case on"

    # Display matches for ambiguous patterns at first tab press
    bind "set show-all-if-ambiguous on"

    bind "set bell-style visible"
    bind "set visible-stats on"
    bind "set mark-symlinked-directories on"
fi
## SANE HISTORY DEFAULTS ##

# Append to the history file, don't overwrite it
shopt -s histappend

# Save multi-line commands as one command
shopt -s cmdhist

# Record each line as it gets issued
PROMPT_COMMAND='history -a'

# Huge history. Doesn't appear to slow things down, so why not?
HISTSIZE=500000
HISTFILESIZE=100000

# Avoid duplicate entries
HISTCONTROL="erasedups:ignoreboth"

# Don't record some commands
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history"

# Useful timestamp format
HISTTIMEFORMAT='%F %T '

## BETTER DIRECTORY NAVIGATION ##

# Prepend cd to directory names automatically
shopt -s autocd
# Correct spelling errors during tab-completion
shopt -s dirspell
# Correct spelling errors in arguments supplied to cd
shopt -s cdspell

# This allows you to bookmark your favorite places across the file system.
# Define a variable containing a path and you will be able to cd into it regardless of the directory you're in.
# Dislike.
# shopt -s cdable_vars

# Examples:
# export dotfiles="$HOME/dotfiles"
# export projects="$HOME/projects"
# export documents="$HOME/Documents"
# export dropbox="$HOME/Dropbox"
