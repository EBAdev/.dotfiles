
--- Telescope ignore patterns (lua patterns not RegEx)
local telescope_ignore_patterns = {
	"%.aux",
	"%.pdf",
	"%.png",
	"%.DS_Store",
	"%.log",
	"%.fls",
	"%.bls",
	"%.xml",
	"%.out",
	"%.lox",
	"%.bbl",
	"%.bcf",
	"%.blg",
	"%.toc",
	"%.gz",
	"%.fdb_latexmk",
	"%.synctex"
}

--- add ignore list to telescope
require("telescope.config").set_defaults({
	file_ignore_patterns = telescope_ignore_patterns,
})


--- toggle ignore patterns from telescope
vim.keymap.set("n", "<leader>ti", function()
	vim.g.telescope_ignore_enabled = not vim.g.telescope_ignore_enabled

	require("telescope.config").set_defaults({
		file_ignore_patterns = vim.g.telescope_ignore_enabled and telescope_ignore_patterns or {},
	})
end, { noremap = true, desc = "Toggle telescope ignore patterns" })



local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>pf', builtin.find_files, {}) -- fuzzyfind all files
vim.keymap.set('n', '<C-p>', builtin.git_files, {}) -- fuzzyfind git files only
vim.keymap.set('n', '<leader>ps', function() -- grep search
	builtin.grep_string({search = vim.fn.input("Grep Search > ")});
end)

