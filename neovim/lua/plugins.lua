vim.cmd [[packadd packer.nvim]] -- Only required if you have packer configured as `opt`

return require('packer').startup(function(use)
	use 'wbthomason/packer.nvim' -- Packer can manage itself
	use 'norcalli/nvim-colorizer.lua'
	use 'akinsho/toggleterm.nvim'
end)
