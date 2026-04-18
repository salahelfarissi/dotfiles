# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a modular Neovim configuration using [lazy.nvim](https://github.com/folke/lazy.nvim) as the plugin manager. Entry point is `init.lua`, which bootstraps lazy.nvim and loads all plugin specs from `lua/plugins/`.

## Structure

```
init.lua              # Entry point: bootstraps lazy.nvim, loads core/ and plugins/
lua/core/
  options.lua         # Neovim options (indentation, UI, clipboard, etc.)
  keymaps.lua         # All keybindings (leader = Space)
  snippets.lua        # Diagnostic display config
lua/plugins/
  lsp.lua             # Mason + nvim-lspconfig + fidget
  autocompletion.lua  # nvim-cmp + LuaSnip
  telescope.lua       # Fuzzy finder
  treesitter.lua      # Syntax highlighting + text objects
  none-ls.lua         # Formatters and linters
  debug.lua           # DAP + dap-ui
  ...                 # One file per plugin or plugin group
  themes/             # nord.lua and onedark.lua
```

## Adding / Modifying Plugins

Each plugin file in `lua/plugins/` returns a Lua table (or list of tables) consumed by `lazy.setup()`. To add a new plugin, either create a new file in `lua/plugins/` or add to an existing related file, then require it in `init.lua`.

To disable a plugin, comment out its `require(...)` line in `init.lua`.

## LSP Servers

Managed via Mason. Configured servers live in `lua/plugins/lsp.lua` under the `servers` table. Active servers: `lua_ls`, `pylsp`, `ruff`, `jsonls`, `sqlls`, `terraformls`, `yamlls`, `bashls`, `dockerls`, `docker_compose_language_service`.

To add a new server: add its name to the `servers` table and configure any `settings` if needed.

## Theme Selection

Controlled by the `NVIM_THEME` environment variable:
- `nord` (default)
- `onedark`

Set in shell: `export NVIM_THEME=onedark`

## Code Formatting

Lua files use [StyLua](https://github.com/JohnnyMorganz/StyLua). Config in `.stylua.toml`: 160-column width, 2-space indent, single quotes.

Format Lua: `stylua lua/`

## Useful Neovim Commands

| Command | Purpose |
|---------|---------|
| `:Lazy` | Open plugin manager UI (update, view status) |
| `:Mason` | Open LSP/tool installer |
| `:checkhealth` | Diagnose setup issues |
| `:TSUpdate` | Update Treesitter parsers |
| `:Lazy update` | Update all plugins (check `lazy-lock.json` diff after) |

## Key Architectural Notes

- **Harpoon** is used for primary file navigation (`<leader>1-4` to jump, `<leader>m` to mark).
- **Diagnostics** can be toggled on/off with `<leader>do`.
- **DAP** (debug adapter) is configured for Python and Go via Mason-installed adapters.
- **none-ls** handles formatting/linting that LSP servers don't cover natively.
- Kitty terminal padding auto-adjusts via autocmds when entering/leaving Neovim.
