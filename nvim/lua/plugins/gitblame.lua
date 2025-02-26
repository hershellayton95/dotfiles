return {
  'f-person/git-blame.nvim',
  event = 'VeryLazy',
  opts = {
    enabled = true, -- if you want to enable the plugin
    message_when_not_committed = 'Oh please, commit this!',
    message_template = ' <date> • <author> • <<sha>>', -- template for the blame message, check the Message template section for more options
    date_format = '%m-%d-%Y %H:%M:%S', -- template for the date, check Date format section for more options
    virtual_text_column = 1, -- virtual text start column, check Start virtual text at column section for more options
    highlight_group = 'Question',
    delay = 500, -- 1 second
  },
}
