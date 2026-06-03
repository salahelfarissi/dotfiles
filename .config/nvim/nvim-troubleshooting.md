# Troubleshooting Notes for Neovim Setup

- Check generate health of Neovim setup. `:checkhealth`
- Run the deprecated health check from the CLI. `nvim --headless "+checkhealth vim.deprecated" "+qa"`
- Capture the deprecated health check to a file when needed. `nvim --headless "+checkhealth vim.deprecated" "+write! /tmp/nvim-vim-deprecated-health.txt" "+qa"`
- If upstream plugins still emit `vim.deprecated` warnings on Neovim `0.12.x`, prefer Neovim `0.11.x` until the relevant plugin versions catch up.
- Update Treesitter. `:TSUpdate`
- Check LSP installation. `:Mason`
- Fix broken icons
  - Download [nerdfix](https://github.com/loichyan/nerdfix) binary and unpack in home directory.
  - Run `nerdfix check <path/to/file>` to check broken icons in a file
  - Run `nerdfix fix <path/to/file>` to fix broken icons in a file
