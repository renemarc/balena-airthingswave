#!/bin/bash
#
# Startup script
#

# Optimize shell for safety.
set -o errexit -o noclobber -o nounset -o pipefail

# Start cron in the foreground
crond -f -d 8
