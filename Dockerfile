FROM ubuntu:14.04
MAINTAINER desk

WORKDIR /desk
ADD desk /usr/local/bin/desk
ADD examples examples
