#
# Dockerfile
#
# This file will be used on non balenaCloud/openBalena environments, like local
# balenaEngine/Docker builds or Docker Hub.
#
# Available base images:
#   https://www.balena.io/docs/reference/base-images/base-images/
#
# Copyright (c) 2018 René-Marc Simard
# SPDX-License-Identifier: Apache-2.0
#

# Declare pre-build variables
ARG DEVICE_NAME=raspberry-pi

# Define base image
FROM balenalib/${DEVICE_NAME}-alpine-python:2

# Declare build variables
ARG AIRTHINGSWAVE_VERSION=0.2
ARG VERSION=0.2.4

# Label image with metadata
LABEL maintainer="René-Marc Simard @renemarc" \
      org.opencontainers.image.authors="René-Marc Simard @renemarc" \
      org.opencontainers.image.description="Airthings Wave radon detector bridge for single-board computers" \
      org.opencontainers.image.documentation="https://github.com/renemarc/balena-airthingswave" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.source="git@github.com:renemarc/balena-airthingswave" \
      org.opencontainers.image.title="balena AirthingsWave" \
      org.opencontainers.image.url="https://airthings.com/wave/" \
      org.opencontainers.image.vendor="René-Marc Simard" \
      org.opencontainers.image.version="${VERSION}" \
      org.label-schema.docker.cmd="docker run --detach --restart=unless-stopped --env-file=docker/env.list --net=host --cap-add=NET_ADMIN --name=airthingswave \$(docker build --quiet .)" \
      org.label-schema.docker.cmd.debug="docker run -it --rm --env-file=docker/env.list --net=host --cap-add=NET_ADMIN --name=airthingswave \$(docker build --quiet .) bash" \
      org.label-schema.docker.params="MQTT_BROKER=string   address of MQTT broker, \
MQTT_PORT=integer    port number of MQTT broker, \
MQTT_USERNAME=string MQTT broker user, \
MQTT_PASSWORD=string MQTT broker user secret, \
WAVES_NAME_1=string  MQTT topic prefix, \
WAVES_ADDR_1=string  Airthings Wave MAC address" \
      org.label-schema.usage="/usr/src/app/README.md" \
      org.label-schema.schema-version="1.0"

# Setup application directory
WORKDIR /usr/src/app

# Install requirements
RUN apk add \
      bluez \
      g++ \
      glib-dev \
      linux-headers \
      make \
      py-setuptools \
 && pip install --no-cache-dir \
      airthingswave-mqtt==${AIRTHINGSWAVE_VERSION} \
      PyYAML \
 && wget www.airthings.com/tech/find_wave.py \
 && find /usr/local \
      \( -type d -a -name test -o -name tests \) \
      -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
      -exec rm -rf '{}' + \
 && apk del \
      g++ \
      glib-dev \
      linux-headers \
      make \
      py-setuptools

# Copy project files in their proper locations
ARG CRON_PERIOD=hourly
COPY ["docker/crontask.sh", "/etc/periodic/${CRON_PERIOD}/airthingswave-mqtt"]
COPY ["docker/docker-entrypoint.sh", "/usr/local/bin/"]
COPY ["docker/config.yaml", "docker/start.sh", "README.md", "./"]

ENTRYPOINT ["docker-entrypoint.sh"]

# Start the main loop
#CMD ["crond", "-f", "-d", "8"]
CMD ["/usr/src/app/start.sh"]
