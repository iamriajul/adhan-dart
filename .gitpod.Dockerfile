FROM gitpod/workspace-full

RUN brew tap dart-lang/dart && brew install dart

USER root

RUN apt install snapd -y

RUN snap install flutter --classic
