vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.wrap = false
vim.opt.cursorline = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true

vim.opt.mouse = "n"

vim.opt.termguicolors = true

local space = "·"
vim.opt.listchars = {
	-- whitespace
	trail = space,
	lead = space,
	multispace = space,
	tab = "» ",
	nbsp = "␣",

	-- wrap
	extends = "❱",
	precedes = "❰",
}
vim.opt.list = true


--
-- plugins with lazy.nvim
--

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
--		{
--			"akinsho/toggleterm.nvim",
--			version = "*",
--			opts = {
--				size = 20,
--				open_mapping = [[<c-`>]],
--				shell = vim.o.shell,
--				autoscroll = true,
--				direction = "horizontal",
--				shade_terminals = true,
--				shading_factor = "25"
--			}
--		},
		{
			"MeanderingProgrammer/render-markdown.nvim",
--			dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
--			dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" }, -- if you use standalone mini plugins
--			dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
			---@module "render-markdown"
			---@type render.md.UserConfig
			opts = {},
		},
		{
			"windwp/nvim-autopairs",
			event = "InsertEnter",
			config = true
			-- use opts = {} for passing setup options
			-- this is equivalent to setup({}) function
		},

		-- color scheme <https://www.lazyvim.org/plugins/colorscheme>
		{
			"loctvl842/monokai-pro.nvim",
			priority = 1000,
			config = function()
				vim.cmd([[colorscheme monokai-pro]])
			end,
			opts = {
				filter = "spectrum"
			}
		},
	},
	checker = { enabled = true }, -- automatically check for updates
})

--require("render-markdown").

