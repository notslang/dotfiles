# If not running interactively, don't do anything
[[ $- != *i* ]] && return

set -o noclobber
alias cp='cp -i' # avoid overwriting files
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias man='man --html' # show man pages in browser
alias mv='mv -i' # avoid overwriting files
PS1='[\u@\h \W]\$ '

export BROWSER=firefox
export EDITOR=nano

# save all commands to /usrdata/.bash-history.json
export PROMPT_COMMAND='if [ "$(id -u)" -ne 0 ]; then echo "{\"time\":$(date +%s),\"pwd\":$(pwd | jq -M -R '.'),\"command\":$(history 1 | cut -c 8- | jq -M -R '.')}" >> /usrdata/.bash-history.json; fi'

shopt -s globstar

powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
. /usr/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh
