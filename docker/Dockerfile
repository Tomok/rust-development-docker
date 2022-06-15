#FROM archlinux:latest
FROM rust

#RUN pacman -Sy --noconfirm neovim zsh wget git gcc
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    zsh \
    wget &&\
    rm -rf /var/lib/apt/lists/*
RUN curl -Lo /tmp/nvim-linux64.deb https://github.com/neovim/neovim/releases/download/v0.7.0/nvim-linux64.deb
RUN     echo "4c36e1708b99f24327cde6fff2c19c2b4217e1a289fac90c2c10492df3ea7a71  /tmp/nvim-linux64.deb" | sha256sum -c  -
RUN apt-get update && apt-get install /tmp/nvim-linux64.deb && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /usr/bin/zsh dev
USER dev

WORKDIR /home/dev
#make zsh nice
RUN wget -O .zshrc https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc

#install rust
# RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /tmp/rustup.sh &&\
#   chmod a+x /tmp/rustup.sh &&\
#   /tmp/rustup.sh -y &&\
#   echo "rustup is done" &&\
#   rm /tmp/rustup.sh
# RUN echo "source ${HOME}/.cargo/env" >> /home/dev/zshrc.local
# ENV PATH "/home/dev/.cargo/bin:$PATH"
# USER root
# RUN pacman -Sy --noconfirm openssl
USER dev
RUN cargo install sccache && \
    mkdir -p .cargo && \
    echo "[build]" >> .cargo/config && \
    echo "rustc-wrapper = \"$(which sccache)\"" >> .cargo/config
RUN cargo install topgrade && cargo install cargo-update

RUN mkdir -p /home/dev/.config/nvim
COPY init.vim /home/dev/.config/nvim


#install vim plugins
COPY --chown=dev .vimrc /home/dev/.vimrc
RUN nvim -c ":PlugInstall" -c ':q' -c ':q'
RUN sed -e "/^.*MARKER_PLUGINS_INSTALLED.*$/d"  -i ~/.vimrc

#install rust-analyzer
RUN rustup component add clippy
RUN mkdir -p /home/dev/.local/bin &&\
    curl -L  https://github.com/rust-lang/rust-analyzer/releases/download/2022-06-13/rust-analyzer-x86_64-unknown-linux-gnu.gz -o - | gunzip > ~/.local/bin/rust-analyzer  &&\
    chmod +x ~/.local/bin/rust-analyzer
RUN echo 'export PATH=$PATH:/home/dev/.local/bin' >> /home/dev/.zshrc.local

#do not show startup message of screen
#RUN echo 'startup_message off' >> ~/.screenrc

USER root
# add ssh deamon, since docker does not like vim in screen partially overwriting things
#RUN apt-get update && apt-get install -y openssh-server && \
#    rm -rf /var/lib/apt/lists/*

#RUN mkdir /var/run/sshd
RUN echo 'dev:dev' | chpasswd
RUN echo 'root:root' | chpasswd

# allow root login & X11 forwarding
#RUN sed -i -e 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' -e 's/#.*X11UseLocalhost.*/X11UseLocalhost no/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
#RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

#ENV NOTVISIBLE "in users profile"
#RUN echo "export VISIBLE=now" >> /etc/profile

#EXPOSE 22
#RUN pacman -Sy --noconfirm openssh
#CMD ["/usr/sbin/sshd", "-D"]

# export RUST environment variables into profile
#RUN for k in RUSTUP_HOME CARGO_HOME PATH RUST_VERSION; do v=$(eval echo "\$$k");echo "export ${k}=${v}" >> /etc/profile.d/rust_env.sh; done && \
#    chmod a+x /etc/profile.d/rust_env.sh && \
#    echo "source /etc/profile.d/rust_env.sh" >> /etc/zsh/zprofile

USER dev
ENV SHELL=zsh
CMD zsh
# ENV USER=dev
# ENV SHELL=zsh
# CMD screen