#!/usr/bin/env bash
# Set up an Ubuntu instance.

sudo apt-get update && sudo apt-get install -y emacs jq pigz awscli tmux mosh s3cmd

alias attach='tmux attach -t '

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

mkdir -p bin
mkdir -p .emacs.d

cat <<"EOF" >> .bashrc
shopt -s extglob
alias attach='tmux attach -t 0'
alias ll='ls -alFh'
EOF

cat <<"EOF" >> ~/bin/tmux-session
#!/usr/bin/env bash
# Save and restore the state of tmux sessions and windows.
# TODO: persist and restore the state & position of panes.
set -e

# See https://github.com/tmux/tmux/issues/284
export TMUX_TMPDIR=/tmp

dump() {
  local d=$'\t'
  tmux list-windows -a -F "#S${d}#W${d}#{pane_current_path}"
}

save() {
  cp ~/.tmux-session ~/.tmux-session.bak
  dump > ~/.tmux-session || mv ~/.tmux-session.bak ~/.tmux-session
}

terminal_size() {
  stty size 2>/dev/null | awk '{ printf "-x%d -y%d", $2, $1 }'
}

session_exists() {
  tmux has-session -t "$1" 2>/dev/null
}

add_window() {
  # Skip adding window if directory doesn't exist
  [ -d "$3" ] &&
  tmux new-window -d -t "$1:" -n "$2" -c "$3"
}

new_session() {
  cd $3 &&
  tmux new-session -d -s "$1" -n "$2" $4
}

restore() {
  tmux start-server
  local count=0
  local dimensions="$(terminal_size)"

  while IFS=$'\t' read session_name window_name dir; do
    if ! [[ $window_name = "log" || $window_name = "man" ]]; then
      if session_exists "$session_name"; then
        add_window "$session_name" "$window_name" "$dir" || true
      else
        new_session "$session_name" "$window_name" "$dir" "$dimensions"
        count=$(( $count + 1 ))
      fi
    fi
  done < ~/.tmux-session

  echo "restored $count sessions"
}

case "$1" in
save | restore )
  $1
  ;;
* )
  echo "valid commands: save, restore" >&2
  exit 1
esac
EOF

chmod 755 ~/bin/tmux-session
