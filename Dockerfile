FROM debian:10-slim

ARG DEBIAN_FRONTEND=noninteractive

ENV \
    GOSU_VERSION=1.14 \
    GOSU_WORKDIR=/srv \
    GOSU_USER="_www" \
    GOSU_HOME="/home" \
    PATH=/root/.cargo/bin:$PATH \
    PATH=${GOSU_HOME}/.cargo/bin:$PATH

WORKDIR /srv

COPY docker/entrypoint.sh /bin/entrypoint
ENTRYPOINT ["/bin/entrypoint"]

RUN set -xe \
    && apt-get update \
    && apt-get upgrade -y

RUN apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
        pkg-config `# For Tauri to build system libs (like Cargo crates ending with "-sys")` \
        gcc gcc-multilib `# For Tauri to build C libs` \
        xvfb xauth `# Headless X server, to test Tauri apps` \
        webkit2gtk-driver `# For testing, creates a webdriver to GTK-based apps` \
        \
        `# Build tools needed by Tauri` \
        libssl-dev libglib2.0 libgtk-3-dev libjavascriptcoregtk-4.0-dev libsoup2.4-dev libwebkit2gtk-4.0-dev

RUN `# User and entrypoint management` \
    && chmod +x /bin/entrypoint \
    && (curl -L -s -o /bin/gosu https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture | awk -F- '{ print $NF }')) \
    && chmod +x /bin/gosu \
    && mkdir -p ${GOSU_HOME} \
    && groupadd ${GOSU_USER} \
    && adduser --home=${GOSU_HOME} --shell=/bin/bash --ingroup=${GOSU_USER} --disabled-password --quiet --gecos "" --force-badname ${GOSU_USER} \
    && chown ${GOSU_USER}:${GOSU_USER} ${GOSU_HOME}

RUN `# Node.js` \
    && (curl -fsSL https://deb.nodesource.com/setup_16.x | bash -) \
    && apt-get install -y --no-install-recommends nodejs \
    && npm i -g npm yarn

RUN `# Rust` \
    && gosu ${GOSU_USER}:${GOSU_USER} bash -c 'curl https://sh.rustup.rs -sSf | bash -s -- -y'

RUN `# Disable IPV6 for Tauri to be able to run its driver with IPV4 in local` \
    && echo "" > /etc/sysctl.d/99-disable-ipv6.conf \
    && echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.d/99-disable-ipv6.conf \
    && echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.d/99-disable-ipv6.conf \
    && echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.d/99-disable-ipv6.conf

RUN `# Clean apt and remove unused libs/packages to make image smaller` \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/* \
    /var/www/* \
    /var/cache/* \
    /usr/share/doc/* \
    /usr/share/icons/* \
    /root/.npm/* \
    /root/.cargo/registry/* \
    /root/.cargo/git/*
