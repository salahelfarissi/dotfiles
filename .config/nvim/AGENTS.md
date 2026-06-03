# Repository Guidelines

## Project Structure & Module Organization

This repository is a modular Neovim configuration. `init.lua` is the entry point: it bootstraps `lazy.nvim`, loads `lua/core/*`, then registers plugin modules from `lua/plugins/*`.

- `lua/core/options.lua`: editor options and UI behavior.
- `lua/core/keymaps.lua`: global keymaps, with Space as leader.
- `lua/core/snippets.lua`: snippet and diagnostic-related setup.
- `lua/plugins/`: one file per plugin or plugin group, each returning a lazy.nvim spec.
- `lua/plugins/themes/`: theme modules selected through `NVIM_THEME`.
- `queries/`: custom Tree-sitter queries, currently Markdown injections.
- `lazy-lock.json`: pinned plugin versions; commit intentional updates only.

## Build, Test, and Development Commands

- `nvim`: starts this configuration for manual validation.
- `nvim --headless "+Lazy! sync" "+qa"`: installs or syncs plugins in a noninteractive session.
- `nvim --headless "+checkhealth" "+qa"`: runs Neovim health checks; inspect output for plugin, LSP, or provider failures.
- `stylua init.lua lua/`: formats Lua files according to `.stylua.toml`.
- `nvim "+Lazy"` and `nvim "+Mason"`: inspect plugin and tool state interactively.

## Coding Style & Naming Conventions

Lua formatting is controlled by `.stylua.toml`: 2-space indentation, Unix line endings, 160-column width, preferred single quotes, and omitted call parentheses where StyLua allows them. Keep plugin specs small and cohesive. Name plugin modules after the plugin or feature area, for example `lua/plugins/telescope.lua`, `lua/plugins/lsp.lua`, or `lua/plugins/themes/nord.lua`.

When adding a plugin, create or update a module in `lua/plugins/`, then add its `require 'plugins.name'` entry to `init.lua`. Prefer clear `desc` fields for keymaps and keep comments reserved for non-obvious behavior.

## Testing Guidelines

There is no dedicated automated test suite. Validate changes by formatting Lua, starting Neovim, and running relevant health checks. For plugin, LSP, Tree-sitter, or Mason changes, verify `:Lazy`, `:Mason`, and `:checkhealth`. For lockfile updates, review the `lazy-lock.json` diff before committing.

## Commit & Pull Request Guidelines

Recent commits use short, imperative, lowercase messages such as `remove deprecated methods` and `add ghostty config`. Follow that style: describe the change directly and keep the subject concise.

Pull requests should include a short summary, validation steps run, and screenshots only for visible UI/theme changes. Link related issues when available and call out any plugin lockfile updates or required external tools.

## Agent-Specific Instructions

Avoid broad rewrites of unrelated config. Preserve local preferences such as keymaps, theme selection, and pinned plugin versions unless the task explicitly requires changing them.
