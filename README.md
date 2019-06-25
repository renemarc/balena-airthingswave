<h1 align="center">
  <a name="top">☢️</a><br/>Airthings Wave radon detector bridge<br/> <sup><sub>a <a href="https://balena.io">balena</a> and Docker container 🐳</sub></sup>
</h1>

[![GitHub Release][img-release]][link-release]
[![Price][img-price]][link-license]
[![AirthingsWave-to-MQTT Version][img-airthingswave-to-mqtt]][link-airthingswave-to-mqtt]
[![balena.io][img-balena]][link-balena]
[![Code Climate maintainability][img-maintainability]][link-maintainability]
[![Maintainer][img-maintainer]][link-maintainer]
[![All Contributors][img-contributors]][link-contributors]
[![PRs Welcome][img-contribute]][link-contribute]
[![License][img-license]][link-license]
[![Tweet][img-twitter]][link-twitter]

Turn a single-board computer ([Raspberry Pi](https://www.raspberrypi.org/)) into a plug-in appliance to bridge your Bluetooth [Airthings Wave radon detector](https://airthings.com/wave/) to an [MQTT broker](https://mqtt.org/).

Useful if your [radon](https://en.wikipedia.org/wiki/Radon#Health_risks) detector is located too far from your home automation hub, or if you need to use your hub's Bluetooth antenna for something else.

This project creates [Docker](#docker-)/[balena](#balena-) images based on Alpine Linux that weigh less than 120 MiB on a Raspberry Pi. 🎈

<div align="center">
    <p><strong>Be sure to <a href="#" title="star">⭐️</a> this repo if you find it useful! 😃</strong></p>
    <figure>
        <div>
            <a href="https://www.youtube.com/watch?v=VJImbQU5w4A" title="Video: Radon alpha decay in a diffusion cloud chamber ☢️"><img src="https://media.giphy.com/media/UQpVozKNDqWeQ/giphy.gif" alt="Radon alpha decay in a diffusion cloud chamber" width="400"></a>
        </div>
        <figcaption>
            <p><a href="https://www.youtube.com/watch?v=VJImbQU5w4A" title="Video: Radon alpha decay in a diffusion cloud chamber"><strong>Alpha decay. Inside your lungs. 😱</strong></a></p>
        </figcaption>
    </figure>
</div>

**[Why use the balena ecosystem?](https://www.balena.io/what-is-balena)**\
All the goodness of [Docker](https://www.docker.com/why-docker), plus security handling, IoT hardware optimized images, read-only rootFS, a build pipeline, a device management interface, and continuous deployment, _for free_ (well, first 10 devices on balenaCloud …or unlimited if you [run your own OpenBalena platform](https://github.com/balena-io/open-balena)).

Of course you _could_ do all of this on your own, but do you _really_ want to micro-manage, keep secure, always perform clean shutdowns, and generally baby something that should really be just plug-in, set-and-forget hardware? 🤔 I surely don't! 😅

<div align="center">
    <figure>
        <div>
            <a href="https://www.youtube.com/watch?v=U81AuTemTkE" title="Video: Radon-220 decays into Polonium-216 then Lead-212"><img src="https://img.youtube.com/vi/U81AuTemTkE/maxresdefault.jpg" alt="Another view of radon alpha decay in a diffusion cloud chamber" width="400"></a>
        </div>
        <figcaption>
            <p><a href="https://www.youtube.com/watch?v=U81AuTemTkE" title="Video: Radon-220 decays into Polonium-216 then Lead-212"><strong>Radon-220 decays into Polonium-216 then Lead-212.</strong></a></p>
        </figcaption>
    </figure>
</div>

<p align="right"><a href="#top" title="Back to top">🔝</a></p>

## Table of contents 📑

1. [Prerequisites](#prerequisites-)
2. [balena](#balena-)
    1. [Preparation](#preparation-)
    2. [Installation](#installation-)
    3. [Configuration](#configuration-)
3. [Docker](#docker-)
4. [Alternatives](#alternatives-)
5. [Contributors](#contributors-)
6. [Thanks](#thanks-)

<p align="right"><a href="#top" title="Back to top">🔝</a></p>

## Prerequisites ✅

1. At least one [Airthings Wave radon detector](https://airthings.com/wave/).
2. Your favourite [Internet of Things](https://en.wikipedia.org/wiki/Internet_of_things) (IoT) device that offers both Bluetooth Low Energy (BLE) and network access, like the inexpensive [Raspberry Pi Zero W](https://www.raspberrypi.org/products/raspberry-pi-zero-w/).
3. Working access to an MQTT broker, either [a public one](https://github.com/mqtt/mqtt.github.io/wiki/public_brokers), your own hosted [Mosquitto](https://mosquitto.org/) instance or [the Home Assistant add-on](https://www.home-assistant.io/addons/mosquitto/).
4. (Recommended) [A free-tier account](https://dashboard.balena-cloud.com/signup) on [balenaCloud](https://balena-cloud.com/) along with [a properly set SSH public key](https://www.balena.io/docs/learn/getting-started/raspberrypi3/nodejs/#adding-an-ssh-key) into your account.
5. (Recommended) [The balena command-line tools](https://www.balena.io/docs/reference/cli/). Do read up on their [friendly development guidelines](https://www.balena.io/docs/learn/develop/local-mode/).

Let's play! 🤠

<p align="right"><a href="#top" title="Back to top">🔝</a></p>

## balena 📦

Follow these simple steps to quickly get your app running on a dedicated device using balenaCloud. If you want more control, [try the Docker solution instead](#docker-).

For reference, the balena framework will build the container using the [`./Dockerfile.template`](./Dockerfile.template) which employs placeholders so that the correct system architecture is picked for you during installation. Easy!

### Preparation 🍔

1. [Create a new application](https://dashboard.balena-cloud.com/login) on balenaCloud dashboard and select the appropriate IoT hardware.
2. Add a new device to your app. Start with _development mode_ for local testing, or go directly for _production mode_ if you know what you're doing.
3. (Optionally) Configure the downloaded image to give your device a custom hostname instead of the generic `balena`:

   ```shell
   sudo balena local configure /path/to/downloaded/image.img
   ```

4. [Burn the image](https://www.balena.io/etcher/) to a disk and boot your IoT device.

Your hardware is ready; it's now time to [install the project! ⬇️](@installation)

<p align="right"><a href="#top" title="Back to top">🔝</a></p>

### Installation 💻

1. Git clone this project's repository:

   ```shell
   git clone git@github.com:renemarc/balena-airthingswave.git
   ```

2. Add your balena application as a secondary remote to the cloned repo:

   ```shell
   git remote add balena <username>@git.balena-cloud.com:<username>/<appname>.git
   ```

3. Push the code to balenaCloud and wait for it to build and provision your device:

   ```shell
   git push balena master
   ```

Great! You are now ready to [configure the project. ⬇️](#configuration-)

<p align="right"><a href="#top" title="Back to top">🔝</a></p>

### Configuration ⚙

Either modify the [`./config.yaml`](./config.yaml) file with your MQTT and Airthings Wave(s) information, or ideally [declare environment variables](https://www.balena.io/docs/learn/manage/serv-vars/) that will then be automatically replaced in the said configuration file.

I **strongly** suggest simply using environment variables, either at the whole fleet level, at the single device level, or at a mix of both. Configuration is easier to update this way and [if you live in a McMansion](https://www.ted.com/talks/kate_wagner_i_hate_mcmansions_and_you_should_too) you can provision multiple devices with the same codebase. Yay!

```shell
MQTT_BROKER   192.168.1.1
MQTT_PORT     1883
MQTT_USERNAME user
MQTT_PASSWORD super-secret-password

WAVES_NAME_1  radon/basement
WAVES_ADDR_1  cc:78:ab:00:00:0a
WAVES_NAME_2  radon/bedroom
WAVES_ADDR_2  cc:78:ab:00:00:0b
WAVES_NAME_3  radon/garage
WAVES_ADDR_3  cc:78:ab:00:00:0c
```

The Waves names are used as MQTT topic prefixes, so name them however you prefer. If you have more than one Wave that you want to query, do modify the [`./config.yaml`](./config.yaml) file to add more entries.

Which MAC address to use? Leave that empty for now and [proceed to the first run below. ⬇️](#first-run-)

### First run 🏃

**There can be only one** controller paired at a time, so do make sure that your Airthings Wave is "forgotten" from your mobile device by opening Airthings' mobile app and unpairing from there.

<div align="center">
    <figure>
        <div>
            <a href="https://www.youtube.com/watch?v=_J3VeogFUOs" title="Video: There can be only one"><img src="http://i.imgur.com/G4yeJJo.jpg" alt="There can be only one" width="300"></a>
        </div>
        <figcaption>
            <p><strong>There should have only been one Highlander movie too…</strong></p>
        </figcaption>
    </figure>
</div>

SSH into your device (only if _development mode_ was selected earlier) or use the balenaCloud app dashboard terminal to [find your Wave's MAC address](https://airthings.com/raspberry-pi/) by issuing this command:

```shell
python /usr/src/app/find_wave.py
```

Press Ctrl+C when scanning seems to be done. Take note of the MAC address for the Wave that you want to use, and either modify [`./config.yaml`](./config.yaml) or ideally create sets of environment variables for each Wave that you want to use.

Once configured, either `git push` your changes or restart the device.

### Cron job ⏲

If your above parameters are correct, you should be receiving new MQTT messages every hour. Keep an eye on the streaming device logs in the balenaCloud dashboard and use an MQTT client to debug incoming messages.

Want to receive quicker updates? Modify the [`./Dockerfile.template`](./Dockerfile.template) and change the **CRON_PERIOD** argument from **hourly** to **15min** [or to something else](https://wiki.alpinelinux.org/wiki/Alpine_Linux:FAQ#My_cron_jobs_don.27t_run.3F).

<div align="center">
    <figure>
        <div>
            <a href="https://www.youtube.com/watch?v=k7QHB6Z-HS8" title="Video: Butters character study"><img src="https://media.giphy.com/media/3o6Zt60Fe3RpBVGBFu/giphy.gif" alt="Butters awarding himself a sunshine sticker" width="400"></a>
        </div>
        <figcaption>
            <p><strong>☀️ Good job! 😃</strong></p>
        </figcaption>
    </figure>
</div>

<p align="right"><a href="#top" title="Back to top">🔝</a></p>

## Docker 🐳

Want more control or wish to run this container on some multi-purpose shared hardware? Here are some useful steps.

Compared to the [balena solution](#balena-), here the regular [`./Dockerfile`](./Dockerfile) is used.

<figure>
    <div align="center">
        <img src="https://media.giphy.com/media/6AFldi5xJQYIo/giphy.gif" alt="Containers being moved in a yard">
    </div>
</figure>

### Build and run 🏗️

1. Fork or clone this project's repository.
2. Edit the [`./env.list`](./env.list) file to setup your environment variables. [See configuration above ⬆️](#configuration-) for details.

3. Build the image:

   For a Raspberry Pi or Zero:

   ```shell
   docker build --tag=airthingswave .
   ```

   For everything else, specify the **DEVICE_NAME** argument with the relevant lowercase machine name [from balena base images](https://www.balena.io/docs/reference/base-images/base-images/). For a Raspberry Pi 3 for instance:

   ```shell
   docker build --build-arg DEVICE_NAME=raspberrypi3 \
     --tag=airthingswave .
   ```

4. Run the project as an auto-starting container:

   ```shell
   docker run --detach --restart=unless-stopped \
     --env-file=env.list \
     --net=host --cap-add=NET_ADMIN \
     --name=airthingswave \
     airthingswave
   ```

   `--net=host` gives the container access to the host's network devices, including Bluetooth.\
   `--cap-add=NET_ADMIN` gives the container network privileges.

5. Perform the steps [outlined in first run above ⬆️](#first-run-) using while inside the container:

   ```shell
   docker exec -it airthingswave bash
   ```

6. Should you wish to [change the cron job frequency](#cron-job-), you can pass the **CRON_PERIOD** (default: **hourly**) argument while first building the image:

   ```shell
   docker build --build-arg CRON_PERIOD=15min \
     --tag=airthingswave .
   ```

Once ready and working, you can alternatively use this example one-liner to build and run the project:

```shell
docker run --detach --restart=unless-stopped \
  --env-file=env.list \
  --net=host --cap-add=NET_ADMIN \
  --name=airthingswave $(docker build --quiet .)
```

<figure>
    <div align="center">
        <img src="https://media.makeameme.org/created/containers-containers-everywhere.jpg" alt="Buzz Lightyear saying Containers everywhere!" width="400">
    </div>
</figure>

<p align="right"><a href="#top" title="Back to top">🔝</a></p>

## Alternatives ⚛

Other options exist, should you wish to try something else:

### Community projects 🌱

- [Airthings MQTT Bridge via an ESP32](https://github.com/sabeechen/AirthingsMQTT) by [**@sabeechen**](https://github.com/sabeechen): ESP32-to-MQTT Arduino sketch for super low-cost, always-on bridges.
- [airthingswave-mqtt](https://github.com/hpeyerl/airthingswave-mqtt) by [**@hpeyerl**](https://github.com/hpeyerl): The AirthingsWave-to-MQTT module used in this project, also available on [the Python Package Index](https://pypi.org/project/airthingswave-mqtt/).
- [homeassistant-airthings](https://github.com/gkreitz/homeassistant-airthings) by [**@gkreitz**](https://github.com/gkreitz): Home Assistant sensor for Airthings Wave Plus.
- [Radonwave](https://github.com/marcelm/radonwave) by [**@marcelm**](https://github.com/marcelm): Python script that outputs a reading for a given Airthings Wave.

### Official solutions 👮

- [Airthings hub](https://airthings.com/hub/): Commercial hardware product, plug-n-play, supported.
- [Android](https://play.google.com/store/apps/details?id=com.airthings.airthings) and [iOS mobile apps](https://itunes.apple.com/app/airthings-wave/id1175388795): Best when using nearby always-on tablets or old cellphones, sending data back to Airthings servers.
- [Airthings dashboard](https://airthings.com/dashboard/): Use your favourite web scraping technique to read back your data sent in by Airthings' hub or mobile apps.
- [Wave Sensor Reader](https://github.com/Airthings/wave-reader) by [**@Airthings**](https://github.com/Airthings): A simple Python script that reads a Wave's data.

<div align="center">
    <figure>
        <div>
            <a href="https://rationalwiki.org/wiki/Radiophobia" title="Definition of radiophobia"><img src="https://media.giphy.com/media/3o6Ztd4SAoP0tRDRWE/giphy.gif" alt="R is for radiophobia: the fear of radiation" width="300"></a>
        </div>
    </figure>
</div>

<p align="right"><a href="#top" title="Back to top">🔝</a></p>

## Contributors ✨

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore -->
<table><tr><td align="center"><a href="https://renemarc.com/"><img src="https://avatars3.githubusercontent.com/u/13276793?v=4" width="100px;" alt="René-Marc Simard"/><br /><sub><b>René-Marc Simard</b></sub></a><br /><a href="https://github.com/renemarc/balena-airthingswave/commits?author=renemarc" title="Code">💻</a> <a href="https://github.com/renemarc/balena-airthingswave/commits?author=renemarc" title="Documentation">📖</a></td></tr></table>

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://allcontributors.org) specification ([emoji key available here](https://allcontributors.org/docs/en/emoji-key)). Found a bug, want to suggest an idea or share some improvements? [Contributions of any kind are welcome!](./CONTRIBUTING.md) 😃

<p align="right"><a href="#top" title="Back to top">🔝</a></p>

## Thanks 💕

This Docker container is based on [airthingswave-mqtt](https://github.com/hpeyerl/airthingswave-mqtt) <sup>[MIT License]</sup> by Herb Peyerl ([**@hpeyerl**](https://github.com/hpeyerl)) and [the discovery code](https://airthings.com/raspberry-pi/) <sup>[MIT License]</sup> by [Airthings](https://airthings.com/).

Copyright © 2018, René-Marc Simard. Project released under [Apache Licence 2.0](./LICENSE) with [additional notices available here](./NOTICE).

<p align="right"><a href="#top" title="Back to top">🔝</a></p>

<p align="center"><strong>Don't forget to <a href="#" title="star">⭐️</a> this repo! 😃<br/><sub>Assembled with <b title="love">❤️</b> in Montréal.</sub></strong></p>

[img-airthingswave-to-mqtt]:https://img.shields.io/badge/uses_airthingswave--mqtt-0.2-blue.svg?logo=python&logoColor=White&maxAge=21600

[img-balena]:https://img.shields.io/badge/built_on-balena-goldenrod.svg?logo=data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz48IURPQ1RZUEUgc3ZnIFBVQkxJQyAiLS8vVzNDLy9EVEQgU1ZHIDEuMS8vRU4iICJodHRwOi8vd3d3LnczLm9yZy9HcmFwaGljcy9TVkcvMS4xL0RURC9zdmcxMS5kdGQiPjxzdmcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgdmVyc2lvbj0iMS4xIiB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCI+PHBhdGggZD0iTTEyLDUuMzJMMTgsOC42OVYxNS4zMUwxMiwxOC42OEw2LDE1LjMxVjguNjlMMTIsNS4zMk0yMSwxNi41QzIxLDE2Ljg4IDIwLjc5LDE3LjIxIDIwLjQ3LDE3LjM4TDEyLjU3LDIxLjgyQzEyLjQxLDIxLjk0IDEyLjIxLDIyIDEyLDIyQzExLjc5LDIyIDExLjU5LDIxLjk0IDExLjQzLDIxLjgyTDMuNTMsMTcuMzhDMy4yMSwxNy4yMSAzLDE2Ljg4IDMsMTYuNVY3LjVDMyw3LjEyIDMuMjEsNi43OSAzLjUzLDYuNjJMMTEuNDMsMi4xOEMxMS41OSwyLjA2IDExLjc5LDIgMTIsMkMxMi4yMSwyIDEyLjQxLDIuMDYgMTIuNTcsMi4xOEwyMC40Nyw2LjYyQzIwLjc5LDYuNzkgMjEsNy4xMiAyMSw3LjVWMTYuNU0xMiw0LjE1TDUsOC4wOVYxNS45MUwxMiwxOS44NUwxOSwxNS45MVY4LjA5TDEyLDQuMTVaIiBmaWxsPSIjZmZmZmZmIiAvPjwvc3ZnPgo=&maxAge=86400

[img-contribute]:https://img.shields.io/badge/pull_requests-welcome-brightgreen.svg?logo=data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz48IURPQ1RZUEUgc3ZnIFBVQkxJQyAiLS8vVzNDLy9EVEQgU1ZHIDEuMS8vRU4iICJodHRwOi8vd3d3LnczLm9yZy9HcmFwaGljcy9TVkcvMS4xL0RURC9zdmcxMS5kdGQiPjxzdmcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgdmVyc2lvbj0iMS4xIiB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCI+PHBhdGggZD0iTTYsM0EzLDMgMCAwLDEgOSw2QzksNy4zMSA4LjE3LDguNDIgNyw4LjgzVjE1LjE3QzguMTcsMTUuNTggOSwxNi42OSA5LDE4QTMsMyAwIDAsMSA2LDIxQTMsMyAwIDAsMSAzLDE4QzMsMTYuNjkgMy44MywxNS41OCA1LDE1LjE3VjguODNDMy44Myw4LjQyIDMsNy4zMSAzLDZBMywzIDAgMCwxIDYsM002LDVBMSwxIDAgMCwwIDUsNkExLDEgMCAwLDAgNiw3QTEsMSAwIDAsMCA3LDZBMSwxIDAgMCwwIDYsNU02LDE3QTEsMSAwIDAsMCA1LDE4QTEsMSAwIDAsMCA2LDE5QTEsMSAwIDAsMCA3LDE4QTEsMSAwIDAsMCA2LDE3TTIxLDE4QTMsMyAwIDAsMSAxOCwyMUEzLDMgMCAwLDEgMTUsMThDMTUsMTYuNjkgMTUuODMsMTUuNTggMTcsMTUuMTdWN0gxNVYxMC4yNUwxMC43NSw2TDE1LDEuNzVWNUgxN0EyLDIgMCAwLDEgMTksN1YxNS4xN0MyMC4xNywxNS41OCAyMSwxNi42OSAyMSwxOE0xOCwxN0ExLDEgMCAwLDAgMTcsMThBMSwxIDAgMCwwIDE4LDE5QTEsMSAwIDAsMCAxOSwxOEExLDEgMCAwLDAgMTgsMTdaIiBmaWxsPSIjZmZmZmZmIiAvPjwvc3ZnPgo=&maxAge=86400

[img-contributors]:https://img.shields.io/badge/all_contributors-1-orange.svg?logo=github&maxAge=21600

[img-docker-hub]:https://img.shields.io/docker/automated/renemarc/balena-airthingswave.svg?logo=docker&maxAge=21600

[img-license]:https://img.shields.io/github/license/renemarc/balena-airthingswave.svg?logo=data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPCFET0NUWVBFIHN2ZyBQVUJMSUMgIi0vL1czQy8vRFREIFNWRyAxLjEvL0VOIiAiaHR0cDovL3d3dy53My5vcmcvR3JhcGhpY3MvU1ZHLzEuMS9EVEQvc3ZnMTEuZHRkIj4KPHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB2ZXJzaW9uPSIxLjEiICB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCI+CiAgIDxwYXRoIGZpbGw9IiNmZmZmZmYiIGQ9Ik0xMiwzQzEwLjczLDMgOS42LDMuOCA5LjE4LDVIM1Y3SDQuOTVMMiwxNEMxLjUzLDE2IDMsMTcgNS41LDE3QzgsMTcgOS41NiwxNiA5LDE0TDYuMDUsN0g5LjE3QzkuNSw3Ljg1IDEwLjE1LDguNSAxMSw4LjgzVjIwSDJWMjJIMjJWMjBIMTNWOC44MkMxMy44NSw4LjUgMTQuNSw3Ljg1IDE0LjgyLDdIMTcuOTVMMTUsMTRDMTQuNTMsMTYgMTYsMTcgMTguNSwxN0MyMSwxNyAyMi41NiwxNiAyMiwxNEwxOS4wNSw3SDIxVjVIMTQuODNDMTQuNCwzLjggMTMuMjcsMyAxMiwzTTEyLDVBMSwxIDAgMCwxIDEzLDZBMSwxIDAgMCwxIDEyLDdBMSwxIDAgMCwxIDExLDZBMSwxIDAgMCwxIDEyLDVNNS41LDEwLjI1TDcsMTRINEw1LjUsMTAuMjVNMTguNSwxMC4yNUwyMCwxNEgxN0wxOC41LDEwLjI1WiIgLz4KPC9zdmc+&maxAge=86400

[img-maintainability]:https://img.shields.io/codeclimate/maintainability/renemarc/balena-airthingswave.svg?logo=code-climate&maxAge=300

[img-maintainer]:https://img.shields.io/badge/maintainer-René--Marc%20Simard-blue.svg?logo=data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPCFET0NUWVBFIHN2ZyBQVUJMSUMgIi0vL1czQy8vRFREIFNWRyAxLjEvL0VOIiAiaHR0cDovL3d3dy53My5vcmcvR3JhcGhpY3MvU1ZHLzEuMS9EVEQvc3ZnMTEuZHRkIj4KPHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB2ZXJzaW9uPSIxLjEiICB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCI+CiAgIDxwYXRoIGZpbGw9IiNmZmZmZmYiIGQ9Ik0xMiwxMEEyLDIgMCAwLDEgMTQsMTJBMiwyIDAgMCwxIDEyLDE0QTIsMiAwIDAsMSAxMCwxMkEyLDIgMCAwLDEgMTIsMTBNMTIsMjJDMTAuMDUsMjIgOC4yMiwyMS40NCA2LjY5LDIwLjQ3TDEwLDE1LjQ3QzEwLjYsMTUuODEgMTEuMjgsMTYgMTIsMTZDMTIuNzIsMTYgMTMuNCwxNS44MSAxNCwxNS40N0wxNy4zMSwyMC40N0MxNS43OCwyMS40NCAxMy45NSwyMiAxMiwyMk0yLDEyQzIsNy44NiA0LjUsNC4zIDguMTEsMi43OEwxMC4zNCw4LjM2QzguOTYsOSA4LDEwLjM4IDgsMTJIMk0xNiwxMkMxNiwxMC4zOCAxNS4wNCw5IDEzLjY2LDguMzZMMTUuODksMi43OEMxOS41LDQuMyAyMiw3Ljg2IDIyLDEySDE2WiIgLz4KPC9zdmc+&maxAge=86400

[img-price]:https://img.shields.io/badge/FREE_as_in-SPEECH-success.svg?logo=data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPCFET0NUWVBFIHN2ZyBQVUJMSUMgIi0vL1czQy8vRFREIFNWRyAxLjEvL0VOIiAiaHR0cDovL3d3dy53My5vcmcvR3JhcGhpY3MvU1ZHLzEuMS9EVEQvc3ZnMTEuZHRkIj4KPHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIiB2ZXJzaW9uPSIxLjEiICB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCI+CiAgIDxwYXRoIGZpbGw9IiNmZmZmZmYiIGQ9Ik0xNS40MSwyMkMxNS4zNSwyMiAxNS4yOCwyMiAxNS4yMiwyMkMxNS4xLDIxLjk1IDE1LDIxLjg1IDE0Ljk2LDIxLjczTDEyLjc0LDE1LjkzQzEyLjY1LDE1LjY5IDEyLjc3LDE1LjQyIDEzLDE1LjMyQzEzLjcxLDE1LjA2IDE0LjI4LDE0LjUgMTQuNTgsMTMuODNDMTUuMjIsMTIuNCAxNC41OCwxMC43MyAxMy4xNSwxMC4wOUMxMS43Miw5LjQ1IDEwLjA1LDEwLjA5IDkuNDEsMTEuNUM5LjExLDEyLjIxIDkuMDksMTMgOS4zNiwxMy42OUM5LjY2LDE0LjQzIDEwLjI1LDE1IDExLDE1LjI4QzExLjI0LDE1LjM3IDExLjM3LDE1LjY0IDExLjI4LDE1Ljg5TDksMjEuNjlDOC45NiwyMS44MSA4Ljg3LDIxLjkxIDguNzUsMjEuOTZDOC42MywyMiA4LjUsMjIgOC4zOSwyMS45NkMzLjI0LDE5Ljk3IDAuNjcsMTQuMTggMi42Niw5LjAzQzQuNjUsMy44OCAxMC40NCwxLjMxIDE1LjU5LDMuM0MxOC4wNiw0LjI2IDIwLjA1LDYuMTUgMjEuMTMsOC41N0MyMi4yMiwxMSAyMi4yOSwxMy43NSAyMS4zMywxNi4yMkMyMC4zMiwxOC44OCAxOC4yMywyMSAxNS41OCwyMkMxNS41LDIyIDE1LjQ3LDIyIDE1LjQxLDIyTTEyLDMuNTlDNy4wMywzLjQ2IDIuOSw3LjM5IDIuNzcsMTIuMzZDMi42OCwxNi4wOCA0Ljg4LDE5LjQ3IDguMzIsMjAuOUwxMC4yMSwxNkM4LjM4LDE1IDcuNjksMTIuNzIgOC42OCwxMC44OUM5LjY3LDkuMDYgMTEuOTYsOC4zOCAxMy43OSw5LjM2QzE1LjYyLDEwLjM1IDE2LjMxLDEyLjY0IDE1LjMyLDE0LjQ3QzE0Ljk3LDE1LjEyIDE0LjQ0LDE1LjY1IDEzLjc5LDE2TDE1LjY4LDIwLjkzQzE3Ljg2LDE5Ljk1IDE5LjU3LDE4LjE2IDIwLjQ0LDE1LjkzQzIyLjI4LDExLjMxIDIwLjA0LDYuMDggMTUuNDIsNC4yM0MxNC4zMywzLjggMTMuMTcsMy41OCAxMiwzLjU5WiIgLz4KPC9zdmc+&maxAge=86400

[img-release]:https://img.shields.io/github/release/renemarc/balena-airthingswave/all.svg?logo=git&logoColor=white&maxAge=21600

[img-travis]:https://img.shields.io/travis/renemarc/balena-airthingswave.svg?logo=travis&label=manifest%20build

[img-twitter]:https://img.shields.io/twitter/url/http/shields.io.svg?style=social&maxAge=86400

[link-airthingswave-to-mqtt]:https://github.com/hpeyerl/airthingswave-mqtt
[link-balena]:https://balena.io
[link-contribute]:./CONTRIBUTING.md
[link-contributors]:#contributors-
[link-docker-hub]:https://hub.docker.com/r/renemarc/balena-airthingswave/
[link-license]:./LICENSE
[link-maintainability]:https://codeclimate.com/github/renemarc/balena-airthingswave
[link-maintainer]:https://github.com/renemarc/
[link-release]:https://github.com/renemarc/balena-airthingswave/releases/latest
[link-travis]:https://travis-ci.org/renemarc/balena-airthingswave
[link-twitter]:https://twitter.com/intent/tweet?text=Airthings%20Wave%20radon%20detector%20bridge%3A%20a%20balena%20and%20Docker%20container&url=https://github.com/renemarc/balena-airthingswave&via=renemarc&hashtags=Radon,Airthings-Wave,MQTT,balena,Docker,RaspberryPi,IoT,SmartHome
