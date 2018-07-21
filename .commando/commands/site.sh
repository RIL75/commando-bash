#!/bin/bash
#
# Site commands
#

require maven.sh

command_site_build_description='Build site'

function command_site_build {
  mvn clean install
  mvn --activate-profiles dionysus dionysus:build
}

command_site_publish_description='Publish previously built site'

function command_site_publish {
  mvn --activate-profiles dionysus dionysus:publish
}

command_site_deploy_description='Build and publish site'

function command_site_deploy {
  self site_build && self site_publish
}
