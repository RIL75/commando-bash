#@IgnoreInspection BashAddShebang
#
# Maven support
#

# prefer maven-wrapper if it exist; else default to 'mvn' on path
mvn_executable="$basedir/mvnw"
if [ ! -x "$mvn_executable" ]; then
  mvn_executable=$(which mvn)
fi

maven_options=''

function mvn {
  log "running: $mvn_executable $maven_options $*"
  "$mvn_executable" ${maven_options} "$@"
}