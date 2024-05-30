ARG BASE=ubuntu:22.04
FROM $BASE
WORKDIR /home/coder

# Install dependencies
RUN apt-get update \
  && apt-get install -y \
    curl \
    dumb-init \
    git \
    git-lfs \
    htop \
    locales \
    lsb-release \
    man-db \
    nano \
    openssh-client \
    procps \
    sudo \
    vim \
    wget \
    zsh \
    bash-completion \
  && git lfs install \
  && rm -rf /var/lib/apt/lists/*

# Create known_hosts
RUN mkdir -p /home/coder/.ssh \
    && touch /home/coder/.ssh/known_hosts \
    && ssh-keyscan github.com >> /home/coder/.ssh/known_hosts \
    && echo "    IdentityFile ~/.ssh/id_rsa" >> /etc/ssh/ssh_config

# https://wiki.debian.org/Locale#Manually
RUN sed -i "s/# en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen \
  && locale-gen
ENV LANG=en_US.UTF-8

RUN adduser --gecos '' --disabled-password coder \
  && echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd

RUN ARCH="$(dpkg --print-architecture)" \
  && curl -fsSL "https://github.com/boxboat/fixuid/releases/download/v0.6.0/fixuid-0.6.0-linux-$ARCH.tar.gz" | tar -C /usr/local/bin -xzf - \
  && chown root:root /usr/local/bin/fixuid \
  && chmod 4755 /usr/local/bin/fixuid \
  && mkdir -p /etc/fixuid \
  && printf "user: coder\ngroup: coder\n" > /etc/fixuid/config.yml

# Install zsh
RUN curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh

# Download and install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Download and install Golang
ENV GOLANG_VERSION 1.22.3
RUN curl -fsSL https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz -o golang.tar.gz \
  && tar -C /usr/local -xzf golang.tar.gz \
  && rm golang.tar.gz

ENV GO111MODULE="on"
ENV GOSUMDB="off"
ENV GOROOT="/usr/local/go"
ENV GOPATH="$HOME/go"
ENV PATH="$PATH:$GOROOT/bin:$GOPATH/bin"

COPY ./entrypoint.sh /usr/bin/entrypoint.sh

# Allow users to have scripts run on container startup to prepare workspace.
# https://github.com/coder/code-server/issues/5177
ENV ENTRYPOINTD=${HOME}/entrypoint.d

EXPOSE 8080
# This way, if someone sets $DOCKER_USER, docker-exec will still work as
# the uid will remain the same. note: only relevant if -u isn't passed to
# docker-run.
USER 1000
ENV USER=coder
ENTRYPOINT ["/usr/bin/entrypoint.sh", "--bind-addr", "0.0.0.0:8080", "."]