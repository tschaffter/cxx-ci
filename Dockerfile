FROM ubuntu:focal-20200423

LABEL maintainer="thomas.schaffter@gmail.com"

USER root
WORKDIR /root

RUN apt-get update -qq -y && apt-get install -qq -y \
    software-properties-common

# Install Python (cmake-format)
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update -qq -y && apt-get install -qq -y \
    python3.8 \
    python3-pip

RUN ln -s -f $(command -v python3.8) /usr/bin/python \
    && ln -s -f $(command -v pip3) /usr/bin/pip

RUN pip install cmake-format

# Install required tools
RUN apt-get install -qq -y \
    gcc \
    g++ \
    ninja-build \
    git \
    lcov \
    curl \
    sudo \
    wget \
    clang-format-9 \
    && ln -s /usr/bin/clang-format-9 /usr/bin/clang-format \
    && mv /usr/bin/lsb_release /usr/bin/lsb_release.bak \
    && apt-get -y autoclean \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt-get/lists/*

# Install CMake
ARG CMAKE_VERSION=3.16
ARG CMAKE_BUILD=4
ARG CMAKE_INSTALL_DIR=/root
RUN cd $CMAKE_INSTALL_DIR \
    && wget https://cmake.org/files/v$CMAKE_VERSION/cmake-$CMAKE_VERSION.$CMAKE_BUILD-Linux-x86_64.tar.gz  \
    && tar xzf cmake-$CMAKE_VERSION.$CMAKE_BUILD-Linux-x86_64.tar.gz  \
    && rm -rf cmake-$CMAKE_VERSION.$CMAKE_BUILD-Linux-x86_64.tar.gz  \
    && cd cmake-$CMAKE_VERSION.$CMAKE_BUILD-Linux-x86_64  \
    && ./bin/cmake --version

ENV PATH="${CMAKE_INSTALL_DIR}/cmake-${CMAKE_VERSION}.${CMAKE_BUILD}-Linux-x86_64/bin:${PATH}"
