
return {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = 'nvim-tree/nvim-web-devicons',

  config = function()
    vim.opt.termguicolors = true
    require("bufferline").setup {}
    -- mappings <C-X> close buffer
    -- mappings <tab> next buffer
    -- mappings <S-tab> previous buffer

    local map = vim.api.nvim_set_keymap
    local opts = { noremap = true, silent = true }

    map('n', '<C-x>', ':bd<CR>', opts)
    map('n', '<TAB>', ':bn<CR>', opts)
    map('n', '<S-TAB>', ':bp<CR>', opts)

  end
}
