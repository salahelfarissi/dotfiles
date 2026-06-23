# Repository Guidelines

## Project Structure & Module Organization

This repository stores personal dotfiles intended to be installed from `$HOME` with GNU Stow. Top-level shell/editor files include `.zshrc`, `.zshrc.wsl`, `.vimrc`, `.gitignore`, and `README.md`.

Configuration grouped by application lives under `.config/`:

- `.config/nvim/`: Neovim configuration, plugins, Tree-sitter queries, and `lazy-lock.json`.
- `.config/tmux/tmux.conf`: tmux configuration.
- `.config/ghostty/config`: Ghostty terminal settings.
- `.config/cmux/settings.json`: cmux settings.
- `.claude/CLAUDE.md`: Claude-specific local instructions.

For Neovim-only work, also read `.config/nvim/AGENTS.md`; it contains more specific module and formatting guidance.

## Build, Test, and Development Commands

- `stow --adopt .`: symlink this repository into the home directory. Use carefully because it can adopt existing files into the repo.
- `ls -lha ~/.zshrc`: verify that Stow created a symlink back to `~/dotfiles/.zshrc`.
- `nvim --headless "+Lazy! sync" "+qa"`: sync Neovim plugins after plugin or lockfile changes.
- `nvim --headless "+checkhealth" "+qa"`: run Neovim health checks.
- `stylua .config/nvim/init.lua .config/nvim/lua/`: format Neovim Lua files using `.config/nvim/.stylua.toml`.

There is no general build step for this repository.

## Coding Style & Naming Conventions

Keep dotfiles readable and minimal. Prefer explicit shell aliases/functions, quote paths or variables in shell snippets, and keep machine-specific secrets out of committed files. JSON files should remain valid JSON with consistent indentation.

Lua style for Neovim is defined by StyLua: 2-space indentation, Unix line endings, 160-column width, and preferred single quotes. Keep plugin modules named after their plugin or feature area, such as `telescope.lua` or `lsp.lua`.

## Testing Guidelines

There is no dedicated automated test suite. Validate changes by loading the affected tool and running any relevant health checks. For shell changes, start a fresh `zsh` session or source the file intentionally. For terminal, tmux, or cmux changes, open the affected application and confirm the setting works.

## Commit & Pull Request Guidelines

Recent commits use short, direct messages such as `add ghostty config`, `update cmux config`, and `remove deprecated methods`. Follow that style: imperative or descriptive, lowercase when natural, and focused on one change.

Pull requests should include a brief summary, validation steps run, and screenshots only for visible UI/theme changes. Call out lockfile updates, required external tools, or any migration steps such as rerunning `stow`.

## Agent-Specific Instructions

Do not rewrite unrelated personal preferences. Preserve existing keymaps, aliases, theme choices, and pinned versions unless the task explicitly requires changing them.
