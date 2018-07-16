# If not running interactively, don't do anything
[[ $- != *i* ]] && return

set -o noclobber
shopt -s globstar

alias screenshot='maim -s > ~/picture/$(date +%s).png'
alias cp='cp -i' # avoid overwriting files
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias mv='mv -i' # avoid overwriting files
alias diff='diff --color=auto'

# enable line numbers and syntax highlighting in less
alias less='less -N'
export LESSOPEN="| /usr/bin/source-highlight-esc.sh %s"
export LESS='-R '

export BROWSER=firefox-developer-edition
export EDITOR=nano

# save all commands to /data/.bash-history.json
export PROMPT_COMMAND='if [ "$(id -u)" -ne 0 ]; then echo "{\"time\":$(date +%s),\"pwd\":$(pwd | jq -M -R '.'),\"command\":$(history 1 | cut -c 8- | jq -M -R '.')}" >> /data/.bash-history.json; fi'

# Only setup powerline if we're running on a virtual terminal, where we can
# expect a powerline compatible font to be loaded. I rarely use hardware ttys,
# so it's not worth configuring compatible fonts for them.
if [[ "$(tty)" == *"/dev/pts"* ]]; then
  PS1='[\u@\h \W]\$ '
  powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  . /usr/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh
fi
