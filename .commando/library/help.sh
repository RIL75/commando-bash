#@IgnoreInspection BashAddShebang
#
# Help system
#

command_help_description='Display help for command or list all commands'
command_help_syntax='[command]'

function command_help {
  set +o nounset
  local command="$1"
  set -o nounset

  # if given a command attempt to display its help
  if [ -n "$command" ]; then
    help_command ${command}
  else
    # otherwise list all commands
    help_list_commands
  fi
}

# display help for given command
function help_command {
  local command="$(normalize_command_fn $1)"

  # ensure command exists
  resolve_command_fn ${command}

  # lookup command attributes
  set +o nounset
  eval description=\$${command_prefix}${command}_description
  eval syntax=\$${command_prefix}${command}_syntax
  eval help=\$${command_prefix}${command}_help
  set -o nounset

  if [ -n "$description" ]; then
    printf "\n$description\n"
  fi

  printf "\n$(BOLD USAGE)\n\n"
  printf "  $basename $command $syntax\n\n"

  # late render help text if its given
  if [ -n "$help" ]; then
    eval "printf \"$help\""
    printf '\n'
  fi
}

# display help for _current_ command; optionally display a warning message and exit
function help_command_usage {
  set +o nounset
  local message="$1"
  set -o nounset

  if [ -n "$message" ]; then
    warn ${message}
  fi

  help_command ${command}
  exit 2
}

# display list of all commands
function help_list_commands {
  local functions=$(compgen -A function)

  # discover all command functions
  local commands=$(echo ${functions} | tr ' ' '\n' | grep ^${command_prefix} | sort)

  # calculate max size of function, and adjust for display
  local prefix_size=$(expr length ${command_prefix})
  local max_size=$(echo "$commands" | wc --max-line-length)
  local col_size=$(expr ${max_size} + 4)

  printf '\nCommands:\n'
  for fn in ${commands}; do
    local command="${fn:$prefix_size}"

    # lookup command description
    set +o nounset
    eval description=\$${command_prefix}${command}_description
    set -o nounset

    if [ -n "$description" ]; then
      printf "  %-${col_size}s - %s\n" "$(BOLD ${command})" "$description"
    else
      printf "  %s\n" "$(BOLD ${command})"
    fi
  done
  printf '\n'
}
