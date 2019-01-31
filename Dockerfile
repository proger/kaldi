#FROM ubuntu:latest
FROM nvidia/cuda:9.1-devel-ubuntu16.04

MAINTAINER sih4sing5hong5

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq

RUN apt-get install -y \
    git bzip2 unzip wget sox \
    g++ make python python3 \
    zlib1g-dev automake autoconf libtool subversion \
    libatlas-base-dev

COPY . /usr/local/kaldi

WORKDIR /usr/local/kaldi/tools
RUN extras/check_dependencies.sh
RUN make -j4

WORKDIR /usr/local/kaldi/src
RUN ./configure
RUN make depend -j4
RUN make -j4

