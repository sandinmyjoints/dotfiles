#!/usr/bin/env bash

apt-get install -y tmux emacs mysql-server mysql-client python-minimal make g++ memcached s3cmd pigz awscli jq

cat << "EOF" >> .tmux.conf
set -g default-terminal "screen-256color"

# Start numbering from 1.
set -g base-index 1

# Attempt to set terminal tabs.
set -g set-titles on
set -g set-titles-string "#S"

# Always use emacs bindings. See: http://superuser.com/a/396461
set-option -g status-keys emacs
set-option -gw mode-keys emacs

set -g history-limit 4000

# Prefix is C-].
unbind C-b
set -g prefix ^]
# Send to inner window with C-] C-].
bind-key ^] send-prefix

#########

# Window movement.
bind -n S-Right next-window
bind -n S-Left previous-window
bind -n C-Right next-window
bind -n C-Left previous-window

# fix ssh agent when tmux is detached
setenv -g SSH_AUTH_SOCK $HOME/.ssh/ssh_auth_sock
EOF

cat <<"EOF" >> .ssh/rc
#!/usr/bin/env bash

# Fix SSH auth socket location so agent forwarding works with tmux
if test "$SSH_AUTH_SOCK" ; then
  ln -sf $SSH_AUTH_SOCK ~/.ssh/ssh_auth_sock
fi
EOF

# replace spaces with tabs, the script insists on them!
cat <<EOF >> .tmux-session
0	bash	/home/ubuntu
0	emacs	/home/ubuntu
0	atl	/home/ubuntu/atalanta
0	neodarwin	/home/ubuntu/neodarwin
0	sim	/home/ubuntu/sd-simulator
0	top	/home/ubuntu
0	sd-spelling	/home/ubuntu/sd-spelling
EOF

mkdir bin
mkdir .emacs.d

cat <<"EOF" >> .bashrc
shopt -s extglob
alias attach='tmux attach -t 0'
alias ll='ls -alFh'
EOF
