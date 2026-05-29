FROM fedora:latest

LABEL org.opencontainers.image.source=https://github.com/kuba86/fedora-dev

COPY --chown=root:root --chmod=644 files/ /etc/yum.repos.d/
COPY packages.txt /tmp/

RUN dnf -y update \
    && dnf -y install --setopt=install_weak_deps=False \
    $(cat /tmp/packages.txt) \
    && dnf clean all \
    && rm -rf /var/cache/{dnf,yum} \
    && rm -rf /var/tmp/* /tmp/*

RUN useradd --create-home core
USER core
WORKDIR /home/core
RUN pip list --format=json --outdated | jq '.[].name' | xargs pip install --upgrade --no-warn-script-location && \
    uv tool install ansible && \
    uv tool install ansible-core && \
    uv tool install ansible-dev-tools && \
    uv tool install ansible-navigator

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
    echo "EDITOR=nano" >> /etc/environment && \
    echo "VISUAL=nano" >> /etc/environment
USER core
WORKDIR /home/core
