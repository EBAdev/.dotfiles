-- Don't let auto-save.nvim perform the save — we handle saving ourselves
require("auto-save").setup({
 -- start auto-save when the plugin is loaded (i.e. when your package manager loads it)
 enabled = true, 
    execution_message = {
    -- message to print on save
		message = function() 
			return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
		end,
    -- dim the color of `message`
		dim = 0.18, 
    -- (milliseconds) automatically clean MsgArea after displaying `message`. See :h MsgArea
		cleaning_interval = 1000, 
	},
  -- vim events that trigger auto-save. See :h events
    trigger_events = {"InsertLeave", "TextChanged"}, 
	-- function that determines whether to save the current buffer or not
  --
	-- return true: if buffer is ok to be saved
	-- return false: if it's not ok to be saved
	condition = function(buf)
		local fn = vim.fn
		local utils = require("auto-save.utils.data")

		if
			fn.getbufvar(buf, "&modifiable") == 1 and
			utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
			return true -- met condition(s), can save
		end
		return false -- can't save
	end,
  write_all_buffers = false, -- write all buffers when the current one meets `condition`
  debounce_delay = 500, -- saves the file at most every `debounce_delay` milliseconds
	callbacks = { -- functions to be executed at different intervals
		enabling = nil, -- ran when enabling auto-save
		disabling = nil, -- ran when disabling auto-save
		before_asserting_save = nil, -- ran before checking `condition`
		before_saving = nil, -- ran before doing the actual save
		after_saving = nil -- ran after doing the actual save
	}
})
