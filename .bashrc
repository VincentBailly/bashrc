#!/bin/bash
#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# start time of the command
preexec () {
  start=`date +%s.%N`
}
preexec_invoke_exec () {
    [ -n "$COMP_LINE" ] && return  # do nothing if completing
    [ "$BASH_COMMAND" = "$PROMPT_COMMAND" ] && return # don't cause a preexec for $PROMPT_COMMAND
    local this_command=`HISTTIMEFORMAT= history 1 | sed -e "s/^[ ]*[0-9]*[ ]*//"`;
    preexec "$this_command"
}
trap 'preexec_invoke_exec' DEBUG

# output time since last command started
showTime () {
  end=`date +%s.%N`
  echo "$end - $start" | bc -l | sed 's/^\./0./' | head -c 5 | sed 's/\.$//' | sed 's/$/ s/' 
}

# output git information (number of staged files / number of unstaged files)
function showGitInfo {
  git status &>/dev/null || return
  status=$(git status --porcelain)
  staged=$(echo "$status" | grep '^[ADMR]' | wc -l)
  other=$(echo "$status" | grep '^.[^ ]' | wc -l)
  echo " (git: $staged/$other)"
}

# PS1 shows
# - time of execution of previous command
# - display previous in green if previous command succeeded, else display previous in red
# - time of the day
# - current directory
# - if current directory is within a git repo, show number of files staged and number of files unstaged
export PS1='\n`[[ $? = 0 ]] && echo -n "\e[1;33m" || echo -n "\e[1;31m"`$(showTime)\e[m - \t - \e[1;32m\w\e[m\e[1;34m$(showGitInfo)\e[m\n -> '

export EDITOR=nvim

# history size:
export HISTSIZE=100000
export HISTFILESIZE=100000

e () {
  nvim "$@"
}

v () {
  nvim "$@"
}

r () {
  ranger "$@"
}

ls () {
  /usr/bin/ls --color=auto "$@"
}

# Increase max number of open files
sudo prlimit --nofile=65000 --pid $$

