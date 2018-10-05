#
# Dockerfile for ARM v6
#
# This file will be used on non balenaCloud/openBalena environments, like local
# balenaEngine/Docker builds or Docker Hub.
#
# Available base images:
# https://www.balena.io/docs/reference/base-images/base-images/
#

# Define base image
FROM balenalib/raspberry-pi-alpine:latest

# Declare build environment variables
ENV AIRTHINGSWAVE_VERSION 0.2
ENV VERSION 0.2
ENV CRON_PERIOD hourly

# Label image with metadata
LABEL org.label-schema.name="balena AirthingsWave" \
      org.label-schema.description="Airthings Wave radon detector bridge for single-board computers." \
      org.label-schema.vcs-url="https://github.com/renemarc/balena-airthingswave" \
      org.label-schema.url="https://airthings.com/wave/" \
      org.label-schema.version=${VERSION} \
      org.label-schema.schema-version="1.0"

# Start QEMU virtualization
RUN ["cross-build-start"]

# Setup application directory
WORKDIR /usr/src/app

# Install requirements
RUN apk add \
      bluez \
      g++ \
      glib-dev \
      make \
      py-setuptools \
 && pip install --no-cache-dir \
      airthingswave-mqtt==${AIRTHINGSWAVE_VERSION} \
      PyYAML \
 && wget airthings.com/tech/find_wave.py \
 && find /usr/local \
      \( -type d -a -name test -o -name tests \) \
      -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
      -exec rm -rf '{}' + \
 && apk del \
      g++ \
      glib-dev \
      make \
      py-setuptools

# Copy project files in their proper locations
COPY ["crontask.sh", "/etc/periodic/${CRON_PERIOD}/airthingswave-mqtt"]
COPY ["docker-entrypoint.sh", "/usr/local/bin/"]
COPY ["config.yaml", "start.sh", "./"]

ENTRYPOINT ["docker-entrypoint.sh"]

# Start the main loop
#CMD [ "/usr/sbin/crond",
#      "-f",
#      "-d", "8"
#    ]
CMD ["/usr/src/app/start.sh"]

# Complete QEMU virtualization
RUN ["cross-build-end"]
