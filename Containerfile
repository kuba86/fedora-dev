FROM fedora:42

LABEL org.opencontainers.image.source=https://github.com/kuba86/fedora-dev

RUN dnf -y update && \
    dnf -y install --skip-unavailable \
    wget \
    util-linux \
    bat \
    fish \
    nano \
    fd-find \
    ncdu \
    ncurses \
    eza \
    p7zip \
    btop \
    bind-utils \
    iftop \
    iputils \
    iproute \
    zip \
    unzip \
    which \
    procps \
    git \
    pip \
    jq \
    speedtest-cli \
    nodejs \
    rsync \
    binutils \
    sysbench && \
    dnf clean all && \
    rm -rf /var/cache/yum
RUN useradd --create-home core
USER core
WORKDIR /home/core
RUN pip list --format=json --outdated | jq '.[].name' | xargs pip install --upgrade --no-warn-script-location && \
    pip install --no-warn-script-location ansible ansible-dev-tools && \
    python3 -m pip install ansible-navigator --user
COPY --chown=core:core setup_files/fish.bashrc .bashrc.d/fish.bashrc
COPY --chown=core:core setup_files/config.fish .config/fish/config.fish
COPY --chown=core:core setup_files/functions .config/fish/functions
COPY --chown=root:root setup_files/core /etc/sudoers.d/core
COPY --chown=root:root setup_files/50-nanorc 50-nanorc
RUN curl https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | sh && \
    rm -f .nano/nanorc.nanorc && \
    rm -f .nano/nanorc && \
    rm -f .nano/shellcheck.sh && \
    rm -f .nano/install.sh && \
    rm -f .nanorc
USER root
WORKDIR /home/core
RUN mkdir /usr/share/nano-syntax-highlighting && \
    mv /home/core/.nano/* /usr/share/nano-syntax-highlighting && \
    chown root:root /usr/share/nano-syntax-highlighting/* && \
    rmdir /home/core/.nano && \
    cat /home/core/50-nanorc >> /etc/nanorc && \
    rm -f 50-nanorc && \
    rm -f /tmp/* && \
    chmod 600 /etc/sudoers.d/core && \
    echo "export EDITOR=nano" > /etc/profile.d/99-default-editor.sh
USER core
WORKDIR /home/core
