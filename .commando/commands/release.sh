#!/bin/bash
#
# Release commands
#

require help.sh
require git.sh
require maven.sh
require project.sh

# release
command_release_description='Release project'
command_release_syntax='<version> <next-version>'
command_release_help="\
$(BOLD CONFIGURATION)

  release_prebuild_options - Options for pre-release build
  release_deploy_options   - Options for deploy build

$(BOLD HOOKS)

  release_prebuild - Hook called to perform pre-release build
  release_deploy   - Hook called to perform deploy
"

function command_release {
  set +o nounset
  local version="$1"
  local nextVersion="$2"
  set -o nounset

  if [ -z "$version" -o -z "$nextVersion" ]; then
    help_command_usage 'Missing required arguments'
  fi

  local releaseTag="release-$version"
  log "Release tag: $releaseTag"

  # determine current branch
  local branch=`git rev-parse --abbrev-ref HEAD`
  log "Current branch: $branch"

  # update version and tag
  self change_version "$version"
  git commit -a -m "update version: $version"
  git tag ${releaseTag}

  # update to next version
  self change_version "$nextVersion"
  git commit -a -m "update version: $nextVersion"

  # checkout release and sanity check
  git checkout ${releaseTag}
  release_prebuild

  # push branch and release-tag
  git push origin ${branch} ${releaseTag}

  # deploy release
  release_deploy

  # restore original branch
  git checkout ${branch}
}

release_prebuild_options='clean install --define test=skip'

function release_prebuild {
  mvn ${release_prebuild_options}
}

release_deploy_options='deploy --define test=skip'

function release_deploy {
  mvn ${release_deploy_options}
}