local ls = require 'luasnip'
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local conds = require 'luasnip.extras.expand_conditions'

local tex = {}

tex.in_math = function() -- math context detection
  return vim.fn['vimtex#syntax#in_mathzone']() == 1
end

tex.in_comment = function() -- comment detection
  return vim.fn['vimtex#syntax#in_comment']() == 1
end

-- document class
tex.in_beamer = function()
  return vim.b.vimtex['documentclass'] == 'beamer'
end

tex.in_env = function(name) -- generic environment detection
  local is_inside = vim.fn['vimtex#env#is_inside'](name)
  return (is_inside[1] > 0 and is_inside[2] > 0)
end

tex.in_preamble = function()
  return not tex.in_env 'document'
end

tex.in_text = function()
  return not tex.in_math()
end

-- A few concrete environments---adapt as needed
tex.in_equation = function() -- equation environment detection
  return tex.in_env 'equation'
end

tex.in_bullets = function() -- itemize environment detection
  return tex.in_env 'itemize' or tex.in_env 'enumerate' or tex.in_env 'description'
end

tex.in_align = function()
  return tex.in_env 'align' or tex.in_env 'align*' or tex.in_env 'aligned'
end

tex.in_tikz = function() -- TikZ picture environment detection
  return tex.in_env 'tikzpicture'
end

tex.show_line_begin = function(line_to_cursor) -- Show snippet only if the cursor is within 3 lines of the beginning of the line
  return #line_to_cursor <= 3
end

tex.line_begin = conds.line_begin

tex.get_visual = function(args, parent) -- Get the selected text in visual mode
  if #parent.snippet.env.LS_SELECT_RAW > 0 then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else -- If LS_SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end

return tex
