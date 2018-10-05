#!/bin/bash
#
# AirthingsWave-to-MQTT regular task script
#
# This file will be copied in a relevant folder under /etc/periodic/.
#

# Optimize shell for safety.
set -o errexit -o noclobber -o nounset -o pipefail

timeout -t 60 python -m airthingswave-mqtt /usr/src/app/airthingswave-mqtt.yaml > /proc/1/fd/1 2>&1
