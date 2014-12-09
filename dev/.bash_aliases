alias ll='ls -laGhF'
alias ls='ls -hG'
alias p='ipython'

alias subl='/Applications/Sublime\ Text\ 2.app/Contents/SharedSupport/bin/subl'

alias grepc='grep --color=auto -Ii'
alias grepn='grep --color=auto -Iin'
alias egrep='grep -E --color=auto -Ii'
alias egrepn='grep -E --color=auto -Iin'
alias grepnc='grep -E --color=never -Ii'
alias fin='egrepn -r -C 3 --exclude *~'
alias pg='pgrep -fil'
alias pgrepf='pgrep -f'

alias ld='otool -L'

alias ec='emacsclient'

alias markdown='python -m markdown'

alias icoffee='~/scm/wjb/coffee-script/bin/coffee'

alias diff='diff -u'

alias h?="history | grep"

#copy output of last command to clipboard
alias cl="fc -e -|pbcopy"

# top
alias cpu='top -o cpu'
alias mem='top -o rsize' # memory

# copy the working directory path
alias cpwd='pwd|tr -d "\n"|pbcopy'

# DNS (with update thanks to @blanco)
alias flush="sudo killall -HUP mDNSResponder"

# share history between terminal sessions
alias he="history -a" # export history
alias hi="history -n" # import history

# Get your current public IP
alias ip="curl icanhazip.com"

# ls better
alias lt='ls -lAt && echo "------Oldest--"'
alias ltr='ls -lArt && echo "------Newest--"'

# mute the system volume
alias stfu="osascript -e 'set volume output muted true'"

# trim newlines
alias tn='tr -d "\n"'

# list TODO/FIX lines from the current project
alias todos="ack -n --nogroup '(TODO|FIX(ME)?):'"

alias utcdate='date -u'

alias test_all_fluencia='fab test:conf=config.settings.dev_fluencia && fab test:conf=config.settings.staging_fluencia && fab test:conf=config.settings.prod_fluencia'
alias test_all_marketing='fab test:conf=config.settings.dev_marketing && fab test:conf=config.settings.staging_marketing && fab test:conf=config.settings.prod_marketing'
