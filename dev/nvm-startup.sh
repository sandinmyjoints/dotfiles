#######
# NVM #
#######

source ~/.nvm/nvm.sh
[[ -r $NVM_DIR/bash_completion ]] && . $NVM_DIR/bash_completion

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
        nvm use ${VERS}
        . <(npm completion)
    else
        echo "Choose a version:"
        nvm ls
    fi
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
        nvm use
    fi
}
export PROMPT_COMMAND="$PROMPT_COMMAND ; nvm_use_if_needed"

nvm_use default