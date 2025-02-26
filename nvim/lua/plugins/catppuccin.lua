return {
  require('catppuccin').setup({
    flavour = 'mocha',
    transparent_background = false,
    styles = {
      comments = { 'italic' },
    },
    custom_highlights = function(colors)
      return {
        Comment = { fg = colors.flamingo },
        TabLineSel = { bg = colors.pink },
        CmpBorder = { fg = colors.surface2 },
        Pmenu = { bg = colors.none },
      }
    end,
  }),
}
