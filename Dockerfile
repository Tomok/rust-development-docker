FROM rust:1.33.0

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
RUN wget -O /home/dev/workspace/rustc-1.33.0-src.tar.gz https://static.rust-lang.org/dist/rustc-1.33.0-src.tar.gz && \
    mkdir ~/rust-src && \
    cd ~/rust-src && \
    tar -xzf/home/dev/workspace/rustc-1.33.0-src.tar.gz   && \
    rm /home/dev/workspace/rustc-1.33.0-src.tar.gz

#add rustformat for cargo fmt and vim command :RustFmt
RUN rustup component add rustfmt-preview

#do not show startup message of screen
RUN echo 'startup_message off' >> ~/.screenrc

USER root
# add ssh deamon, since docker does not like vim in screen partially overwriting things
RUN apt-get update && apt-get install -y openssh-server && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd
RUN echo 'dev:dev' | chpasswd
RUN echo 'root:root' | chpasswd

# allow root login & X11 forwarding
RUN sed -i -e 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' -e 's/#.*X11UseLocalhost.*/X11UseLocalhost no/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

# export RUST environment variables into profile
RUN for k in RUSTUP_HOME CARGO_HOME PATH RUST_VERSION; do v=$(eval echo "\$$k");echo "export ${k}=${v}" >> /etc/profile.d/rust_env.sh; done && \
    chmod a+x /etc/profile.d/rust_env.sh && \
    echo "source /etc/profile.d/rust_env.sh" >> /etc/zsh/zprofile

# USER dev
# ENV USER=dev
# ENV SHELL=zsh
# CMD screen
