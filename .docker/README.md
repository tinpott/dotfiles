# Dotfiles dev container

A long-lived Docker container for working on any branch of this repo without touching the local checkout.

Your `~/.ssh` is mounted read-only so `git push`/`git pull` against `origin` work with your real keys. Nothing outside
`~/.ssh` and `~/.gitconfig` on the host is read or written.

## Dependencies

- `docker`
- `docker-compose` plugin
- `~/.gitconfig`
- SSH keys at `~/.ssh` that are authorized to push to `origin`

## Usage

On the host:

```sh
cd <path-to-clone>/.docker

# Create the container
docker compose up -d

# Drop into an existing container
docker compose exec dev bash
```

In the container, switch branches with plain git:

```sh
git checkout some-feature
git checkout -b new-thing
```

### Overriding the sources at initialization

To override the initial branch or remote at first create:

```sh
# Override the initial branch
BRANCH=some-feature docker compose up -d

# Override the inital remote
REPO_URL=git@github.com:some-user/some-repo.git docker compose up -d
```

These env vars only affect the initial clone/checkout. After that, use git inside the container.

## Lifecycle

| Command                           | Effect                                                        |
| --------------------------------- | ------------------------------------------------------------- |
| `docker compose up -d`            | Build if needed, create if needed, start.                     |
| `docker compose exec dev bash`    | Open a shell in the running container.                        |
| `docker compose stop`             | Stop without removing. Work is preserved.                     |
| `docker compose start`            | Start a stopped container.                                    |
| `docker compose down`             | Stop and remove the container. **In-container work is lost!** |
| `docker compose build --no-cache` | Rebuild the image from scratch.                               |

The container has `restart: unless-stopped`, so it comes back up after a host reboot.

## Persistence

Everything inside the container persists across `stop`/`start` cycles and host reboots:

- uncommitted work in `/work/dotfiles`
- shell history
- anything you `apt install` ad-hoc

`docker compose down` (or `docker rm -f dotfiles-dev`) **destroys the container** and any uncommitted work with it. Push
or commit before tearing down.

## Notes

- SSH keys are copied from the read-only mount (`/root/.ssh-host`) to `/root/.ssh` at start so SSH's strict perm checks
  pass.
- `github.com` is added to `known_hosts` automatically if your host's `~/.ssh/known_hosts` doesn't already contain it.
- If you use XDG-style git config at `~/.config/git/config`, either `touch ~/.gitconfig` as well or edit `compose.yml`
  to mount the XDG path instead.
