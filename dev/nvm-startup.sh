# This file is only meant to be sourced, not run.
called=$_
if [[ $called != $0 ]] ; then
    echo "${BASH_SOURCE[@]} is being sourced."
else
    this_file=`basename "$0"`
    echo "$this_file is being run."
fi

#######
# NVM #
#######

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Make it so the first time node is run, it will activate itself.
alias node='nvm_use default; unalias node; node $@'

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
        nvm use ${VERS}
        . <(npm completion)
    else
        echo "Choose a version:"
        nvm ls
    fi

    # TODO: not clear to me whether I should have yarn in PATH or not. For now,
    # putting it in whenever node is going to be used (ie, nvm is started).
    # https://github.com/yarnpkg/yarn/issues/648
    #
    [[ "$nvm_has_been_used" -eq "0" ]] && export PATH="$PATH:$(yarn global bin)" && nvm_has_been_used=1

}

alias nvmuse=nvm_use

nvm_quit () {
    nvm deactivate
}

nvm_deactivate() {
    nvm_quit
}

function nvm_use_if_needed () {
    [[ -r ./.nvmrc  && -s ./.nvmrc ]] || return
    WANTED=$(sed 's/v//' < ./.nvmrc)
    CURRENT=$(hash node 2>/dev/null && node -v | sed 's/v//')
    if [ "$WANTED" != "$CURRENT" ]; then
        [[ "$nvm_has_been_used" -eq "0" ]] && unalias node
        nvm use
        [[ "$nvm_has_been_used" -eq "0" ]] && export PATH="$PATH:$(yarn global bin)" && nvm_has_been_used=1
    fi
}
export PROMPT_COMMAND="$PROMPT_COMMAND ; nvm_use_if_needed"
