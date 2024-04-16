require('rose-pine').setup({
    styles = {
        transparency = true,
    },
})


function ThemeSetup(color)
	color = color or "rose-pine" -- ensure default color when not provided by theme
	vim.cmd.colorscheme(color)

	-- remove colorsceme background
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

ThemeSetup()
