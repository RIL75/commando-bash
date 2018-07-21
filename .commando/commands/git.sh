#!/bin/bash
#
# Git support
#

# default to 'git' on path
git_executable=$(which git)
git_options=''

function git {
  log "running: $git_executable $git_options $*"
  "$git_executable" ${git_options} "$@"
}
