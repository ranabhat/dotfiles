return {
  'rcarriga/nvim-notify',
  enabled = true,
  event = 'VeryLazy',
  config = function()
    require('notify').setup {
      -- Example settings
      stages = 'fade_in_slide_out', -- animation style
      timeout = 3000, -- time (ms) before closing
      background_colour = '#000000', -- background color
      render = 'default', -- render style: minimal, default, compact
    }

    -- Set as the default notification provider
    vim.notify = require 'notify'
  end,
}
