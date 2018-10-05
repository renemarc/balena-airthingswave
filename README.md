<h1 align="center">
  <a name="top">☢️</a><br/>Airthings Wave radon detector bridge<br/> <sup><sub>a <a href="https://balena.io">balena</a> and Docker container 🐳</sub></sup>
</h1>

[![Price][img-price]][link-license]
[![License][img-license]][link-license]
[![GitHub Release][img-release]][link-release]
[![AirthingsWave-to-MQTT Version][img-airthingswave-to-mqtt]][link-airthingswave-to-mqtt]
[![balena.io][img-balena]][link-balena]
[![PRs Welcome][img-prs]][link-prs]
[![Tweet][img-twitter]][link-twitter]

Turn a single-board computer ([Raspberry Pi](https://www.raspberrypi.org/)) into a plug-in appliance to bridge your Bluetooth [Airthings Wave radon detector](https://airthings.com/wave/) to an [MQTT broker](https://mqtt.org/).

Useful if your [radon](https://en.wikipedia.org/wiki/Radon#Health_risks) detector is located too far from your home automation hub, or if you need to use your hub's Bluetooth antenna for something else.

This project creates Docker/balena images based on Alpine Linux that weigh less than 120 MiB on a Raspberry Pi. ⚖️

<div align="center">
    <figure>
        <div>
            <a href="https://www.youtube.com/watch?v=VJImbQU5w4A" title="Very high radon levels "><img src="https://media.giphy.com/media/UQpVozKNDqWeQ/giphy.gif" alt="Radon alpha decay in a diffusion cloud chamber" width="400"></a>
        </div>
        <figcaption>
            <p><strong>Alpha decay. Inside your lungs. 😱</strong></p>
        </figcaption>
    </figure>
</div>

**[Why use the balena ecosystem?](https://www.balena.io/what-is-balena)** All the goodness of [Docker](https://www.docker.com/why-docker), plus security handling, IoT hardware optimized images, read-only rootFS, a build pipeline, a device management interface, and continuous deployment, _for free_ (well, first 10 devices on balenaCloud …or unlimited if you [run your own OpenBalena platform](https://github.com/balena-io/open-balena)).

Of course you _could_ do all of this on your own, but do you _really_ want to micro-manage, keep secure, always perform clean shutdowns, and generally baby something that should really be just plug-in, set-and-forget hardware? 🤔 I surely don't! 😅

<div align="center">
    <figure>
        <div>
            <a href="https://www.youtube.com/watch?v=U81AuTemTkE" title="Radon-220 decays into Polonium-216 then Lead-212"><img src="https://img.youtube.com/vi/U81AuTemTkE/maxresdefault.jpg" alt="Another view of radon alpha decay in a diffusion cloud chamber" width="400"></a>
        </div>
        <figcaption>
            <p><strong>Radon-220 decays into Polonium-216 then Lead-212.</strong></p>
        </figcaption>
    </figure>
</div>

<p align="right"><a href="#top" title="Back to top">🔝</a></p>

## Table of contents 📑

1. [Prerequisites](#prerequisites-)
2. [Preparation](#preparation-)
3. [Installation](#installation-)
4. [Configuration](#configuration-)
5. [Dockerfiles](#dockerfiles-)
6. [Alternatives](#alternatives-)
7. [Contributing](#contributing-)
8. [Thanks](#thanks-)

<p align="right"><a href="#top" title="Back to top">🔝</a></p>

## Prerequisites ✅

1. At least one [Airthings Wave radon detector](https://airthings.com/wave/).
2. Your favourite [Internet of Things](https://en.wikipedia.org/wiki/Internet_of_things) (IoT) device that offers both Bluetooth Low Energy (BLE) and network access, like the inexpensive [Raspberry Pi Zero W](https://www.raspberrypi.org/products/raspberry-pi-zero-w/).
3. Working access to an MQTT broker, either [a public one](https://github.com/mqtt/mqtt.github.io/wiki/public_brokers), your own hosted [Mosquitto](https://mosquitto.org/) instance or [the Home Assistant addon](https://www.home-assistant.io/addons/mosquitto/).
4. [A free-tier account](https://dashboard.balena-cloud.com/signup) on [balenaCloud](https://balena-cloud.com/) along with [a properly set SSH public key](https://www.balena.io/docs/learn/getting-started/raspberrypi3/nodejs/#adding-an-ssh-key) into your account.
5. (Recommended) [The balena command-line tools](https://www.balena.io/docs/reference/cli/). Do read up on their [friendly development guidelines](https://www.balena.io/docs/learn/develop/local-mode/).

Let's play! 🤠

<p align="right"><a href="#top" title="Back to top">🔝</a></p>

## Preparation 🍔

1. [Create a new application](https://dashboard.balena-cloud.com/login) on balenaCloud dashboard and select the appropriate IoT hardware.
2. Add a new device to your app. Start with _development mode_ for local testing, or go directly for _production mode_ if you know what you're doing.
3. (Optionally) Configure the downloaded image to give your device a custom hostname instead of the generic `balena`:

   ```sh
   sudo balena local configure /path/to/downloaded/image.img
   ```

4. [Burn the image](https://www.balena.io/etcher/) to a disk and boot your IoT device.

Your hardware is ready; it's now time to [install the project! ⬇️](@installation)

<p align="right"><a href="#top" title="Back to top">🔝</a></p>

## Installation 💻

1. Git clone this project's repository:

   ```sh
   git clone git@github.com:renemarc/balena-airthingswave.git
   ```

2. Add your balena application as a secondary remote to the cloned repo:

   ```sh
   git remote add balena <username>@git.balena-cloud.com:<username>/<appname>.git
   ```

3. Push the code to balenaCloud and wait for it to build and provision your device:

   ```sh
   git push balena master
   ```

Great! You are now ready to [configure the project. ⬇️](#configuration-)

<p align="right"><a href="#top" title="Back to top">🔝</a></p>

## Configuration ⚙

Either modify the [`config.yaml`](./config.yaml) file with your MQTT and Airthings Wave(s) information, or ideally [declare environment variables](https://www.balena.io/docs/learn/manage/serv-vars/) that will then be automatically replaced in the said configuration file.

I **strongly** suggest simply using environment variables, either at the whole fleet level, at the single device level, or at a mix of both. Configuration is easier to update this way and [if you live in a McMansion](https://www.ted.com/talks/kate_wagner_i_hate_mcmansions_and_you_should_too) you can provision multiple devices with the same codebase. Yay!

```sh
ENV MQTT_BROKER   192.168.1.1
ENV MQTT_PORT     1883
ENV MQTT_USERNAME user
ENV MQTT_PASSWORD super-secret-password

ENV WAVES_NAME_1  radon/basement
ENV WAVES_ADDR_1  cc:78:ab:00:00:0a
ENV WAVES_NAME_2  radon/bedroom
ENV WAVES_ADDR_2  cc:78:ab:00:00:0b
ENV WAVES_NAME_3  radon/garage
ENV WAVES_ADDR_3  cc:78:ab:00:00:0c
```

The Waves names are used as MQTT topic prefixes, so name them however you prefer. If you have more than one Wave that you want to query, do modify the [`config.yaml`](./config.yaml) file to add more entries.

Which MAC address to use? Leave that empty for now and [proceed to the first run below. ⬇️](#first-run)

### First run 🏃

**There can be only one** controller paired at a time, so do make sure that your Airthings Wave is "forgotten" from your mobile device by opening Airthings' mobile app and unpairing from there.

<div align="center">
    <figure>
        <div>
            <a href="https://www.youtube.com/watch?v=_J3VeogFUOs" title="There can be only one"><img src="http://i.imgur.com/G4yeJJo.jpg" alt="There can be only one" width="300"></a>
        </div>
        <figcaption>
            <p><strong>There should have only been one Highlander movie too…</strong></p>
        </figcaption>
    </figure>
</div>

SSH into your device (only if _development mode_ was selected earlier) or use the balenaCloud app dashboard terminal to [find your Wave's MAC address](https://airthings.com/raspberry-pi/) by issuing this command:

```sh
python /usr/src/app/find_wave.py
```

Press Ctrl+C when scanning seems to be done. Take note of the MAC address for the Wave that you want to use, and either modify [`config.yaml`](./config.yaml) or ideally create sets of environment variables for each Wave that you want to use.

Once configured, either `git push` your changes or restart the device.

### Cron job ⏲️

If your above parameters are correct, you should be receiving new MQTT messages every hour. Keep an eye on the streaming device logs in the balenaCloud dashboard and use an MQTT client to debug incoming messages.

Want to receive quicker updates? [Modify the appropriate Dockerfile](#dockerfiles-) and change the `CRON_PERIOD` variable from `hourly` to `15min` or something else that you need.

<div align="center">
    <figure>
        <div>
            <a href="https://www.youtube.com/watch?v=k7QHB6Z-HS8" title="Butters character study"><img src="https://media.giphy.com/media/3o6Zt60Fe3RpBVGBFu/giphy.gif" alt="Butters awarding himself a sunshine sticker" width="400"></a>
        </div>
        <figcaption>
            <p><strong>☀️ Good job! 😃</strong></p>
        </figcaption>
    </figure>
</div>

<p align="right"><a href="#top" title="Back to top">🔝</a></p>

## Dockerfiles 🐳

Which [Dockerfile](https://docs.docker.com/engine/reference/builder/) to use? balenaCloud will pick [`Dockerfile.template`](./Dockerfile.template) for you. Easy!

### [`⚙️ Dockerfile.template`](./Dockerfile.template)

balenaCloud will automatically use this one, which employs placeholders so that the correct system architecture is selected at build time.

### [`⚙️ Dockerfile`](./Dockerfile)

Should you want to build your own Docker image, this regular Dockerfile will build one for a Raspberry Pi or Zero. If you use some other hardware, just change the `FROM balenalib/raspberry-pi-` part with [any other supported base images](https://www.balena.io/docs/reference/base-images/base-images/). This file supports [QEMU virtualization](https://en.wikipedia.org/wiki/QEMU) so that [ARM architecture](https://en.wikipedia.org/wiki/ARM_architecture) images can be built on non-ARM hardware.

<p align="right"><a href="#top" title="Back to top">🔝</a></p>

## Alternatives ⚛️

Other options exist, should you wish to try something else:

- [The official Airthings hub](https://airthings.com/hub/): Commercial solution, plug-n-play, supported.
- [airthingswave-mqtt](https://github.com/hpeyerl/airthingswave-mqtt) by [**@hpeyerl**](https://github.com/hpeyerl): The AirthingsWave-to-MQTT module used in this project, also vailable on [the Python Package Index](https://pypi.org/project/airthingswave-mqtt/).
- [Radonwave](https://github.com/marcelm/radonwave) by [**@marcelm**](https://github.com/marcelm): Python script that outputs a reading of a given Airthings Wave.
- [read_wave.py](https://airthings.com/raspberry-pi/) by [Airthings](https://airthings.com): A simple Python script that demonstrates how to read an Airthings Wave data.

<div align="center">
    <figure>
        <div>
            <a href="https://rationalwiki.org/wiki/Radiophobia" title="Definition of radiophobia"><img src="https://media.giphy.com/media/3o6Ztd4SAoP0tRDRWE/giphy.gif" alt="R is for radiophobia: the fear of radiation" width="300"></a>
        </div>
    </figure>
</div>

<p align="right"><a href="#top" title="Back to top">🔝</a></p>

## Contributing 📝

Want to suggest some Docker improvements? Got some fringe hardware that you used to run this balena/Docker container on and had to tweak some config for it to work? Fork this repo and [open a pull request](./compare) so that all can benefit! 😃

<p align="right"><a href="#top" title="Back to top">🔝</a></p>

## Thanks 💕

This Docker container is based on [airthingswave-mqtt](https://github.com/hpeyerl/airthingswave-mqtt) by Herb Peyerl ([**@hpeyerl**](https://github.com/hpeyerl)) and [the discovery code](https://airthings.com/raspberry-pi/) by [Airthings](https://airthings.com/).

<p align="right"><a href="#top" title="Back to top">🔝</a></p>

<p align="center"><strong>Don't forget to <a href="#" title="star">⭐️</a> this repo! 😃<br/><sub>Assembled with <b title="love">❤️</b> in Montréal.</sub></strong></p>

[img-airthingswave-to-mqtt]:https://img.shields.io/badge/uses_airthingswave--mqtt-0.2-blue.svg?logo=python&logoColor=White&maxAge=21600
[img-balena]:https://img.shields.io/badge/built_on-balena-goldenrod.svg?logo=data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz48IURPQ1RZUEUgc3ZnIFBVQkxJQyAiLS8vVzNDLy9EVEQgU1ZHIDEuMS8vRU4iICJodHRwOi8vd3d3LnczLm9yZy9HcmFwaGljcy9TVkcvMS4xL0RURC9zdmcxMS5kdGQiPjxzdmcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgdmVyc2lvbj0iMS4xIiB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCI+PHBhdGggZD0iTTEyLDUuMzJMMTgsOC42OVYxNS4zMUwxMiwxOC42OEw2LDE1LjMxVjguNjlMMTIsNS4zMk0yMSwxNi41QzIxLDE2Ljg4IDIwLjc5LDE3LjIxIDIwLjQ3LDE3LjM4TDEyLjU3LDIxLjgyQzEyLjQxLDIxLjk0IDEyLjIxLDIyIDEyLDIyQzExLjc5LDIyIDExLjU5LDIxLjk0IDExLjQzLDIxLjgyTDMuNTMsMTcuMzhDMy4yMSwxNy4yMSAzLDE2Ljg4IDMsMTYuNVY3LjVDMyw3LjEyIDMuMjEsNi43OSAzLjUzLDYuNjJMMTEuNDMsMi4xOEMxMS41OSwyLjA2IDExLjc5LDIgMTIsMkMxMi4yMSwyIDEyLjQxLDIuMDYgMTIuNTcsMi4xOEwyMC40Nyw2LjYyQzIwLjc5LDYuNzkgMjEsNy4xMiAyMSw3LjVWMTYuNU0xMiw0LjE1TDUsOC4wOVYxNS45MUwxMiwxOS44NUwxOSwxNS45MVY4LjA5TDEyLDQuMTVaIiBmaWxsPSIjZmZmZmZmIiAvPjwvc3ZnPgo=&maxAge=86400
[img-docker-hub]:https://img.shields.io/docker/automated/renemarc/balena-airthingswave.svg?logo=docker&maxAge=21600
[img-license]:https://img.shields.io/github/license/renemarc/balena-airthingswave.svg?logo=data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz48IURPQ1RZUEUgc3ZnIFBVQkxJQyAiLS8vVzNDLy9EVEQgU1ZHIDEuMS8vRU4iICJodHRwOi8vd3d3LnczLm9yZy9HcmFwaGljcy9TVkcvMS4xL0RURC9zdmcxMS5kdGQiPjxzdmcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgdmVyc2lvbj0iMS4xIiB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCI+PHBhdGggZD0iTTE3LjgsMjBDMTcuNCwyMS4yIDE2LjMsMjIgMTUsMjJINUMzLjMsMjIgMiwyMC43IDIsMTlWMThINUwxNC4yLDE4QzE0LjYsMTkuMiAxNS43LDIwIDE3LDIwSDE3LjhNMTksMkMyMC43LDIgMjIsMy4zIDIyLDVWNkgyMFY1QzIwLDQuNCAxOS42LDQgMTksNEMxOC40LDQgMTgsNC40IDE4LDVWMThIMTdDMTYuNCwxOCAxNiwxNy42IDE2LDE3VjE2SDVWNUM1LDMuMyA2LjMsMiA4LDJIMTlNOCw2VjhIMTVWNkg4TTgsMTBWMTJIMTRWMTBIOFoiIGZpbGw9IiNmZmZmZmYiIC8+PC9zdmc+Cg==&maxAge=86400
[img-price]:https://img.shields.io/badge/price-FREE-53c1f1.svg?logo=data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz48IURPQ1RZUEUgc3ZnIFBVQkxJQyAiLS8vVzNDLy9EVEQgU1ZHIDEuMS8vRU4iICJodHRwOi8vd3d3LnczLm9yZy9HcmFwaGljcy9TVkcvMS4xL0RURC9zdmcxMS5kdGQiPjxzdmcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgdmVyc2lvbj0iMS4xIiB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCI+PHBhdGggZD0iTTcsMTVIOUM5LDE2LjA4IDEwLjM3LDE3IDEyLDE3QzEzLjYzLDE3IDE1LDE2LjA4IDE1LDE1QzE1LDEzLjkgMTMuOTYsMTMuNSAxMS43NiwxMi45N0M5LjY0LDEyLjQ0IDcsMTEuNzggNyw5QzcsNy4yMSA4LjQ3LDUuNjkgMTAuNSw1LjE4VjNIMTMuNVY1LjE4QzE1LjUzLDUuNjkgMTcsNy4yMSAxNyw5SDE1QzE1LDcuOTIgMTMuNjMsNyAxMiw3QzEwLjM3LDcgOSw3LjkyIDksOUM5LDEwLjEgMTAuMDQsMTAuNSAxMi4yNCwxMS4wM0MxNC4zNiwxMS41NiAxNywxMi4yMiAxNywxNUMxNywxNi43OSAxNS41MywxOC4zMSAxMy41LDE4LjgyVjIxSDEwLjVWMTguODJDOC40NywxOC4zMSA3LDE2Ljc5IDcsMTVaIiBmaWxsPSIjZmZmIiAvPjwvc3ZnPgo=&maxAge=86400
[img-prs]:https://img.shields.io/badge/pull_requests-welcome-brightgreen.svg?logo=data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz48IURPQ1RZUEUgc3ZnIFBVQkxJQyAiLS8vVzNDLy9EVEQgU1ZHIDEuMS8vRU4iICJodHRwOi8vd3d3LnczLm9yZy9HcmFwaGljcy9TVkcvMS4xL0RURC9zdmcxMS5kdGQiPjxzdmcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgdmVyc2lvbj0iMS4xIiB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCI+PHBhdGggZD0iTTYsM0EzLDMgMCAwLDEgOSw2QzksNy4zMSA4LjE3LDguNDIgNyw4LjgzVjE1LjE3QzguMTcsMTUuNTggOSwxNi42OSA5LDE4QTMsMyAwIDAsMSA2LDIxQTMsMyAwIDAsMSAzLDE4QzMsMTYuNjkgMy44MywxNS41OCA1LDE1LjE3VjguODNDMy44Myw4LjQyIDMsNy4zMSAzLDZBMywzIDAgMCwxIDYsM002LDVBMSwxIDAgMCwwIDUsNkExLDEgMCAwLDAgNiw3QTEsMSAwIDAsMCA3LDZBMSwxIDAgMCwwIDYsNU02LDE3QTEsMSAwIDAsMCA1LDE4QTEsMSAwIDAsMCA2LDE5QTEsMSAwIDAsMCA3LDE4QTEsMSAwIDAsMCA2LDE3TTIxLDE4QTMsMyAwIDAsMSAxOCwyMUEzLDMgMCAwLDEgMTUsMThDMTUsMTYuNjkgMTUuODMsMTUuNTggMTcsMTUuMTdWN0gxNVYxMC4yNUwxMC43NSw2TDE1LDEuNzVWNUgxN0EyLDIgMCAwLDEgMTksN1YxNS4xN0MyMC4xNywxNS41OCAyMSwxNi42OSAyMSwxOE0xOCwxN0ExLDEgMCAwLDAgMTcsMThBMSwxIDAgMCwwIDE4LDE5QTEsMSAwIDAsMCAxOSwxOEExLDEgMCAwLDAgMTgsMTdaIiBmaWxsPSIjZmZmZmZmIiAvPjwvc3ZnPgo=&maxAge=86400
[img-release]:https://img.shields.io/github/release/renemarc/balena-airthingswave/all.svg?logo=github&logoColor=white&maxAge=21600
[img-travis]:https://img.shields.io/travis/renemarc/balena-airthingswave.svg?logo=travis&label=manifest%20build
[img-twitter]:https://img.shields.io/twitter/url/http/shields.io.svg?style=social&maxAge=86400

[link-airthingswave-to-mqtt]:https://github.com/hpeyerl/airthingswave-mqtt
[link-balena]:https://balena.io
[link-docker-hub]:https://hub.docker.com/r/renemarc/balena-airthingswave/
[link-license]:./LICENSE
[link-prs]:http://makeapullrequest.com
[link-release]:https://github.com/renemarc/balena-airthingswave/releases
[link-travis]:https://travis-ci.org/renemarc/balena-airthingswave
[link-twitter]:https://twitter.com/intent/tweet?text=Airthings%20Wave%20radon%20detector%20bridge%3A%20a%20balena%20and%20Docker%20container&url=https://github.com/renemarc/balena-airthingswave&via=renemarc&hashtags=Radon,Airthings-Wave,MQTT,balena,Docker,RaspberryPi,IoT,SmartHome
