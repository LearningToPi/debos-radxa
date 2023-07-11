# debos-radxa - Fork for Ubuntu 22.04 / 23.04

Fork git: https://github.com/LearningToPi/debos-radxa

Original git: https://github.com/radxa/debos-radxa


## edits in this fork:
 - Added jammy and lunar scipts
 - fixed 'first_boot' script to prevent editing /etc/resolv.conf
 - added loop in 'first_boot' to install packages on first boot (needed for ZRAM)
 - added 'timesyncd.conf' to /etc/systemd/ - populated with North America pool.ntp.org
 - updated recipe files to support changes for jammy / lunar
 - added script to remove ssh keys (so you don't have matching keys on every system you image)

NOTE:  This requires the use of our fork of debos (https://github.com/LearningToPi/debos) which is available on Docker Hub (https://hub.docker.com/r/learningtopi/debos).  The main debos image still runs Debian 10 (bullseye).  This causes errors when building with Ubuntu 22.04 LTS (jammy) or 23.04 (lunar).  My fork of debos updates the image to run Debian 12 (bookworm) which allows the build of jammy and lunar images.

The build-os.sh script has been updated to include "ubuntu", "ubuntu-focal", "ubuntu-jammy" and "ubuntu-lunar" as distro options.  If you use "ubuntu" it will default to "ubuntu-focal".  use "ubuntu-jammy" or "ubuntu-lunar" for 22.04 LTS or 23.04.

<pre>
docker run --rm --interactive --tty -v /dev/shm --tmpfs /dev/shm:rw,nosuid,nodev,exec,size=4g --user $(id -u) --security-opt label=disable --workdir $PWD --mount "type=bind,source=$PWD,destination=$PWD" --device /dev/kvm --entrypoint ./build-os.sh learningtopi/debos -b rock-5b -m ubuntu-lunar -v server 
</pre>

NOTE:  This has been tested on the Rock 5B.  If you experience issues with a different Radxa platform, please feel free to open an issue and provide a log showing the error.  Be sure to include which platform you are building for.

------------------------------------------------

# debos-radxa

## Introduction

This guide describes how to use debos-radxa, based on [debos](https://github.com/go-debos/debos), to generate Debian/Ubuntu image for Radxa boards.

Please note that the [release](https://github.com/radxa/debos-radxa/releases/latest) are auto generated builds without additional testing, if you have issues with the images, please submit an issue.

## Supported boards and system images

* Radxa CM3 IO
* Radxa E23
* Radxa E25
* Radxa NX5
* Radxa Zero
* Radxa Zero 2
* ROCK 3A
* ROCK 3B
* ROCK 3C
* ROCK 5A
* ROCK 5B
* ROCK 4B
* ROCK 4C+

Auto generated build images: https://github.com/radxa/debos-radxa/releases/latest

## Build Host PC

### Required Packages for the Build Host PC

You must install essential host packages on your build host.

The following command installs the host packages on an Ubuntu distribution.

<pre>
$ sudo apt-get install -y git
</pre>

The following command installs the host packages on an Debian distribution.

<pre>
$ sudo apt-get install -y git user-mode-linux libslirp-helper
</pre>

### Install Docker Engine on Ubuntu

See Docker Docs [installing Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/).

## Use Git to Clone debos-radxa

<pre>
radxa@x86-64:~$ cd ~
radxa@x86-64:~$ git clone https://github.com/radxa/debos-radxa.git
</pre>

## Build Your Image

### Get supported board system images

<pre>
radxa@x86-64:~$ cd ~/debos-radxa/
radxa@x86-64:~/debos-radxa$ docker run --rm --interactive --tty --tmpfs /dev/shm:rw,nosuid,nodev,exec,size=4g --user $(id -u) --security-opt label=disable \
--workdir $PWD --mount "type=bind,source=$PWD,destination=$PWD" --entrypoint ./build-os.sh godebos/debos
TOP DIR = /build/stephen/debos-radxa
====USAGE: ./build-os.sh -b <board> -m <model> -v <variant>====
Board list:
    radxa-cm3-io
    radxa-e23
    radxa-e25
    radxa-nx5
    radxa-zero
    radxa-zero2
    rockpi-4b
    rock-4c-plus
    rock-3a
    rock-3b
    rock-3c
    rock-5a
    rock-5b

Model list:
    debian
    ubuntu

Variant list:
    xfce4
    server
</pre>

### Build system image

#### Example: Build ROCK 5B Debian11 Xfce4 image

<pre>
radxa@x86-64:~$ cd ~/debos-radxa/
radxa@x86-64:~/debos-radxa$
radxa@x86-64:~/debos-radxa$ docker run --rm --interactive --tty --tmpfs /dev/shm:rw,nosuid,nodev,exec,size=4g --user $(id -u) --security-opt label=disable \
--workdir $PWD --mount "type=bind,source=$PWD,destination=$PWD" --entrypoint ./build-os.sh godebos/debos -b rock-5b -m debian -v xfce4
</pre>

#### Example: Build ROCK 3A Ubuntu20 server image

<pre>
radxa@x86-64:~$ cd ~/debos-radxa/
radxa@x86-64:~/debos-radxa$
radxa@x86-64:~/debos-radxa$ docker run --rm --interactive --tty --tmpfs /dev/shm:rw,nosuid,nodev,exec,size=4g --user $(id -u) --security-opt label=disable \
--workdir $PWD --mount "type=bind,source=$PWD,destination=$PWD" --entrypoint ./build-os.sh godebos/debos -b rock-3a -m ubuntu -v server
</pre>

The generated system images will be copied to `./output` direcotry.

## How to debug errors

Launch `dev-shell` to get a shell inside debos docker. You can then run `build-os.sh` to monitor the build status. debos mounts root partition at `/scratch/mnt`, and boot partition is mounted at `/scratch/mnt/boot`. You can also `chroot /scratch/mnt` to examine the file system.

Currently `dev-shell` uses a custom docker image to build, so your result might be different from GitHub build. If you want to reproduce GitHub build please use the command from Usage section.

## Add support for new boards

`./configs/boards` are board-specific debos recipes.

`./rootfs/packages` contains additional packages.

## Default settings

* Default non-root user: rock (password: rock)
* Automatically load Bluetooth firmware after startup
* The first boot will resize root filesystem to use all available disk space
* SSH installed by default
* Hostname: board_name
