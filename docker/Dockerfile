#FROM archlinux:latest
FROM rust

#RUN pacman -Sy --noconfirm neovim zsh wget git gcc
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    sudo \
    zsh \
    tmux \
    gcc \
    libclang-dev \
    wget \
    lldb &&\
    rm -rf /var/lib/apt/lists/*
RUN curl -Lo /tmp/nvim-linux64.deb https://github.com/neovim/neovim/releases/download/v0.8.3/nvim-linux64.deb
RUN     echo "0828910da0b532e7564b1d200645bd846e6b2e1d10aa3111e36b59c1521b16f0  /tmp/nvim-linux64.deb" | sha256sum -c  -
RUN apt-get update && apt-get install /tmp/nvim-linux64.deb && rm -rf /var/lib/apt/lists/*
# register nvim as editor
RUN update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60 && \
    update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60 && \
    update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60

RUN useradd -m -s /usr/bin/zsh dev && usermod -aG sudo dev && echo 'dev:dev' | chpasswd
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
RUN cargo install topgrade cargo-update gitui

RUN mkdir -p /home/dev/.config/nvim
COPY init.vim /home/dev/.config/nvim


#install vim plugins
COPY --chown=dev .vimrc /home/dev/.vimrc
RUN nvim -c ":PlugInstall" -c ':q' -c ':qall'
#RUN echo -e "PlugInstall\nqall" | nvim-S
#RUN nvim --headless +PlugInstall +qall
#RUN echo -e "PlugInstall\nqall" | nvim -n -i NONE -es -S
RUN sed -e "/^.*MARKER_PLUGINS_INSTALLED.*$/d"  -i ~/.vimrc

#install rust-analyzer
RUN rustup component add clippy rustfmt
RUN mkdir -p /home/dev/.local/bin &&\
    curl -L  https://github.com/rust-lang/rust-analyzer/releases/download/2023-02-20/rust-analyzer-x86_64-unknown-linux-gnu.gz -o - | gunzip > ~/.local/bin/rust-analyzer  &&\
    chmod +x ~/.local/bin/rust-analyzer
RUN echo 'export PATH=$PATH:/home/dev/.local/bin' >> /home/dev/.zshrc.local

#do not show startup message of screen
#RUN echo 'startup_message off' >> ~/.screenrc

USER root
# add ssh deamon, since docker does not like vim in screen partially overwriting things
#RUN apt-get update && apt-get install -y openssh-server && \
#    rm -rf /var/lib/apt/lists/*

#RUN mkdir /var/run/sshd
#RUN echo 'root:root' | chpasswd

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
# set lang to unicode for tmux
RUN echo "export LC_ALL=en_IN.UTF-8" >> /etc/zsh/zprofile && \
    echo "export LANG=en_IN.UTF-8" >> /etc/zsh/zprofile && \
    chmod a+x /etc/zsh/zprofile

USER dev
# map files and folders to workspace dir
RUN mkdir -p /home/dev/.ssh && \
    mkdir -p /home/dev/workspace && \
    ln -s /home/dev/workspace/.zsh_history /home/dev/.zsh_history && \
    ln -s /home/dev/workspace/.gitconfig /home/dev/.gitconfig && \
    ln -s /home/dev/workspace/.ssh/id_rsa /home/dev/.ssh/id_rsa && \
    ln -s /home/dev/workspace/.ssh/id_rsa.pub /home/dev/.ssh/id_rsa.pub && \
    ln -s /home/dev/workspace/.ssh/known_hosts /home/dev/.ssh/known_hosts


ENV SHELL=zsh
CMD [ "zsh" , "--login" ]
# ENV USER=dev
# ENV SHELL=zsh
# CMD screen
