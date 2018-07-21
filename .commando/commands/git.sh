#!/bin/bash
#
# Git support
#

git_executable='git'
git_options=''

function git {
  log "running: $git_executable $git_options $*"
  "$git_executable" ${git_options} "$@"
}
