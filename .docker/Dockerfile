FROM ubuntu:24.04

RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
        openssh-client \
        ca-certificates \
        neovim \
        less \
        curl \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/ssh-seed \
    && ssh-keyscan -t rsa,ecdsa,ed25519 github.com > /etc/ssh-seed/known_hosts

ENV EDITOR=nvim VISUAL=nvim

WORKDIR /work/dotfiles

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["sleep", "infinity"]
