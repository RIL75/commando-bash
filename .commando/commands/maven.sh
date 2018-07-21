#!/bin/bash
#
# Maven support
#

mvn_executable="$basedir/mvnw"
maven_options=''

function mvn {
  log "running: $mvn_executable $maven_options $*"
  "$mvn_executable" ${maven_options} "$@"
}