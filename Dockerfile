# Docker container for testing on CI

FROM ubuntu:latest

RUN apt-get update && \
    apt-get install --no-install-recommends --no-upgrade -qq build-essential libtool autotools-dev automake git \
    ca-certificates ccache

WORKDIR /tmp

RUN git clone https://github.com/sipa/minisketch.git

WORKDIR minisketch

RUN ./autogen.sh && ./configure
RUN make -j"$(($(nproc)+1))" install
