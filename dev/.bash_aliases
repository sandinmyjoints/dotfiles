# This file is only meant to be sourced, not run.
called=$_
if [[ $called != "$0" ]] ; then
    echo "${BASH_SOURCE[@]} is being sourced."
else
    this_file=$(basename "$0")
    echo "$this_file is being run."
fi

# ls better
# These are BSD ls options, not sure how well they work with GNU ls.
alias ll='ls -oAGhF'
alias ls='ls -hFG'
alias lt='ls -lAt && echo "------Oldest--"'
alias ltr='ls -lArt && echo "------Newest--"'

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

#alias markdown='python -m markdown'
alias markdown='/usr/local/bin/cmark'
alias md='/usr/local/bin/cmark'

alias subl='/Applications/Sublime\ Text\ 2.app/Contents/SharedSupport/bin/subl'

alias 'h?'="history | grep"
# Put last command onto clipboard.
cpl () {
    fc -nl -1 | tr -d '\t' | sed -E 's/^[ ]+//g' | tee /dev/tty | pbcopy;
}
# Put output of last command onto clipboard.
alias cl="fc -e - | pbcopy"

# top
alias cpu='top -o cpu'
alias mem='top -o rsize' # memory

# copy the working directory path
alias cpwd='pwd|tr -d "\n"|pbcopy'

# DNS (with update thanks to @blanco)
alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"

# share history between terminal sessions
alias he="history -a" # export history
alias hi="history -n" # import history

# Get your current public IP
alias ip="curl icanhazip.com"

# mute the system volume
alias stfu="osascript -e 'set volume output muted true'"

# trim newlines
alias tn='tr -d "\n"'

# list TODO/FIX lines from the current project
alias todos="ack -n --nogroup '(TODO|FIX(ME)?):'"

alias utcdate='date -u'

# Tmux
alias attach='tmux attach -t'

# Autocorrect
alias elasticsaerch=elasticsearch

# Docker
alias evaldm='eval $(docker-machine env)'

alias dc='docker-compose'
# see https://github.com/docker/compose/issues/3317#issuecomment-416552656 about trapping docker compose down

alias upup='git pull && docker-compose up'

alias n='source ~/dotfiles/dev/nvm-startup.sh'

# See http://unix.stackexchange.com/a/25329
alias watch='watch'

# Git
alias git-prune-and-remove-untracked-branches='git fetch --prune && git branch -r | awk "{print \$1}" | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk "{print \$1}" | xargs git branch -d'

BREW_PREFIX="$(brew --prefix)"
alias brew_curl="${BREW_PREFIX}/opt/curl/bin/curl "
# prefer homebrew's curl
alias curl="${BREW_PREFIX}/opt/curl/bin/curl "

alias curlv='curl -v -o /dev/null'

# https://stackoverflow.com/questions/5637311/how-to-use-git-diff-color-words-outside-a-git-repository
alias diffmin='git diff --color-words --no-index'
alias cpdiff='git diff | pbcopy'

alias cgrep='ggrep --color="auto" -P -n'

alias yarn-install='yarn install --ignore-engines'

alias top='top -s 2 -o cpu -R -F'
alias exa='exa -al'
alias llx='exa'
alias xx='exa'
# alias ecs-deploy='ecs-deploy --timeout 180'

alias chromium='/Applications/Chromium.app/Contents/MacOS/Chromium'

alias knot='./knot'

alias claer='clear'

alias thumbnail='thumb'

alias up='NODE_NO_WARNINGS=1 up'
# FIXME: this runs shot whenever bash starts
# alias shootup='up --direct "$(shot i)"'
alias last_screenshot="ls -1rt ~/Screenshots | tail -1"

alias uplast='up -d ~/Screenshots/"$(last_screenshot)"'
alias shootup='uplast'
alias lastup='uplast'

# Global prettier, because the node-specific bin dir is earlier on PATH than
# globals. This only works if a node is on the PATH, ie, if nvm has been started
# and a node selected.
#
alias gprettier='/Users/william/.yarn/bin/prettier'

alias changes='/Users/william/scm/sd/neodarwin/bin/changes'

alias lsp='ps -ef | grep -E "language-server|languageserver|javascript-typescript-stdio" | grep -v grep'
alias tsserver='ps -ef | grep -E "tsserver" | grep -v grep'
alias ts='tsserver'

alias zoom='open -a "FirefoxDeveloperEdition - Work" "https://zoom.us/j/4960947967" ; echo -n https://zoom.us/j/4960947967 | pbcopy'
alias sup='open -a "FirefoxDeveloperEdition - Work" "https://zoom.us/j/476688636"'
alias standup='sup'

alias gitmine='git-mine'
alias gm='git-mine'

# sdc aliases

alias sd='sdc'
function sdcl() {
  local SERVICE="$1"
  sdc logs -f --tail=100 $SERVICE | gsed -u 's/^[^|]*[^ ]* //'
}

function sdup() {
  local SERVICE="$1"
  sdc up "$SERVICE"
}

function restart() {
  local SERVICE="$1"
  sdc stop "$SERVICE" && sdc up --no-deps -d "$SERVICE" && sdcl "$SERVICE"
}

function rebuild () {
  local SERVICE="$1"
  sdc stop "$SERVICE" && sdc up --build --no-deps -d "$SERVICE" && sdcl "$SERVICE"
}

function check_changelog_bucket () {
    aws s3api list-objects --bucket sd-changelog --output json --query "[sum(Contents[].Size), length(Contents[])]"
}

function emacs_byte_recompile () {
    gfind . -name "*.elc" -print0 | xargs -0 rm && command emacs --batch -Q --eval '(progn (byte-recompile-directory "/Users/william/.emacs.d/elisp" 0) (byte-recompile-directory "/Users/william/.emacs.d/elpa" 0))'
}

function pswebpack () {
    ps -ef|grep -v grep|grep webpack
}

function killwebpack () {
    pkill -f webpack
}
