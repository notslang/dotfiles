# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

export BROWSER=firefox
export EDITOR=nano

export PROMPT_COMMAND='if [ "$(id -u)" -ne 0 ]; then echo "{\"time\":$(date +%s),\"pwd\":$(pwd | jq -M -R '.'),\"command\":$(history 1 | cut -c 8- | jq -M -R '.')}" >> /usrdata/.bash-history.json; fi'

shopt -s globstar

# show man pages in browser
alias man='man --html'

powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
. /usr/lib/python3.5/site-packages/powerline/bindings/bash/powerline.sh
