FROM ubuntu:jammy

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV DEBIAN_FRONTEND=noninteractive

ENV USERNAME desktester
RUN adduser --disabled-password --gecos "" desktester 

RUN set -eux; \
      \
      apt-get update -y; \
      apt-get install -y \
        vim \
        expect \
        zsh \
        fish \
      ; \
      apt-get clean; \
      rm -f /var/lib/apt/lists/*_*

WORKDIR /home/$USERNAME/

COPY desk /usr/local/bin/desk
COPY test/zshrc .zshrc
COPY test/bashrc .bashrc
COPY test/run_tests.sh run_tests.sh
COPY test/run_tests.fish run_tests.fish
COPY examples examples

RUN set -eux; \
      \
      mkdir -p .config/fish; \
      touch .config/fish/config.fish; \
      # Set up test Deskfile \
      mkdir -p example-project; \
      cp examples/hello.sh example-project/Deskfile; \
      \
      chown -R $USERNAME:$USERNAME .zshrc example-project examples run_tests.fish run_tests.sh .bashrc .config

USER $USERNAME
