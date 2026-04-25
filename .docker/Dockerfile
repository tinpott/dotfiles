FROM ubuntu:24.04

RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        less \
        neovim \
        openssh-client \
        ranger \
        tmux \
        vim \
        wget \
        zsh \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/ssh-seed \
    && ssh-keyscan -t rsa,ecdsa,ed25519 github.com > /etc/ssh-seed/known_hosts

ENV EDITOR=nvim VISUAL=nvim

WORKDIR /work/dotfiles

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["sleep", "infinity"]
