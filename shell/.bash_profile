export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
[[ -f ~/.bashrc ]] && . ~/.bashrc
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
