local bufferline = require('bufferline')

vim.opt.termguicolors = true

bufferline.setup {
  options = {
    mode = "buffers",

    left_trunc_marker = '',
    right_trunc_marker = '',
    offsets = {
      {
        filetype = "NvimTree",
        separator = true
      }
    },
    separator_style = "slant",

    hover = {
      enabled = true,
      delay = 100,
      reveal = { 'close' }
    },

    show_buffer_close_icons = true,
    show_close_icon = false,
    show_tab_indicators = true,

    indicator = {
      style = 'underline',
    },

    -- numbers = function(opts)
    --     return string.format('%s', opts.ordinal)
    -- end


  }

}
