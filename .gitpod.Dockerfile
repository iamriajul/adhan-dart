FROM gitpod/workspace-full

RUN brew tap dart-lang/dart && brew install dart

USER root

RUN apt install snapd

run snap install flutter --classic
