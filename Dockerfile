FROM rust:1.29.1

RUN apt-get update && apt-get install -y vim screen zsh && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m -s `which zsh` dev
USER dev

WORKDIR /home/dev
#make zsh nice
RUN wget -O .zshrc https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc

#install vim plugins
COPY --chown=dev .vimrc /home/dev/.vimrc
RUN vim -c ":PlugInstall" -c ':q' -c ':q'

#tagbar requires exuberant ctags, so install that as well
USER root
RUN apt-get update && apt-get install -y exuberant-ctags && \
    rm -rf /var/lib/apt/lists/*
USER dev


RUN mkdir workspace
WORKDIR /home/dev/workspace

ENV USER=dev
ENV SHELL=zsh
CMD screen
