FROM gitpod/workspace-full

RUN brew tap dart-lang/dart && brew install dart

USER root

RUN apt-get update

RUN apt-get -y install snapd

RUN snap install flutter --classic

USER gitpod
