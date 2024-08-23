FROM ubuntu:18.04

RUN apt update && \
    apt upgrade -y && \
    apt install -y build-essential cpio chrpath diffstat flatpak gawk git locales ostree python texinfo wget && \
    apt clean

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen

ENV LANG=en_US.UTF-8

RUN useradd -ms /bin/bash builder

RUN mkdir /build && \
    chown builder:builder /build

RUN git config --global --add safe.directory /build && \
    git config --global --add safe.directory /build/yocto

USER builder
WORKDIR /build
