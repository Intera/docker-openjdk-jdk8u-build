FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8

ARG OPENJDK_BUILD_TAG="jdk8u302-ga"

RUN sed -i -E "s/^# deb-src (.+)/deb-src \1/g" /etc/apt/sources.list

RUN apt-get update && apt-get -y dist-upgrade

RUN apt-get install -y build-essential

RUN apt-get build-dep -y openjdk-8-jre --dry-run | grep "Inst" | cut -d " " -f2 > /var/openjdk_build_deps.txt

RUN apt-get build-dep -y openjdk-8-jre

RUN apt-get install -y mercurial

WORKDIR /opt

RUN hg clone http://hg.openjdk.java.net/jdk8u/jdk8u jdk8u

WORKDIR /opt/jdk8u

RUN hg checkout $OPENJDK_BUILD_TAG

RUN bash get_source.sh

RUN bash ./configure  --with-extra-cxxflags="-Wno-error" --with-extra-cflags="-Wno-error"

RUN make all

RUN apt-get --purge -y autoremove \
    && apt-get autoclean \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
