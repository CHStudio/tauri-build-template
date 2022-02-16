FROM ubuntu:21.10

ARG DEBIAN_FRONTEND=noninteractive

ENV PATH=/root/.cargo/bin:$PATH

COPY docker/entrypoint.sh /bin/entrypoint

ENTRYPOINT ["/bin/entrypoint"]

RUN set -xe \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        libssl-dev `# For Tauri to implement security components` \
        gcc gcc-multilib `# For Tauri to build C libs` \
        libgtk-3-dev libsoup2.4 libsoup2.4-dev libwebkit2gtk-4.0 libwebkit2gtk-4.0-dev \
        patchelf librsvg2-dev `# For Tauri to be able to create a linux image` \
        libappindicator3-dev `# For Tauri to use the system tray feature` \
        webkit2gtk-driver `# For testing, creates a webdriver to GTK-based apps` \
        git \
        wget \
        curl \
        dialog apt-utils `# Prevents having this issue: https://github.com/moby/moby/issues/27988` \
    \
    && `# Node.js` \
    && (curl -fsSL https://deb.nodesource.com/setup_16.x | bash -) \
    && apt-get install -y --no-install-recommends nodejs \
    && npm i -g yarn \
    \
    && `# Rust` \
    && (curl https://sh.rustup.rs -sSf | bash -s -- -y) \
    \
    && `# Clean apt and remove unused libs/packages to make image smaller` \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false \
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
