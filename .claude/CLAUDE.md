# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

Personal dotfiles managed with GNU Stow. The repo mirrors `$HOME`: files live under their target path (e.g. `.zshrc`, `.config/nvim/`) and `stow .` from this directory symlinks them into `~`. When editing a dotfile, edit it here — the symlinked copy in `$HOME` updates automatically.

Platform split: `.zshrc` is the macOS config; `.zshrc.wsl` is a separate file for WSL environments (not symlinked by stow on macOS).

## Installing / Re-stowing

```shell
cd ~/dotfiles
stow --adopt .       # initial install; --adopt moves existing files into the repo
stow -R .            # restow after adding new files
```

Verify a symlink with `ls -lha ~/.zshrc` — it should point into `~/dotfiles/`.

## Shell Environment (`.zshrc`)

Zsh is bootstrapped with [Zinit](https://github.com/zdharma-continuum/zinit) + Powerlevel10k. Plugins are loaded via `zinit light` (full plugins) or `zinit snippet OMZP::<name>` (Oh-My-Zsh plugins pulled individually — we do **not** source `oh-my-zsh.sh`).

Currently loaded OMZ snippets (their aliases are available in the shell): `git`, `kubectl`, `kubectx`, `sudo`, `docker`, `docker-compose`, `common-aliases`, `alias-finder`. Prefer these aliases over the long-form commands when running shell commands:

- `g` for `git`
- `dcup` / `dce` for `docker-compose up` / `docker-compose exec`

After adding a new `zinit snippet` line, run `zinit cdreplay -q` (already in the file) will pick it up on next shell start; no manual action needed.

## Neovim (`.config/nvim/`)

Lua config bootstrapped by `lazy.nvim` (lockfile at `.config/nvim/lazy-lock.json`). Entry point is `init.lua`; plugin specs live under `lua/`. Formatting for Lua is enforced by `stylua` (see `.stylua.toml`).

## Conventions

- When adding a new dotfile, place it at the path it should occupy relative to `$HOME`, then `stow -R .`.
- Docker Compose files in any project: name `compose.yaml` (not `docker-compose.yml`).
- For new repos, ensure a `.claude/CLAUDE.md` exists with project-specific guidance.
