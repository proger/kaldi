FROM ubuntu:latest

MAINTAINER sih4sing5hong5

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq 

RUN apt-get install -y \
    git bzip2 wget sox \
    g++ make python python3 \
    zlib1g-dev automake autoconf libtool subversion \
    libatlas-base-dev
RUN apt-get install -y unzip

COPY . /usr/local/kaldi

WORKDIR /usr/local/kaldi/tools
RUN extras/check_dependencies.sh
RUN make -j

WORKDIR /usr/local/kaldi/src
RUN ./configure
RUN make depend -j
RUN make -j
