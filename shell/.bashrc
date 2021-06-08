# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[[ -f /opt/asdf-vm/asdf.sh ]] && source /opt/asdf-vm/asdf.sh
[[ -f /opt/asdf-vm/completions/asdf.bash ]] && source /opt/asdf-vm/completions/asdf.bash

set -o noclobber
shopt -s globstar

alias screenshot='maim -s > ~/picture/$(date +%s).png'
alias cp='cp -i' # avoid overwriting files
alias grep='grep --color=auto'
alias ls='exa'
alias la='exa -lah --git'
alias mv='mv -i' # avoid overwriting files
alias diff='diff --color=auto'

# fix unknown terminal type issues on remote machines
alias ssh='TERM=xterm-256color ssh'

# enable line numbers and syntax highlighting in less
alias less='less -N'
export LESSOPEN='| /usr/bin/source-highlight-esc.sh %s'
export LESS='-R '

export BROWSER=firefox-developer-edition
export EDITOR=nvim
export VISUAL=nvim
export TERMINAL=alacritty

# save all commands to /data/HOSTNAME-bash-history.json
export PROMPT_COMMAND='('
PROMPT_COMMAND+='EXIT_CODE=$?;'
PROMPT_COMMAND+='if [ "$(id -u)" -ne 0 ]; then '
PROMPT_COMMAND+='HISTORY_COMMAND=$(HISTTIMEFORMAT="%s " history 1);'
PROMPT_COMMAND+='PARSED_COMMAND=$(echo $HISTORY_COMMAND | cut -d " " -f 3- | jq -M -R ".");'
PROMPT_COMMAND+='if [[ $PARSED_COMMAND != "\"\"" ]]; then '
PROMPT_COMMAND+='COMMAND_NUMBER=$(echo $HISTORY_COMMAND | cut -d " " -f 1);'
PROMPT_COMMAND+='COMMAND_TIME=$(echo $HISTORY_COMMAND | cut -d " " -f 2);'
PROMPT_COMMAND+='WORKING_DIR=$(pwd | jq -M -R ".");'
PROMPT_COMMAND+='echo "{\"time\":$COMMAND_TIME,\"pwd\":$WORKING_DIR,\"command\":$PARSED_COMMAND,\"exit_code\":$EXIT_CODE,\"command_number\":$COMMAND_NUMBER}" >> /data/$HOSTNAME-bash-history.json;'
PROMPT_COMMAND+='fi '
PROMPT_COMMAND+='fi);'

# set window title
PROMPT_COMMAND+='printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~};"'

# Only setup powerline if we're running on a virtual terminal, where we can
# expect a powerline compatible font to be loaded. I rarely use hardware ttys,
# so it's not worth configuring compatible fonts for them.
if [[ "$(tty)" == *"/dev/pts"* ]]; then
  PS1='[\u@\h \W]\$ '
  powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  . /usr/share/powerline/bindings/bash/powerline.sh
fi

export JAVA_HOME='/usr/lib/jvm/default'
export PATH=$JAVA_HOME/bin:$PATH
export ANDROID_HOME='/opt/android-sdk'
export PATH=$ANDROID_HOME/platform-tools:$PATH

# Allow running scripts from ~/bin
export PATH="$PATH:$HOME/bin"

# Allow running locally installed node modules
export PATH="$PATH:./node_modules/.bin"

export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"
export W3MIMGDISPLAY_PATH="$HOME/.config/ranger/image-preview-hack.sh"

export FZF_DEFAULT_COMMAND='fd -H -E .git --type f'

# remove open collective ads
export DISABLE_OPENCOLLECTIVE=true
