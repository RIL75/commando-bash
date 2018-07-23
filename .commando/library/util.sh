#@IgnoreInspection BashAddShebang
#
# Utility helpers
#

function __util_module {
  # resolve an executable
  function resolve_executable {
    local name="$1"
    local executable="$2"
    local resultvar="$3"

    if [ ! -x "$executable" ]; then
      set +o errexit
      executable=$(which ${name})
      set -o errexit

      if [ -x "$executable" ]; then
        log "Resolved executable: $name -> $executable"
        eval $resultvar="$executable"
      else
        die "Unable to resolve executable: $name"
      fi
    fi
  }
}

define_module __util_module "$@"
