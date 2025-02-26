vim.opt.number = true

vim.opt.tabstop = 4 -- number of visual spaces per TAB
vim.opt.softtabstop = 4 -- number of spacesin tab when editing
vim.opt.shiftwidth = 4 -- insert 4 spaces on a tab
vim.opt.expandtab = true -- tabs are spaces, mainly because of python

-- colorscheme
vim.o.termguicolors = true
vim.o.background = 'dark'
vim.cmd.colorscheme('catppuccin-macchiato')

-- clipboard
vim.opt.clipboard:append('unnamedplus') -- use system clipboard as default register
