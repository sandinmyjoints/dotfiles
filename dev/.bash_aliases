# This file is only meant to be sourced, not run.
called=$_
if [[ $called != $0 ]] ; then
    echo "${BASH_SOURCE[@]} is being sourced."
else
    this_file=`basename "$0"`
    echo "$this_file is being run."
fi

# ls better
alias ll='ls -laGhF'
alias ls='ls -hG'
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

alias ec='emacsclient'

#alias markdown='python -m markdown'
alias md=multimarkdown
alias mmd=multimarkdown
alias markdown=multimarkdown

alias subl='/Applications/Sublime\ Text\ 2.app/Contents/SharedSupport/bin/subl'

alias h?="history | grep"

#copy output of last command to clipboard
alias cl="fc -e -|pbcopy"

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
alias attach='tmux attach -t '

# Autocorrect
alias elasticsaerch=elasticsearch

# Docker
alias d='docker'
alias dm='docker-machine'
alias dmenv='docker-machine env'
alias evaldm='eval $(docker-machine env)'
alias dc='docker-compose'
alias dcl='docker-cloud'

alias n='source ~/dotfiles/dev/nvm-startup.sh'

# See http://unix.stackexchange.com/a/25329
alias watch='watch '

# Git
alias git-prune-and-remove-untracked-branches='git fetch --prune && git branch -r | awk "{print \$1}" | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk "{print \$1}" | xargs git branch -d'

alias curlv='curl -v -o /dev/null'

# https://stackoverflow.com/questions/5637311/how-to-use-git-diff-color-words-outside-a-git-repository
alias diffmin='git diff --color-words --no-index'
alias cpdiff='git diff | pbcopy'

alias cgrep='ggrep --color='auto' -P -n'

alias yarn-install='yarn install --ignore-engines'
alias top='top -s 2 -o cpu -R -F'
alias exa='exa -al '
alias llx='exa '
alias ecs-deploy='ecs-deploy --timeout 180 '

alias chromium='/Applications/Chromium.app/Contents/MacOS/Chromium '
