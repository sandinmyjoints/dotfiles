# This file is only meant to be sourced, not run.
called=$_
if [[ $called != "$0" ]] ; then
    echo "${BASH_SOURCE[@]} is being sourced."
else
    this_file=$(basename "$0")
    echo "WARNING: $this_file is being run. It is only meant to be sourced."
fi

# ls better
# These are BSD ls options, not sure how well they work with GNU ls.
alias ll='ls -oAGhF'
alias ls='ls -hFG'
alias lt='ls -lAt && echo "------Oldest--"'
alias ltr='ls -lArt && echo "------Newest--"'
alias exa='exa -al'
alias llx='exa'

alias diff='diff -u'

alias fin='egrepn -r -C 3 --exclude *~'
alias pg='pgrep -fil'
alias pgrepf='pgrep -f'

alias pingg='ping 8.8.8.8'
alias ping7='ping 75.75.75.75'
alias ping9='ping 9.9.9.9'

alias ld='otool -L'

alias ec='emacsclient -n'
alias emacs='emacsclient -a -n'

alias markdown='cmark'
alias md='cmark'

alias 'h?'="history | grep"
# share history between terminal sessions
alias he="history -a" # export history
alias hi="history -n" # import history

# Put last command onto clipboard.
cpl () {
    fc -nl -1 | tr -d '\t' | sed -E 's/^[ ]+//g' | tee /dev/tty | pbcopy;
}
# Put output of last command onto clipboard.
alias cl="fc -e - | pbcopy"

# top
alias top='top -s 2 -o cpu -R -F'
alias cpu='top -o cpu'
alias mem='top -o rsize' # memory

# DNS (with update thanks to @blanco)
alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"

# Get your current public IP
alias ip="curl icanhazip.com"

# mute the system volume
alias stfu="osascript -e 'set volume output muted true'"

# trim newlines
alias tn='tr -d "\n"'

alias claer='clear'

# Tmux
#
# this has to come after bashrc, which defines vterm_cmd
function set-tmux-in-vterm () {
    if [ -n "$TMUX" ]; then
        vterm_cmd set-tmux-in-vterm 1
    else
        vterm_cmd set-tmux-in-vterm 1 # Try turning it on unconditionally, see if anything breaks
    fi
}

alias attach='set-tmux-in-vterm ; tmux attach -t'

alias date='date -Iseconds'
alias utcdate='date -u'
alias udate='date -u'

alias dc='docker compose'
# see https://github.com/docker/compose/issues/3317#issuecomment-416552656 about trapping docker compose down
alias dcu='docker compose up --no-log-prefix '

alias n='source ~/dotfiles/dev/nvm-startup.sh'

# See http://unix.stackexchange.com/a/25329
alias watch='watch'

# Git
alias git-prune-and-remove-untracked-branches='git fetch --prune && git branch -r | awk "{print \$1}" | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk "{print \$1}" | xargs git branch -d'

# Homebrew
BREW_PREFIX="$(brew --prefix)"
alias brew_curl="${BREW_PREFIX}/opt/curl/bin/curl "

alias curlv='curl -v -o /dev/null'

# https://stackoverflow.com/questions/5637311/how-to-use-git-diff-color-words-outside-a-git-repository
alias diffmin='git diff --color-words --no-index'

alias cgrep='ggrep --color="auto" -P -n'

alias chromium='/Applications/Chromium.app/Contents/MacOS/Chromium'

alias knot='./knot'

# FIXME: this runs shot whenever bash starts
# alias shootup='up --direct "$(shot i)"'
alias last_screenshot="ls -1rt ~/Screenshots | tail -1"

# Old
# alias uplast='up -d ~/Screenshots/"$(last_screenshot)"'

function upload_last_screenshot () {
    BUCKET=wjb-static
    DIR=screenshots
    LAST="$HOME/Screenshots/$(last_screenshot)"
    FILENAME="screencap-$(LC_ALL=C tr -dc 'a-f0-9' < /dev/urandom | head -c 12).png"
    mc -q cp --attr x-amz-acl=public-read "$LAST" "s3/$BUCKET/$DIR/$FILENAME"
    echo -n "https://s3.amazonaws.com/$BUCKET/$DIR/$FILENAME" | pbcopy
}

alias uplast='upload_last_screenshot'
alias shootup='upload_last_screenshot'
alias lastup='upload_last_screenshot'

# function take_screen_capture_and_upload () {
#     set -e
#     FILENAME=$(LC_ALL=C tr -dc 'a-f0-9' < /dev/urandom | head -c 32).png
#     screencapture -i "/tmp/$FILENAME"
#     mc -q cp --attr x-amz-acl=public-read "/tmp/$FILENAME" "s3/$BUCKET/$DIR/$FILENAME"
#     echo -n "https://s3-us-east-1.amazonaws.com/$BUCKET/$DIR/$FILENAME" | pbcopy
# }

hostname=$(hostname)

if [ "$hostname" == "SM-LAP-PWH79VW5" ]; then
    alias zoom='open -a "Zoom.us" "https://zoom.us/j/4960947967" ; echo -n https://zoom.us/j/4960947967 | pbcopy'
    alias sup='open -a "Zoom.us" "https://zoom.us/j/81322703741"'
elif [ "$hostname" == "bitling" ]; then
    alias zoom='open -a "Zoom.us" "https://zoom.us/j/4960947967" ; echo -n https://zoom.us/j/4960947967 | pbcopy'
    alias sup='open -a "Zoom.us" "https://zoom.us/j/81322703741"'
fi

alias zoomcp='echo -n https://zoom.us/j/4960947967 | pbcopy'

alias gm='git-mine'

# The problem with this is it doesn't have site-lisp and packages dirs on
# load-path, so a lot of things don't find packages they depend on.
function emacs_byte_recompile () {
    gfind . -name "*.elc" -print0 | xargs -0 rm && \
        command emacs --batch -Q --eval '(progn (byte-recompile-directory "/Users/william/.emacs.d/elisp" 0) (byte-recompile-directory "/Users/william/.emacs.d/elpa" 0) (byte-recompile-directory "/Users/wbert/.emacs.d/elisp" 0) (byte-recompile-directory "/Users/wbert/.emacs.d/elpa" 0))'
}
alias elc_recompile=emacs_byte_recompile

function elc_rm () {
    gfind . -name "*.elc" -print0 | xargs -0 rm
}

function pyc_rm () {
    gfind . -name "*.pyc" -print0 | xargs -0 rm
}

alias lsp='ps -ef | grep -E "language-server|languageserver|javascript-typescript-stdio" | grep -v grep'
function pswebpack () {
    ps -rf | grep -v grep | grep -E "PID|webpack|node.+watch|npm" | gsort -n -k2 -k3
}

function killwebpack () {
    pkill -f webpack
}

function pstsserver () {
    # each tsserver has a typingsInstaller.js child. It doesn't use much resources, so skip it.
    ps -ef | grep -v grep | grep -v typingsInstaller | grep -E "PID|tsserver" | gsort -n -k2 -k3
}

# SD stuff.
function check_changelog_bucket () {
    aws s3api list-objects --bucket sd-changelog --output json --query "[sum(Contents[].Size), length(Contents[])]"
}

function nwatch () {
    # avoid yarn watch, b/c when invoked that way, C-c leaves behind a webpack
    # process with ppid 1
    # npm run build:webpack:dev -- -w
    webpack --mode development --progress -w
}

function anybar () {
    ANYBAR_TITLE=lessons ANYBAR_PORT=1741 open -na AnyBar
    ANYBAR_TITLE=classroom ANYBAR_PORT=1740 open -na AnyBar
    ANYBAR_TITLE=vocab ANYBAR_PORT=1739 open -na AnyBar
    ANYBAR_TITLE=main ANYBAR_PORT=1738 open -na AnyBar
}

function anybar_reset () {
    PORT="$1"
    # using nc:
    # echo -n "hollow" | nc -u -w0 localhost "$PORT"

    # using bash special alias
    echo -n "hollow" >/dev/udp/localhost/"$PORT"
}

alias anybar_hollow=anybar_reset

# Intel Brew
alias ib="PATH=/usr/local/bin:/usr/local/sbin:$PATH "

# Docker kill
#
# $ dkill USR2 sdplayground_sd-playground_1
function dkill () {
    SIGNAL="$1"
    CONTAINER="$2"
    docker kill --signal="$SIGNAL" "$CONTAINER"
}

function sso () {
    aws sso login --profile default
}

function yarn-ixl () {
    GIT_SSH_COMMAND='ssh -o IdentitiesOnly=yes -i $HOME/.ssh/id_ed25519_ixl -F /dev/null' yarn
}
