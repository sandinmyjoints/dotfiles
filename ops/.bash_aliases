alias ll='ls -laGhF'
alias ls='ls -hG'

alias grep='grep --color=auto -Ii'
alias grepn='grep --color=auto -Iin'
alias egrep='grep -E --color=auto -Ii'
alias egrepn='grep -E --color=auto -Iin'
alias fin='egrepn -r -C 3 --exclude *~'
alias pg='pgrep -fil'
alias pgrepf='pgrep -f'

alias ec='emacsclient'

alias diff='diff -u'

alias h?="history | grep"

# top
alias cpu='top -o cpu'
alias mem='top -o rsize' # memory

# copy the working directory path
alias cpwd='pwd|tr -d "\n"|pbcopy'

# Get your current public IP
alias ip="curl icanhazip.com"

# ls better
alias lt='ls -lAt && echo "------Oldest--"'
alias ltr='ls -lArt && echo "------Newest--"'

# trim newlines
alias tn='tr -d "\n"'

# list TODO/FIX lines from the current project
alias todos="ack -n --nogroup '(TODO|FIX(ME)?):'"

alias udate='date -u'

alias scr='screen -dRR'

alias tcpcount="wc -l /proc/net/tcp"
