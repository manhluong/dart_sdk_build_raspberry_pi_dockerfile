############################################################
# Dockerfile to build dart-sdk
# https://github.com/dart-lang/sdk
#
# Based on Debian
############################################################

FROM debian:stretch
LABEL maintainer="Luong Bui"

RUN apt-get update
RUN apt-get -y install g++-multilib git python curl
RUN git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
ENV PATH="./depot_tools:${PATH}"
RUN echo $PATH
RUN git clone https://github.com/raspberrypi/tools.git

RUN mkdir dart-sdk
RUN cd dart-sdk
RUN fetch dart

RUN ./tools/gn.py -m release -a armv6 \
  -t armv6=/toolchain/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin/arm-linux-gnueabihf- \
  --arm-float-abi hard --no-goma
RUN ./tools/build.py -m release -a armv6 create_sdk

