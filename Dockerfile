############################################################
# Dockerfile to build dart-sdk
# https://github.com/dart-lang/sdk
#
# Based on Debian
############################################################
FROM debian:stretch
LABEL maintainer="Luong Bui"

RUN apt-get update && apt-get -y install vim nano g++-multilib git python curl build-essential debhelper zip

RUN git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
ENV PATH="/depot_tools:${PATH}"
WORKDIR /
RUN git clone https://github.com/manhluong/build_cross_toolchain_raspberry.git

WORKDIR /dart-sdk
#ARG dart_version=1.24.3
RUN git clone https://github.com/manhluong/sdk.git
WORKDIR sdk
RUN git checkout 33055_save_toolchain_arg
WORKDIR /dart-sdk

RUN gclient config --name=sdk --unmanaged git@github.com:dart-lang/sdk.git 
RUN gclient sync

WORKDIR sdk
RUN ./tools/gn.py -m release -a armv6 -t armv6=/build_cross_toolchain_raspberry/armv6-rpi-linux-gnueabihf/bin/armv6-rpi-linux-gnueabihf- --arm-float-abi hard --no-goma #-stdgnu
#RUN ./tools/build.py -m release -a armv6 create_sdk
#WORKDIR out/ReleaseXARMV6/
#RUN ./tools/build.py -m release --arch x64 create_sdk
#WORKDIR out/ReleaseX64/
#RUN zip -r /dart-sdk.zip dart-sdk
