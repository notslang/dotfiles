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

# save all commands to /data/HOSTNAME-bash-history.json
export PROMPT_COMMAND='(';
PROMPT_COMMAND+='EXIT_CODE=$?;';
PROMPT_COMMAND+='if [ "$(id -u)" -ne 0 ]; then ';
PROMPT_COMMAND+='HISTORY_COMMAND=$(HISTTIMEFORMAT="%s " history 1);';
PROMPT_COMMAND+='PARSED_COMMAND=$(echo $HISTORY_COMMAND | cut -d " " -f 3- | jq -M -R ".");';
PROMPT_COMMAND+='if [[ $PARSED_COMMAND != "\"\"" ]]; then ';
PROMPT_COMMAND+='COMMAND_NUMBER=$(echo $HISTORY_COMMAND | cut -d " " -f 1);';
PROMPT_COMMAND+='COMMAND_TIME=$(echo $HISTORY_COMMAND | cut -d " " -f 2);';
PROMPT_COMMAND+='WORKING_DIR=$(pwd | jq -M -R ".");';
PROMPT_COMMAND+='echo "{\"time\":$COMMAND_TIME,\"pwd\":$WORKING_DIR,\"command\":$PARSED_COMMAND,\"exit_code\":$EXIT_CODE,\"command_number\":$COMMAND_NUMBER}" >> /data/$(hostname)-bash-history.json;';
PROMPT_COMMAND+='fi ';
PROMPT_COMMAND+='fi)';

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

[[ -f /usr/share/chruby/chruby.sh ]] && source /usr/share/chruby/chruby.sh

export JAVA_HOME='/usr/lib/jvm/java-8-openjdk'
export PATH=$JAVA_HOME/bin:$PATH
export ANDROID_HOME='/opt/android-sdk'
export PATH=$ANDROID_HOME/platform-tools:$PATH

export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"
