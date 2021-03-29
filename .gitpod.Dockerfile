FROM ubuntu:latest

RUN brew tap dart-lang/dart && brew install dart

USER root

RUN apt-get update

RUN apt-get -y install snapd && systemctl unmask snapd.service && systemctl enable snapd.service && systemctl start snapd.service

RUN snap install flutter --classic

USER gitpod
