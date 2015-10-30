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
ADD examples examples
RUN chown -R $USERNAME:$USERNAME .zshrc examples run_tests.sh .bashrc

USER $USERNAME
