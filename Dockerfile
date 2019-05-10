FROM ubuntu:latest
MAINTAINER rorono <kosuke19952000@gmail.com>

# env
ENV USER developer
ENV HOME /home/${USER}
ENV SHELL /bin/bash

# default locale
RUN set -x \
    && apt-get update \
    && apt-get install -y language-pack-ja-base language-pack-ja \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && locale-gen ja_JP.UTF-8

# apt update
RUN set -x \
    && apt-get update \
    && apt-get install -y sudo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# add sudo user
RUN groupadd --gid 1000 ${USER} && \
    useradd  --uid 1000 --gid 1000 --groups sudo --create-home --shell /bin/bash ${USER} && \
    echo "${USER}:P@ssw0rd" | chpasswd

RUN echo 'Defaults visiblepw'            >> /etc/sudoers
RUN echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN set -x \
    && apt-get update \
    && apt-get install -y build-essential cmake file git curl wget ruby vim zsh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

USER ${USER}
WORKDIR $HOME

# install linuxbrew
RUN set -x \
    && git clone https://github.com/Homebrew/brew $HOME/.linuxbrew/Homebrew \
    && mkdir $HOME/.linuxbrew/bin \
    && ln -s ../Homebrew/bin/brew $HOME/.linuxbrew/bin \
    && eval $($HOME/.linuxbrew/bin/brew shellenv)
ENV PATH $HOME/.linuxbrew/bin:$PATH

# setup anyenv
RUN set -x \
    && git clone https://github.com/anyenv/anyenv $HOME/.anyenv
ENV PATH $HOME/.anyenv/bin:$PATH

RUN set -x \
    && echo 'eval "$(anyenv init -)"' >> $HOME/.bashrc \
    && anyenv install --force-init

RUN set -x \
    && anyenv install rbenv \
    && anyenv install nodenv \
    && exec $SHELL -l

RUN set -x \
    && apt-get update \
    && apt-get install -y libssl-dev libreadline-dev zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \

# RUN set -x \
#     && eval "$(anyenv init -)" \
#     && rbenv install 2.6.3 \
#     && rbenv global 2.6.3 \
#     && nodenv install -l 12.1.0 \
#     && nodenv global 12.1.0
