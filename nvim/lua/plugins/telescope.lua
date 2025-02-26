return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = { 'nvim-lua/plenary.nvim' },

  config = function()
    local builtin = require('telescope.builtin')

    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
    vim.keymap.set('n', '<leader>fa', builtin.live_grep, { desc = 'Telescope live grep' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
    vim.keymap.set('n', '<leader>fg', builtin.git_files, { desc = 'Telescope git files' })
    vim.keymap.set(
      'n',
      '<leader>fs',
      builtin.grep_string,
      { desc = 'Telescope grep selected string' }
    )

    vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = 'Telescope git commits' })
    vim.keymap.set('n', '<leader>gb', builtin.git_branches, { desc = 'Telescope git branches' })
    vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = 'Telescope git status' })
  end,
}
