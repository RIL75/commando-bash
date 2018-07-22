#@IgnoreInspection BashAddShebang
#
# Release commands
#

require git.sh
require maven.sh
require project.sh

# release
command_release_description='Release project'
command_release_syntax='<version> <next-version> [options]'
command_release_help="\
$(BOLD OPTIONS)
  --dry-run   Do not push or deploy

$(BOLD CONFIGURATION)

  release_prebuild_options  Options for pre-release build
  release_deploy_options    Options for deploy build

$(BOLD HOOKS)

  release_prebuild  Hook called to perform pre-release build
  release_deploy    Hook called to perform deploy
"

function command_release {
  local dryrun='false'

  local -a arguments
  for opt in "$@"; do
    case $opt in
      --dry-run)
        dryrun='true'
        shift
        ;;
      -*)
        die "Unknown option: $opt"
        ;;
      *)
        arguments+=("$1")
        shift
        ;;
    esac
  done

  set +o nounset
  local version="${arguments[0]}"
  local nextVersion="${arguments[1]}"
  set -o nounset

  log "Dry-run: $dryrun"
  log "Version: $version"
  log "Next-version: $nextVersion"

  if [ -z "$version" -o -z "$nextVersion" ]; then
    die 'Missing required arguments'
  fi

  local releaseTag="release-$version"
  log "Release tag: $releaseTag"

  # determine current branch
  local branch=$(git rev-parse --abbrev-ref HEAD)
  log "Current branch: $branch"

  # update version and tag
  self change_version "$version"
  git commit --all --message="update version: $version"
  git tag ${releaseTag}

  # update to next version
  self change_version "$nextVersion"
  git commit --all --message="update version: $nextVersion"

  # checkout release and sanity check
  git checkout ${releaseTag}
  release_prebuild

  if [ ${dryrun} != 'true' ]; then
    # push branch and release-tag
    git push origin ${branch} ${releaseTag}

    # deploy release
    release_deploy
  fi

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