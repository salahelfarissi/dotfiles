# My dotfiles

This repository contains the dotfiles for my system.

## Requirements

Ensure you have the following installed on your system.

- Git
- Stow
- Neovim (v0.12.2)

```shell
sudo apt update
sudo apt install stow
```

Backup `.zshrc` file.

```shell
mv .zshrc .zshrc.bak
```

## Installation

Clone this repository into $HOME directory.

```shell
cd ~/dotfiles/
stow --adopt .
```

Verfiy that `~/.zshrc` is a symlink to `~/dotfiles/.zshrc`.

```shell
ls -lha ~/.zshrc
```

## Scripts

Scripts live under `.local/bin/` and are stowed to `~/.local/bin/` (already on `$PATH` via `.zshrc`).

### Kubernetes config management

Rancher kubeconfigs expire (TTL). The workflow is:

1. Download fresh kubeconfigs from Rancher → drop into `~/.kube/dev/`, `~/.kube/staging/`, or `~/.kube/prod/`
2. Run `kube-refresh` to merge them all into `~/.kube/config`
3. Run `kube-ctx-add` (or `kube-ctx-add <cluster> <namespace>`) to create named contexts

The `krx` alias (defined in `.zshrc`) chains both steps.

#### `kube-refresh`

Merges every `*.yaml` in `~/.kube/{dev,staging,prod}/` into a single `~/.kube/config` using
`kubectl config view --flatten`. Skips Windows `Zone.Identifier` sidecar files.

```
kube-refresh            # merge and write ~/.kube/config
kube-refresh --dry-run  # preview merged output without writing
```

Backups written on each run:
- `~/.kube/config-bkp` — rolling (always the previous config)
- `~/.kube/config-bkp.YYYYMMDD-HHMMSS` — timestamped archive

#### `kube-ctx-add`

Creates a `{env}-{namespace}` context in `~/.kube/config`. The env prefix is derived from
the cluster name (`devplatform-kubernetes` → `dev`, `openhypervision` → `staging`,
`open-hypervision` / `environment-sl` → `prod`).

> **Note:** `kubectl get namespaces` is forbidden for this user (Azure RBAC). Namespaces
> must be supplied manually — they are known from the project/team context.

```
kube-ctx-add                          # fzf cluster picker, then type namespace
kube-ctx-add open-hypervision diva    # non-interactive
```

After adding contexts, use `kcgc` (kubectl config get-contexts) to verify.
