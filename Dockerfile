FROM debian:10-slim

ARG DEBIAN_FRONTEND=noninteractive

ENV \
    GOSU_VERSION=1.14 \
    GOSU_WORKDIR=/srv \
    GOSU_USER="_www" \
    GOSU_HOME="/home" \
    PATH=/root/.cargo/bin:$PATH \
    PATH=${GOSU_WORKDIR}/.cargo/bin:$PATH

WORKDIR /srv

COPY docker/entrypoint.bash /bin/entrypoint
ENTRYPOINT ["/bin/entrypoint"]

RUN set -xe \
    && apt-get update \
    && apt-get upgrade -y

RUN apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        libssl-dev `# For Tauri to implement security components` \
        gcc gcc-multilib `# For Tauri to build C libs` \
        libgtk-3-dev libsoup2.4 libsoup2.4-dev libwebkit2gtk-4.0 libwebkit2gtk-4.0-dev \
        patchelf librsvg2-dev `# For Tauri to be able to create a linux image` \
        libappindicator3-dev `# For Tauri to use the system tray feature` \
        webkit2gtk-driver `# For testing, creates a webdriver to GTK-based apps` \
        git \
        curl \
        dialog apt-utils `# Prevents having this issue: https://github.com/moby/moby/issues/27988`

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

RUN `# Webdriver binaries` \
    && (curl -L https://github.com/mozilla/geckodriver/releases/download/v0.30.0/geckodriver-v0.30.0-linux64.tar.gz | tar xz -C /usr/local/bin/) \
    && npm install -g chromedriver

RUN `# Rust` \
    && gosu ${GOSU_USER}:${GOSU_USER} bash -c 'curl https://sh.rustup.rs -sSf | bash -s -- -y'

RUN `# Disable IPV6 for Tauri to be able to run its driver with IPV4 in local` \
    && echo "net.ipv6.conf.all.disable_ipv6=1" > /etc/sysctl.conf \
    && echo "net.ipv6.conf.default.disable_ipv6=1" > /etc/sysctl.conf \
    && echo "net.ipv6.conf.lo.disable_ipv6=1" > /etc/sysctl.conf

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
