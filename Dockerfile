FROM alpine:3.20

RUN apk add --no-cache --virtual .build-deps flatpak-builder git && \
    git clone https://github.com/flathub/org.flatpak.Builder.git && \
    cd org.flatpak.Builder && \
    git checkout 7c39b3f05843b925269b7d158aa9b73a68c65c2b && \
    sed -e 's|http://apache.mirrors.spacedump.net/|https://archive.apache.org/dist/|g' \
        -e 's|www.apache.org|archive.apache.org|g' \
        -e 's|datafiles/release/diffstat.tar.gz|archives/diffstat/diffstat-1.62.tgz|' \
        -i org.flatpak.Builder.json && \
    flatpak --system remote-add flathub https://dl.flathub.org/repo/flathub.flatpakrepo && \
    flatpak --system install -y --noninteractive --no-related flathub org.freedesktop.Sdk/x86_64/1.6 && \
    flatpak-builder --system -v --force-clean --sandbox --delete-build-dirs --arch x86_64 \
                    --repo repo --default-branch stable --subject 'org.flatpak.Builder 2018 (7c39b3f0)' \
                    builddir org.flatpak.Builder.json && \
    flatpak --system install -y --noninteractive --no-related "$(pwd)/repo" org.flatpak.Builder/x86_64/stable && \
    cd .. && \
    rm -rf org.flatpak.Builder && \
    apk del .build-deps && \
    apk add --no-cache flatpak git

RUN adduser -D builder

RUN mkdir /build && \
    chown builder:builder /build

#RUN git config --global --add safe.directory /build && \
#    git config --global --add safe.directory /build/yocto

USER builder
WORKDIR /build
