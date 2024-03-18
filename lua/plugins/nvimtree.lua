-- return {
-- "preservim/nerdtree",
--   config = function ()
--
--     require("nerdtree").setup({
--       m
--     })
--    local keymap = vim.api.nvim_set_keymap 
--
--     keymap('n', '<C-n>', ':NERDTreeToggle<CR>', {noremap = true, silent = true})
--   end
-- }
return {
  "nvim-tree/nvim-tree.lua",
  config = function ()
   require("nvim-tree").setup()
    local keymap = vim.api.nvim_set_keymap

    keymap('n', '<C-n>', ':NvimTreeToggle<CR>', {noremap = true, silent = true})
    
  end
}
