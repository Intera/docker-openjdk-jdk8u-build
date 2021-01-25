FROM centos:7

ARG OPENJDK_BUILD_TAG="jdk8u282-ga"

RUN yum install -y java-1.8.0-openjdk-devel

RUN yum-builddep -y java-1.8.0-openjdk-devel

RUN yum groupinstall -y 'Development Tools'

COPY mercurial.repo /etc/yum.repos.d/mercurial.repo

RUN yum install -y mercurial which

WORKDIR /opt

RUN hg clone http://hg.openjdk.java.net/jdk8u/jdk8u jdk8u

WORKDIR /opt/jdk8u

RUN hg checkout $OPENJDK_BUILD_TAG

RUN bash get_source.sh

RUN bash ./configure  --with-extra-cxxflags="-Wno-error" --with-extra-cflags="-Wno-error"

RUN make all
