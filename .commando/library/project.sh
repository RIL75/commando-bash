#@IgnoreInspection BashAddShebang
#
# Project commands
#

function __project_module {
  require_module maven.sh

  # rebuild
  command_rebuild_description='Rebuild project'

  rebuild_options='clean install'

  function command_rebuild {
    mvn ${rebuild_options} $*
  }

  # change_version
  command_change_version_description='Change project version'
  command_change_version_syntax='<version>'
  command_change_version_help='\
  $(BOLD CONFIGURATION)

    $(UL change_version_artifacts)    Initial list of project artifact-ids to change; $(BOLD REQUIRED)
    $(UL change_version_properties)   Optional set of properties to change
  '

  change_version_artifacts=
  change_version_properties=

  function command_change_version {
    set +o nounset
    local newVersion="$1"
    set -o nounset

    if [ -z "$newVersion" ]; then
      die 'Missing required arguments'
    fi

    # see https://www.eclipse.org/tycho/sitedocs/tycho-release/tycho-versions-plugin/set-version-mojo.html
    mvn org.eclipse.tycho:tycho-versions-plugin:1.2.0:set-version \
      -Dartifacts=${change_version_artifacts} \
      -Dproperties=${change_version_properties} \
      -DnewVersion=${newVersion}
  }

  # license_header
  command_license_headers_description='Manage project license headers'
  command_license_headers_syntax='<check|format>'
  command_license_headers_help='\
  $(BOLD CONFIGURATION)

    $(UL license_check_options)   Options for license check
    $(UL license_format_options)  Options for license format

  $(BOLD HOOKS)

    $(UL license_check)   Hook called to perform license 'check'
    $(UL license_format)  Hook called to perform license 'format'
  '

  function command_license_headers {
    set +o nounset
    local mode="$1"
    set -o nounset

    case ${mode} in
      check)
        license_check
        ;;

      format)
        license_format
        ;;

      *)
        die 'Missing or invalid mode'
        ;;
    esac
  }

  license_check_options='--activate-profiles license-check --non-recursive'

  function license_check {
    mvn ${license_check_options} $*
  }

  license_format_options='--activate-profiles license-format --non-recursive'

  function license_format {
    mvn ${license_format_options} $*
  }
}

__project_module "$@"
