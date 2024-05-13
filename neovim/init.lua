require("plugins")

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.wrap = true
vim.opt.cursorline = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true

vim.opt.mouse = "n"

vim.opt.termguicolors = true

local packer = require("packer")
--packer.sync()

local colorizer = require("colorizer")
colorizer.setup()
--colorizer.setup{
--	filetypes = { "*" },
--	user_default_options = {
--		rgb_fn = true
--	},
--	buftypes = {}
--}
