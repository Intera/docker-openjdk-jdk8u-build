FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8

ARG OPENJDK_BUILD_TAG="jdk-11.0.12-ga"

RUN sed -i -E "s/^# deb-src (.+)/deb-src \1/g" /etc/apt/sources.list

RUN apt-get update && apt-get -y dist-upgrade

RUN apt-get install -y build-essential

RUN apt-get build-dep -y openjdk-11-jre --dry-run | grep "Inst" | cut -d " " -f2 > /var/openjdk_build_deps.txt

RUN apt-get build-dep -y openjdk-11-jre

RUN apt-get install -y mercurial

WORKDIR /opt

RUN hg clone http://hg.openjdk.java.net/jdk-updates/jdk11u jdk11u

WORKDIR /opt/jdk11u

RUN hg checkout $OPENJDK_BUILD_TAG

RUN hg pull

RUN bash ./configure  --with-extra-cxxflags="-Wno-error" --with-extra-cflags="-Wno-error"

RUN make all

RUN apt-get --purge -y autoremove \
    && apt-get autoclean \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
