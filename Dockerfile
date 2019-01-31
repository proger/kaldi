#FROM ubuntu:latest
FROM nvidia/cuda:9.1-devel-ubuntu16.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq

RUN apt-get install -y \
    git bzip2 unzip wget sox \
    g++ make python python3 \
    zlib1g-dev automake autoconf libtool subversion \
    libatlas-base-dev

COPY . /usr/local/kaldi

WORKDIR /usr/local/kaldi/tools
RUN extras/check_dependencies.sh && make -j8 && find . -name '*.o' -delete

WORKDIR /usr/local/kaldi/src
RUN ./configure --shared && make depend -j8 && make -j8 && find . -name '*.o' -delete

WORKDIR /usr/local/kaldi/egs/apiai_decode/s5
RUN ./download-model.sh && rm -f *.zip
