local M = {}
-- TODO: lsp info like in nvchad but it's not working
--
local function stbufnr()
	return vim.api.nvim_win_get_buf(vim.g.statusline_winid)
end
local function is_activewin()
	return vim.api.nvim_get_current_win() == vim.g.statusline_winid
end
-- LSP STUFF
M.LSP_progress = function()
	if not rawget(vim, "lsp") or vim.lsp.status or not is_activewin() then
		return ""
	end

	local Lsp = vim.lsp.util.get_progress_messages()[1]

	if vim.o.columns < 120 or not Lsp then
		return ""
	end

	if Lsp.done then
		vim.defer_fn(function()
			vim.cmd.redrawstatus()
		end, 1000)
	end

	local msg = Lsp.message or ""
	local percentage = Lsp.percentage or 0
	local title = Lsp.title or ""
	local spinners = { "", "󰪞", "󰪟", "󰪠", "󰪢", "󰪣", "󰪤", "󰪥" }
	local ms = vim.loop.hrtime() / 1000000
	local frame = math.floor(ms / 120) % #spinners
	local content = string.format(" %%<%s %s %s (%s%%%%) ", spinners[frame + 1], title, msg, percentage)

	-- if config.lsprogress_len then
	-- content = string.sub(content, 1, config.lsprogress_len)
	-- end

	return ("%#St_LspProgress#" .. content) or ""
end

M.LSP_Diagnostics = function()
	if not rawget(vim, "lsp") then
		return ""
	end

	local errors = #vim.diagnostic.get(stbufnr(), { severity = vim.diagnostic.severity.ERROR })
	local warnings = #vim.diagnostic.get(stbufnr(), { severity = vim.diagnostic.severity.WARN })
	local hints = #vim.diagnostic.get(stbufnr(), { severity = vim.diagnostic.severity.HINT })
	local info = #vim.diagnostic.get(stbufnr(), { severity = vim.diagnostic.severity.INFO })

	errors = (errors and errors > 0) and ("%#St_lspError#" .. " " .. errors .. " ") or ""
	warnings = (warnings and warnings > 0) and ("%#St_lspWarning#" .. "  " .. warnings .. " ") or ""
	hints = (hints and hints > 0) and ("%#St_lspHints#" .. "󰛩 " .. hints .. " ") or ""
	info = (info and info > 0) and ("%#St_lspInfo#" .. "󰋼 " .. info .. " ") or ""

	return errors .. warnings .. hints .. info
end

M.LSP_status = function()
	if rawget(vim, "lsp") then
		for _, client in ipairs(vim.lsp.get_active_clients()) do
			if client.attached_buffers[stbufnr()] and client.name ~= "none-ls" then
				return (vim.o.columns > 100 and "%#St_LspStatus#" .. "   LSP ~ " .. client.name .. " ")
					or "   LSP "
			end
		end
	end
end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		-- Get the value of g:coc_global_extensions
		-- local coc_global_extensions = vim.api.nvim_get_var('coc_global_extensions')

		-- Now you can use coc_global_extensions as needed
		--     require('lualine').setup {
		--   options = {
		--     theme = bubbles_theme,
		--     component_separators = '|',
		--     section_separators = { left = '', right = '' },
		--   },
		--   sections = {
		--     lualine_a = {
		--       { 'mode', separator = { left = '' }, right_padding = 2 },
		--     },
		--     lualine_b = { 'filename', 'branch' },
		--     lualine_c = { 'fileformat' },
		--     lualine_x = {},
		--     lualine_y = { 'filetype', 'progress' },
		--     lualine_z = {
		--       { 'location', separator = { right = '' }, left_padding = 2 },
		--     },
		--   },
		--   inactive_sections = {
		--     lualine_a = { 'filename' },
		--     lualine_b = {},
		--     lualine_c = {},
		--     lualine_x = {},
		--     lualine_y = {},
		--     lualine_z = { 'location' },
		--   },
		--   tabline = {},
		--   extensions = {},
		-- }
		-- Eviline config for lualine
		-- Author: shadmansaleh
		-- Credit: glepnir
		local lualine = require("lualine")

-- Color table for highlights
-- stylua: ignore
local colors = {
  bg       = '#202328',
  fg       = '#bbc2cf',
  yellow   = '#ECBE7B',
  cyan     = '#008080',
  darkblue = '#081633',
  green    = '#98be65',
  orange   = '#FF8800',
  violet   = '#a9a1e1',
  magenta  = '#c678dd',
  blue     = '#51afef',
  red      = '#ec5f67',
}

		local conditions = {
			buffer_not_empty = function()
				return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
			end,
			hide_in_width = function()
				return vim.fn.winwidth(0) > 80
			end,
			check_git_workspace = function()
				local filepath = vim.fn.expand("%:p:h")
				local gitdir = vim.fn.finddir(".git", filepath .. ";")
				return gitdir and #gitdir > 0 and #gitdir < #filepath
			end,
		}

		-- Config
		local config = {
			options = {
				-- Disable sections and component separators
				component_separators = "",
				section_separators = "",
				theme = {
					-- We are going to use lualine_c an lualine_x as left and
					-- right section. Both are highlighted by c theme .  So we
					-- are just setting default looks o statusline
					normal = { c = { fg = colors.fg, bg = colors.bg } },
					inactive = { c = { fg = colors.fg, bg = colors.bg } },
				},
			},
			sections = {
				-- these are to remove the defaults
				lualine_a = {},
				lualine_b = {},
				lualine_y = {},
				lualine_z = {},
				-- These will be filled later
				lualine_c = {},
				lualine_x = {},
			},
			inactive_sections = {
				-- these are to remove the defaults
				lualine_a = {},
				lualine_b = {},
				lualine_y = {},
				lualine_z = {},
				lualine_c = {},
				lualine_x = {},
			},
		}

		-- Inserts a component in lualine_c at left section
		local function ins_left(component)
			table.insert(config.sections.lualine_c, component)
		end

		-- Inserts a component in lualine_x at right section
		local function ins_right(component)
			table.insert(config.sections.lualine_x, component)
		end

		-- ins_left {
		--   function()
		--     return '▊'
		--   end,
		--   color = { fg = colors.blue }, -- Sets highlighting of component
		--   padding = { left = 0, right = 1 }, -- We don't need space before this
		-- }

		ins_left({
			-- mode component
			function()
				return ""
			end,
			color = function()
				-- auto change color according to neovims mode
				local mode_color = {
					n = colors.red,
					i = colors.green,
					v = colors.blue,
					[""] = colors.blue,
					V = colors.blue,
					c = colors.magenta,
					no = colors.red,
					s = colors.orange,
					S = colors.orange,
					[""] = colors.orange,
					ic = colors.yellow,
					R = colors.violet,
					Rv = colors.violet,
					cv = colors.red,
					ce = colors.red,
					r = colors.cyan,
					rm = colors.cyan,
					["r?"] = colors.cyan,
					["!"] = colors.red,
					t = colors.red,
				}
				return { fg = mode_color[vim.fn.mode()] }
			end,
			padding = { right = 1 },
		})

		ins_left({
			-- filesize component
			"filesize",
			cond = conditions.buffer_not_empty,
		})

		ins_left({
			"filename",
			cond = conditions.buffer_not_empty,
			color = { fg = colors.magenta, gui = "bold" },
		})

		ins_left({ "location" })

		ins_left({ "progress", color = { fg = colors.fg, gui = "bold" } })

		ins_left({
			"diagnostics",
			sources = { "nvim_diagnostic", "coc" },
			symbols = { error = " ", warn = " ", info = " " },
			diagnostics_color = {
				color_error = { fg = colors.red },
				color_warn = { fg = colors.yellow },
				color_info = { fg = colors.cyan },
			},
		})

		-- Insert mid section. You can make any number of sections in neovim :)
		-- for lualine it's any number greater then 2
		ins_left({
			function()
				return "%="
			end,
		})

		ins_left({
			-- Lsp server name .
			function()
				local msg = "No Active Lsp"
				local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
				local clients = vim.lsp.get_active_clients()
				if next(clients) == nil then
					return msg
				end
				for _, client in ipairs(clients) do
					local filetypes = client.config.filetypes
					if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
						return client.name
					end
				end
				return msg
			end,
			icon = " LSP:",
			color = { fg = "#ffffff", gui = "bold" },
		})
		-- ins_right({
		-- 	-- Lsp server name .
		-- 	function()
		-- 		local msg = "No Active Lsp"
		-- 		local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
		-- 		local clients = vim.lsp.get_active_clients()
		-- 		if next(clients) == nil then
		-- 			return msg
		-- 		end
		-- 		for _, client in ipairs(clients) do
		-- 			local filetypes = client.config.filetypes
		-- 			if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
		-- 				return client.name
		-- 			end
		-- 		end
		-- 		return msg
		-- 	end,
		-- 	icon = "  ",
		-- 	color = { fg = colors.base1, gui = "bold" },
		-- })
		-- ins_right({
		-- 	function()
		-- 		return M.LSP_progress()
		-- 	end,
		-- 	color = { fg = colors.base1, gui = "bold" },
		-- })
		-- ins_right({
		-- 	function()
		-- 		return M.LSP_Diagnostics()
		-- 	end,
		-- 	color = { fg = colors.base1, gui = "bold" },
		-- })
		-- ins_right({
		-- 	function()
		-- 		return M.LSP_status()
		-- 	end,
		-- 	color = { fg = colors.base1, gui = "bold" },
		-- })

		-- THIS added ugly emojis, so I removed it - not really nessesary anyway
		-- ins_right {
		--   -- Lsp server name .
		--   '%{coc#status()}',
		--   icon = '',
		--   color = { fg = colors.base1, gui = 'bold' },
		-- }

		-- Add components to right sections
		-- ins_right {
		--   'o:encoding', -- option component same as &encoding in viml
		--   fmt = string.upper, -- I'm not sure why it's upper case either ;)
		--   cond = conditions.hide_in_width,
		--   color = { fg = colors.green, gui = 'bold' },
		-- }
		--
		-- ins_right {
		--   'fileformat',
		--   fmt = string.upper,
		--   icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
		--   color = { fg = colors.green, gui = 'bold' },
		-- }
		--
		ins_right({
			"branch",
			icon = "",
			color = { fg = colors.violet, gui = "bold" },
		})

		ins_right({
			"diff",
			-- Is it me or the symbol for modified us really weird
			symbols = { added = " ", modified = "󰝤 ", removed = " " },
			diff_color = {
				added = { fg = colors.green },
				modified = { fg = colors.orange },
				removed = { fg = colors.red },
			},
			cond = conditions.hide_in_width,
		})

		-- ins_right {
		--   function()
		--     return '▊'
		--   end,
		--   color = { fg = colors.blue },
		--   padding = { left = 1 },
		-- }
		--
		-- Now don't forget to initialize lualine
		lualine.setup(config)
	end,
}
