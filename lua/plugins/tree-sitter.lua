return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function () 
      local configs = require("nvim-treesitter.configs")

      configs.setup({
	  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "typescript", "javascript", "html", "css", "json", "yaml", "svelte","scss" },
          sync_install = false,
          highlight = { enable = true },
          indent = { enable = true },  
	  auto_install = true
        })
    end
} 
