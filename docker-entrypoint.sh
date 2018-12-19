#!/bin/bash
#
# Docker entrypoint script
#

# Optimize shell for safety.
set -o errexit -o noclobber -o nounset -o pipefail

# Replace placeholders found in configuration file with environment variables
sed --expression "$(env | sed 's/[\%]/\\&/g;s/\([^=]*\)=\(.*\)/s%${\1}%\2%/')" \
  < /usr/src/app/config.yaml \
  >| /usr/src/app/airthingswave-mqtt.yaml

# Pass through the CMD directive
exec "$@"
