#
# Dockerfile
#
# This file will be used on non balenaCloud/openBalena environments, like local
# balenaEngine/Docker builds or Docker Hub.
#
# Available base images:
# https://www.balena.io/docs/reference/base-images/base-images/
#

# Declare pre-build variables
ARG DEVICE_NAME=raspberry-pi

# Define base image
FROM balenalib/${DEVICE_NAME}-alpine-python:2

# Declare build variables
ARG AIRTHINGSWAVE_VERSION=0.2
ARG VERSION=0.2.2

# Label image with metadata
LABEL org.label-schema.description="Airthings Wave radon detector bridge for single-board computers." \
      org.label-schema.docker.cmd="docker run --detach --restart=unless-stopped --env-file=env.list --net=host --cap-add=NET_ADMIN --name=airthingswave \$(docker build --quiet .)" \
      org.label-schema.docker.cmd.debug="docker run -it --rm --env-file=env.list --net=host --cap-add=NET_ADMIN --name=airthingswave \$(docker build --quiet .) bash" \
      org.label-schema.name="balena AirthingsWave" \
      org.label-schema.url="https://airthings.com/wave/" \
      org.label-schema.vcs-url="https://github.com/renemarc/balena-airthingswave" \
      org.label-schema.version=${VERSION} \
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
 && wget airthings.com/tech/find_wave.py \
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
COPY ["crontask.sh", "/etc/periodic/${CRON_PERIOD}/airthingswave-mqtt"]
COPY ["docker-entrypoint.sh", "/usr/local/bin/"]
COPY ["config.yaml", "start.sh", "./"]

ENTRYPOINT ["docker-entrypoint.sh"]

# Start the main loop
#CMD ["crond", "-f", "-d", "8"]
CMD ["/usr/src/app/start.sh"]
