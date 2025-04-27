
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file) -- append file to harpoon
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu) -- toggle harpoon menu

