#@IgnoreInspection BashAddShebang
#
# Git support
#

function __git_module {
  # default to 'git' on path
  git_executable=$(which git)
  git_options=''

  function git {
    log "Running: $git_executable $git_options $*"
    "$git_executable" ${git_options} "$@"
  }
}

__git_module "$@"
