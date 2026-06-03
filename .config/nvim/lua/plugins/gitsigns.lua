-- Adds git related signs to the gutter, as well as utilities for managing changes
return {
  'lewis6991/gitsigns.nvim',
  opts = {
    -- Disable the git dir watcher to avoid "Not in async context" errors on
    -- Neovim 0.12+ where the watcher fires during the initial attach and
    -- races with the in-progress async update task.
    watch_gitdir = {
      enable = false,
    },
    -- See `:help gitsigns.txt`
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    signs_staged = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      local map = function(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
      end
      map('n', '<leader>gb', gs.blame_line, 'Git blame line')
      map('n', '<leader>gB', function() gs.blame_line({ full = true }) end, 'Git blame line (full)')
    end,
  },
}
