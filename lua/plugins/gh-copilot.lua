return {
    "github/copilot.vim",
    lazy = true,
    event = { "InsertEnter", "VeryLazy" },
    config = function()
        vim.cmd([[Copilot enable]])
    end,
}