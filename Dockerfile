FROM nvidia/cuda:9.1-devel-ubuntu16.04 as builder

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq

RUN apt-get install -y \
    git bzip2 unzip wget sox \
    g++ make python python3 \
    zlib1g-dev automake autoconf libtool subversion \
    libatlas-base-dev

COPY . /usr/local/kaldi

RUN rm -rf /usr/local/kaldi/.git

WORKDIR /usr/local/kaldi/tools
RUN extras/check_dependencies.sh
RUN make -j8
RUN find . -name '*.o' -delete
RUN find . -name '*.a' -delete

WORKDIR /usr/local/kaldi/src
RUN ./configure --shared
RUN make depend -j8
RUN make -j8
RUN find . -name '*.o' -delete
RUN find . -name '*.a' -delete
RUN find . -name '*.tar.gz' -delete
RUN find . -name '*.tar.bz2' -delete

WORKDIR /usr/local/kaldi/egs/apiai_decode/s5
RUN ./download-model.sh
RUN rm -f *.zip
#RUN wget https://github.com/mozilla/DeepSpeech/blob/master/data/smoke_test/LDC93S1.wav
#RUN ./recognize-wav.sh LDC93S1.wav

FROM nvidia/cuda:9.1-devel-ubuntu16.04 as run

RUN apt-get update -qq
RUN apt-get install -y wget sox python python3 zlib1g-dev libatlas-base-dev

COPY --from=builder /usr/local/kaldi /usr/local/kaldi
WORKDIR /usr/local/kaldi/egs/apiai_decode/s5
#RUN ./recognize-wav.sh LDC93S1.wav
