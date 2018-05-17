############################################################
# Dockerfile to build dart-sdk
# https://github.com/dart-lang/sdk
############################################################
FROM debian:stretch
LABEL maintainer="Luong Bui"

RUN apt-get update && apt-get -y install vim nano g++-multilib git python curl build-essential debhelper zip

RUN git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
ENV PATH="/depot_tools:${PATH}"
WORKDIR /
RUN git clone https://github.com/manhluong/build_cross_toolchain_raspberry.git

WORKDIR /dart-sdk
ARG dart_version=2.0.0-dev.55.0
RUN git clone https://github.com/dart-lang/sdk.git -b $dart_version

RUN gclient config --name=sdk --unmanaged git@github.com:dart-lang/sdk.git \
 && gclient sync

WORKDIR sdk
ENV TOOLCHAIN="/build_cross_toolchain_raspberry/armv6-rpi-linux-gnueabihf/bin/armv6-rpi-linux-gnueabihf-"
RUN ./tools/gn.py -m release -a armv6 -t armv6=${TOOLCHAIN} --arm-float-abi hard --no-goma

ENV SEDTOOLCHAIN="\/build_cross_toolchain_raspberry\/armv6-rpi-linux-gnueabihf\/bin\/armv6-rpi-linux-gnueabihf-"
ENV EDITEDARGSFILE="./out/ReleaseXARMV6/args.gn"
ENV EDITEDBUILDCOMPILERFILE="./build/config/compiler/BUILD.gn"

# Edit EDITEDARGSFILE to update toolchain_prefix setting or add it if not present.
# Related issue: https://github.com/dart-lang/sdk/issues/33055
RUN grep -q 'toolchain_prefix' ${EDITEDARGSFILE} \
  && sed -i "s/^toolchain_prefix.*/toolchain_prefix = \"${SEDTOOLCHAIN}\"/g" ${EDITEDARGSFILE} \
  || echo "toolchain_prefix = \"${TOOLCHAIN}\"" >> ${EDITEDARGSFILE}

# Edit EDITEDARGSFILE to update is_clang setting to false.
# Edit EDITEDARGSFILE to remove dart_use_wheezy_sysroot setting.
# Related issue: https://github.com/dart-lang/sdk/issues/33055
RUN grep -q 'is_clang' ${EDITEDARGSFILE} \
  && sed -i "s/^is_clang.*/is_clang = false/g" ${EDITEDARGSFILE} \
  && sed -i '/^dart_use_wheezy_sysroot.*/d' ${EDITEDARGSFILE} 

# Edit EDITEDBUILDCOMPILERFILE to use std=gnu++14 instead of std=c++14.
# Forked branch: https://github.com/manhluong/sdk/tree/33055_build_sdk_armv6
RUN grep -q 'std=c++' ${EDITEDBUILDCOMPILERFILE} \
  && sed -i "s/std=c++/std=gnu++/g" ${EDITEDBUILDCOMPILERFILE}

RUN ./tools/build.py -m release -a armv6 create_sdk
WORKDIR out/ReleaseXARMV6/
RUN zip -r /dart-sdk.zip dart-sdk
