FROM rust:1.29.1

RUN apt-get update && apt-get install -y vim screen zsh && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m -s `which zsh` dev
USER dev

WORKDIR /home/dev
#make zsh nice
RUN wget -O .zshrc https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc

#install vim plugins
RUN mkdir -p ~/.vim/autoload ~/.vim/bundle && \
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

RUN git clone https://github.com/rust-lang/rust.vim ~/.vim/bundle/rust.vim

RUN git clone https://github.com/majutsushi/tagbar.git ~/.vim/bundle/tagbar.vim
USER root
RUN apt-get update && apt-get install -y exuberant-ctags && \
    rm -rf /var/lib/apt/lists/*
USER dev

RUN git clone https://github.com/scrooloose/syntastic.git ~/.vim/bundle/syntastic

RUN git clone https://github.com/vim-airline/vim-airline ~/.vim/bundle/vim-airline
RUN git clone https://github.com/vim-airline/vim-airline-themes ~/.vim/bundle/vim-airline-themes

RUN git clone git://github.com/airblade/vim-gitgutter.git ~/.vim/bundle/vim-gutter
#RUN git clone https://github.com/mhinz/vim-signify ~/.vim/bundle/vim-signify

COPY --chown=dev .vimrc /home/dev/.vimrc

RUN mkdir workspace
WORKDIR /home/dev/workspace

ENV USER=dev
CMD zsh


