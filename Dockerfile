FROM rust:1.29.1

RUN apt-get update && apt-get install -y vim-nox screen zsh && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m -s `which zsh` dev
USER dev

WORKDIR /home/dev
#make zsh nice
RUN wget -O .zshrc https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc

#install vim plugins
COPY --chown=dev .vimrc /home/dev/.vimrc
RUN vim -c ":PlugInstall" -c ':q' -c ':q'

USER root
#tagbar requires exuberant ctags, so install that as well
RUN apt-get update && apt-get install -y exuberant-ctags && \
    rm -rf /var/lib/apt/lists/*
#YouComplete me requires stuff
RUN apt-get update && apt-get install -y build-essential cmake python-dev python3-dev && \
    rm -rf /var/lib/apt/lists/*
USER dev


RUN mkdir /home/dev/workspace
WORKDIR /home/dev/workspace

#install YouCompleteMe
RUN cd ~/.vim/plugged/YouCompleteMe && ./install.py --racer-completer
##Racer (used by YouCompleteMe) needs rust sourcecode so download it
RUN wget -O /home/dev/workspace/rustc-1.29.1-src.tar.gz https://static.rust-lang.org/dist/rustc-1.29.1-src.tar.gz && \
    mkdir ~/rust-src && \
    cd ~/rust-src && \
    tar -xzf/home/dev/workspace/rustc-1.29.1-src.tar.gz   && \
    rm /home/dev/workspace/rustc-1.29.1-src.tar.gz


ENV USER=dev
ENV SHELL=zsh
CMD screen
