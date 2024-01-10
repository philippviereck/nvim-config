return {
  "ThePrimeagen/harpoon",
  dependencies= { "nvim-lua/plenary.nvim" },
  event = "BufWinEnter",
  laazy = true,
  
  config = function()
    local harpoon = require("harpoon")
    -- Keymappings
    local keymap = vim.keymap;
    local opts = { noremap = true, silent = true }
    keymap.set("n", "<leader><tab>", "<cmd>lua require('harpoon.ui').nav_next()<CR>", opts)
    keymap.set("n", "<leader><s-tab>", "<cmd>lua require('harpoon.ui').nav_prev()<CR>", opts)
    keymap.set("n", "<leader>m", "<cmd>lua require('harpoon.mark').add_file()<CR>", opts)
    keymap.set("n","<leader>h", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", opts)
    -- keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references
  end
}
