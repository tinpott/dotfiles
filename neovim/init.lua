vim.opt.wrap = false
vim.opt.cursorline = true
vim.opt.mouse = "n"
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"

-- line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- whitespace
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true

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

vim.g.markdown_recommended_style = 0

vim.api.nvim_create_autocmd({"InsertEnter"}, {
	pattern = "*",
	callback = function()
		vim.wo.relativenumber = false
		vim.wo.number = true
	end
})

vim.api.nvim_create_autocmd({"InsertLeave"}, {
	pattern = "*",
	callback = function()
		vim.wo.relativenumber = true
		vim.wo.number = true
	end
})

vim.lsp.enable("clangd")
vim.lsp.config.clangd = {
	cmd = {
		"clangd",
		"--clang-tidy",
		"--background-index",
		"--offset-encoding=utf-8",
	},
	root_markers = {
		".clangd",
		"compile_commands.json",
	},
	filetypes = {
		"c",
		"cpp",
		"cc",
	},
}


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

-- `opts = {}` for each plugin is equivalent to `setup({})`
require("lazy").setup({
	spec = {
		{
			"akinsho/toggleterm.nvim",
			version = "*",
			opts = {
				size = 20,
				open_mapping = [[<C-`>]],
				shell = vim.o.shell,
				autoscroll = true,
				direction = "horizontal",
				shade_terminals = true,
				shading_factor = "25"
			}
		},
		{
			"nvim-treesitter/nvim-treesitter",
			opts = {
				ensure_installed = {
					"bash", "gdscript", "lua", "python", "javascript",
					"c", "cpp",
					"csv", "diff", "markdown", "markdown_inline", "vim", "vimdoc",
				}
			}
		},
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
		},
		{
			"lewis6991/gitsigns.nvim",
			opts = {
				current_line_blame = true
			}
		},
		{
			"folke/todo-comments.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim"
			},
			opts = {
				signs = false
			}
		},
		{
			"nvim-neo-tree/neo-tree.nvim",
--			branch = "v3.x",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
				"MunifTanjim/nui.nvim",
--				{
--					"3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
--					opts = {
--					},
--				},
			},
			lazy = false,
			---@module "neo-tree"
			---@type neotree.Config?
			opts = {
				update_focused_file = {
					enable = true,
					update_cwd = true,
				},
			},
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
		{
			"catgoose/nvim-colorizer.lua",
			opts = {
				filetypes = { "*" },
				user_default_options = {
					RRGGBBAA = true,
				},
			},
		},
	},
	checker = {
		enabled = true, -- Automatically check for updates
		notify = false, -- But don't show the popup/notification
	},
})

vim.api.nvim_set_keymap("n", "<leader>m", ":RenderMarkdown toggle<CR>", { noremap = true, silent = true })

