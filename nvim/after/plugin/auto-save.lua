require("auto-save").setup({
  enabled = true,
  execution_message = "AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"),
  events = { "InsertLeave" },  -- Trigger on InsertLeave
  condition = function(buf)
    local timer = vim.b.auto_save_timer
    if timer then
      timer:stop()
      timer:close()
    end

    local new_timer = vim.loop.new_timer()
    vim.b.auto_save_timer = new_timer

    new_timer:start(2000, 0, vim.schedule_wrap(function()
      -- If user is still in Normal mode after 2 seconds, save
      if vim.api.nvim_get_mode().mode == "n" then
        vim.cmd("silent! write")
      end
    end))

    -- Prevent auto-save from happening immediately
    return false
  end,
})

