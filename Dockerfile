FROM ubuntu:latest
MAINTAINER rorono <kosuke19952000@gmail.com>

# user
ENV USER developer
ENV HOME /home/${USER}
ENV SHELL /bin/bash

# default locale
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

# apt update
RUN apt-get update
RUN apt-get install -y sudo

# add sudo user
RUN groupadd --gid 1000 ${USER} && \
    useradd  --uid 1000 --gid 1000 --groups sudo --create-home --shell /bin/bash ${USER} && \
    echo "${USER}:P@ssw0rd" | chpasswd

RUN echo 'Defaults visiblepw'            >> /etc/sudoers
RUN echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN apt-get update
RUN apt-get install -y build-essential file gcc make cmake git curl wget ruby vim zsh

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
    && eval "$(anyenv init -)" \
    && rbenv install 2.6.3 \
    && rbenv global 2.6.3 \
    && nodenv install -l 12.1.0 \
    && nodenv global 12.1.0
