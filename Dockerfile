FROM ubuntu:14.04
MAINTAINER desk

ENV USERNAME desktester
RUN adduser --disabled-password --gecos "" desktester 
RUN apt-get update && apt-get install -y vim expect zsh fish

WORKDIR /home/$USERNAME/
ADD desk /usr/local/bin/desk
ADD test/zshrc .zshrc
ADD test/bashrc .bashrc
ADD test/run_tests.sh run_tests.sh
ADD test/run_tests.fish run_tests.fish
ADD examples examples
RUN mkdir -p .config/fish && touch .config/fish/config.fish

# Set up test Deskfile
RUN mkdir -p example-project && cp examples/hello.sh example-project/Deskfile

RUN chown -R $USERNAME:$USERNAME .zshrc example-project examples run_tests.fish run_tests.sh .bashrc .config

USER $USERNAME
