FROM ubuntu:latest
LABEL maintainer "rorono <kosuke19952000@gmail.com>"

# env
ENV USER developer
ENV HOME /home/${USER}
SHELL ["/bin/bash", "-c"]

# default locale
RUN set -x \
    && apt-get update \
    && apt-get install -y language-pack-ja-base language-pack-ja \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && locale-gen ja_JP.UTF-8 \
    && update-locale LANG=ja_JP.UTF-8

# apt update
RUN set -x \
    && apt-get update \
    && apt-get install -y sudo gosu \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# add sudo user
RUN groupadd --gid 1000 ${USER} && \
    useradd  --uid 1000 --gid 1000 --groups sudo --create-home --shell $SHELL ${USER} && \
    echo "${USER}:P@ssw0rd" | chpasswd

RUN echo 'Defaults visiblepw'            >> /etc/sudoers
RUN echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# bisic dependent libs
RUN set -x \
    && apt-get update \
    && apt-get install -y build-essential cmake file git curl wget ruby vim zsh python mysql-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# python3 development dependent libs
RUN set -x \
    && apt-get update \
    && apt-get install -y libffi-dev libbz2-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# basic development dependent libs
RUN set -x \
    && apt-get update \
    && apt-get install -y libssl-dev libreadline-dev zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# rails development dependent libs
RUN set -x \
    && apt-get update \
    && apt-get install -y libsqlite3-dev default-libmysqlclient-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["docker-entrypoint.sh"]
