# This file is only meant to be sourced, not run.
called=$_
if [[ $called != $0 ]] ; then
    echo "${BASH_SOURCE[@]} is being sourced."
else
    this_file=`basename "$0"`
    echo "WARNING: $this_file is being run. It is only meant to be sourced."
fi

#######
# NVM #
#######

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Make it so the first time node is run, it will activate itself. The proper way
# to start using node is to run nvm_use first, but sometimes node itself will be
# run before nvm_use is run. Because nvm_use unaliases node, here we guarantee
# it's an alias before unaliasing it to prevent an error message from unalias
# about node not being found. :shrug:
alias node='nvm_use default; alias node=n; unalias node; node $@'

# Keep track of whether it's the first time nvm is used/node is run.
export nvm_has_been_used=0

# If I set nvm default, then nvm.sh will add it to PATH. Then Emacs
# nvm.el is always going to find and use that version, even if I try
# to switch it. So for now, I'm not setting nvm default.
#
# nvm alias default $NODE_LATEST

# nvm deactivate  # Can be useful if nvm default is set.

## nvm_use stable
## nvm_use system
nvm_use () {
    VERS=${1:-''}
    # source ~/.nvm/nvm.sh # Not needed if called earlier.
    if [ ${VERS} ]; then
        [[ "$nvm_has_been_used" -eq "0" ]] && unalias node
        nvm use "${VERS}"
        . <(npm completion)
    else
        echo "Choose a version:"
        nvm ls
    fi

    # TODO: not clear to me whether I should have yarn in PATH or not. For now,
    # putting it in whenever node is going to be used (ie, nvm is started).
    # https://github.com/yarnpkg/yarn/issues/648
    #
    [[ "$nvm_has_been_used" -eq "0" ]] && nvm_has_been_used=1
}

alias nvmuse=nvm_use

nvm_quit () {
    nvm deactivate
}

nvm_deactivate() {
    nvm_quit
}

# npm bin --global returns the path to directory its node is in
# export PATH="$PATH:$(npm bin --global)"

function nvm_use_if_needed () {
    [[ -r ./.nvmrc  && -s ./.nvmrc ]] || return
    WANTED=$(sed 's/v//' < ./.nvmrc)
    CURRENT=$(hash node 2>/dev/null && node -v | sed 's/v//')
    if [ "$WANTED" != "$CURRENT" ]; then
        [[ "$nvm_has_been_used" -eq "0" ]] && unalias node
        nvm use # Sets PATH
        [[ "$nvm_has_been_used" -eq "0" ]] && source <(npm completion) && nvm_has_been_used=1
    fi
}
# About PROMPT_COMMAND: https://tldp.org/HOWTO/Bash-Prompt-HOWTO/x264.html
export PROMPT_COMMAND="$PROMPT_COMMAND ; nvm_use_if_needed"
