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

# Configure history
## size
export HISTSIZE=1000000
export HISTFILESIZE=100000
## append to histfile instead of overriding it
shopt -s histappend
## Erase dups
export HISTCONTROL=erasedups
## Save and reload the history after each command finishes
export PROMPT_COMMAND='history -a; history -c; history -r'


export EDITOR=nvim

e () {
  nvim "$@"
}

v () {
  nvim "$@"
}

r () {
  ranger "$@"
}

g () {
  git "$@"
}

gd () {
  git diff "$@"
}

gds () {
  git diff --staged "$@"
}

gs () {
  git status "$@"
}

ga () {
  git add "$@"
}

gc () {
  git commit "$@"
}

gp () {
  git push "$@"
}

vb () {
  vcsh bash "$@"
}

vbs () {
  vcsh bash status "$@"
}

vbd () {
  vcsh bash diff "$@"
}

vbds () {
  vcsh bash diff --staged "$@"
}

vba () {
  vcsh bash add "$@"
}

vbc () {
  vcsh bash commit "$@"
}

vbp () {
  vcsh bash push "$@"
}

vv () {
  vcsh vim "$@"
}

vvs () {
  vcsh vim status "$@"
}

vvd () {
  vcsh vim diff "$@"
}

vvds () {
  vcsh vim diff --staged "$@"
}

vva () {
  vcsh vim add "$@"
}

vvc () {
  vcsh vim commit "$@"
}

vvp () {
  vcsh vim push "$@"
}

ls () {
  /usr/bin/ls --color=auto -la "$@"
}

l () {
  /usr/bin/ls --color=auto "$@"
}

c () {
  cd "$@"
}

x () {
  exa --long --git --tree --all -I .git "$@"
}

# Increase max number of open files
sudo prlimit --nofile=65000 --pid $$

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# add nrv path to PATH
export PATH=$PATH:$HOME/.local/bin

# disable XON/XOFF to make C-S work for incremental search
# https://stackoverflow.com/questions/791765/unable-to-forward-search-bash-history-similarly-as-with-ctrl-r
# This condition tests whether the current shell is interactive
[[ $- == *i* ]] && stty -ixon

[ -z "$NVM_DIR" ] && export NVM_DIR="$HOME/.nvm"
source /usr/share/nvm/nvm.sh
source /usr/share/nvm/bash_completion
source /usr/share/nvm/install-nvm-exec
