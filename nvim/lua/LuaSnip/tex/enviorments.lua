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
local events = require 'luasnip.util.events'
local ai = require 'luasnip.nodes.absolute_indexer'
local extras = require 'luasnip.extras'
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require('luasnip.extras.fmt').fmt
local fmta = require('luasnip.extras.fmt').fmta
local conds = require 'luasnip.extras.expand_conditions'
local postfix = require('luasnip.extras.postfix').postfix
local types = require 'luasnip.util.types'
local parse = require('luasnip.util.parser').parse_snippet
local ms = ls.multi_snippet

--- Environment condition and such

local tex = require 'LuaSnip.luasnip-tex-utils'
local make_condition = require('luasnip.extras.conditions').make_condition
local in_bullets = make_condition(tex.in_bullets)

-- Generating functions for Matrix
local generate_matrix = function(args, snip)
  local rows = tonumber(snip.captures[2])
  local cols = tonumber(snip.captures[3])
  local nodes = {}
  local ins_indx = 1
  for j = 1, rows do
    table.insert(nodes, r(ins_indx, tostring(j) .. 'x1', i(1)))
    ins_indx = ins_indx + 1
    for k = 2, cols do
      table.insert(nodes, t ' & ')
      table.insert(nodes, r(ins_indx, tostring(j) .. 'x' .. tostring(k), i(1)))
      ins_indx = ins_indx + 1
    end
    table.insert(nodes, t { '\\\\', '' })
  end
  -- fix last node.
  table.remove(nodes, #nodes)
  return sn(nil, nodes)
end

--  Generating function for Cases
local generate_cases = function(args, snip)
  local rows = tonumber(snip.captures[1]) or 2 -- default option 2 for cases
  local cols = 2 -- fix to 2 cols
  local nodes = {}
  local ins_indx = 1
  for j = 1, rows do
    table.insert(nodes, r(ins_indx, tostring(j) .. 'x1', i(1)))
    ins_indx = ins_indx + 1
    for k = 2, cols do
      table.insert(nodes, t ' & ')
      table.insert(nodes, r(ins_indx, tostring(j) .. 'x' .. tostring(k), i(1)))
      ins_indx = ins_indx + 1
    end
    table.insert(nodes, t { '\\\\', '' })
  end
  -- fix last node.
  table.remove(nodes, #nodes)
  return sn(nil, nodes)
end

return {
  s(
    { trig = 'beg', snippetType = 'autosnippet' },
    fmta(
      [[
      \begin{<>}
          <>
      \end{<>}
      <>
    ]],
      {
        i(1),
        i(2),
        rep(1),
        i(0),
      }
    ),
    { condition = tex.line_begin, show_condition = tex.show_line_begin }
  ),
  s(
    { trig = 'mk', snippetType = 'autosnippet', name = '$..$', dscr = 'inline math' },
    fmta(
      [[
    $<>$<>
    ]],
      { i(1), i(0) }
    )
  ),
  s(
    { trig = 'dm', snippetType = 'autosnippet', name = '\\[...\\]', dscr = 'display math' },
    fmta(
      [[ 
    \[ 
    <>
    .\]
    <>
    ]],
      { i(1), i(0) }
    ),
    { condition = tex.line_begin, show_condition = tex.show_line_begin }
  ),
  s(
    { trig = 'ali', snippetType = 'autosnippet', name = 'align', dscr = 'align math' },
    fmta(
      [[ 
    \begin{align*}
    <>
    .\end{align*}
    <>
    ]],
      { i(1), i(0) }
    ),
    { condition = tex.line_begin, show_condition = tex.show_line_begin }
  ),
  s(
    { trig = 'eq', snippetType = 'autosnippet', name = 'equation', dscr = 'equation environment' },
    fmta(
      [[
    \begin{equation*}
    <>
    \end{equation*}
    <>
    ]],
      { i(1), i(0) }
    ),
    { condition = tex.line_begin, show_condition = tex.show_line_begin }
  ),

  -- Matrices and Cases generating snippets
  s(
    { trig = '([bBpvV])mat(%d+)x(%d+)', name = '[bBpvV]matrix', dscr = 'matrices', regTrig = true, snippetType = 'autosnippet', hidden = true },
    fmta(
      [[
    \begin{<>}
    <>
    \end{<>}
    <>
    ]],
      {
        f(function(_, snip)
          return snip.captures[1] .. 'matrix'
        end),
        d(1, generate_matrix),
        f(function(_, snip)
          return snip.captures[1] .. 'matrix'
        end),
        i(0),
      }
    ),
    { condition = tex.in_math, show_condition = tex.in_math }
  ),
  s(
    { trig = '(%d?)case', name = 'cases', dscr = 'cases', regTrig = true, snippetType = 'autosnippet', hidden = true },
    fmta(
      [[
    \begin{cases}
    <>
    .\end{cases}
    <>
    ]],
      { d(1, generate_cases), i(0) }
    ),
    { condition = tex.in_math, show_condition = tex.in_math }
  ),

  -- Itemize / Enumerate environments
  s(
    { trig = 'item', name = 'itemize', dscr = 'bullet points (itemize)', snippetType = 'autosnippet' },
    fmta(
      [[ 
    \begin{itemize}
    \item <>
    \end{itemize}
    <>
    ]],
      { i(1), i(0) }
    ),
    { condition = tex.in_text and tex.line_begin, show_condition = tex.in_text and tex.show_line_begin }
  ),
  s(
    { trig = 'enum', name = 'enumerate', dscr = 'numbered list (enumerate)', snippetType = 'autosnippet' },
    fmta(
      [[ 
    \begin{enumerate}
    \item <>
    \end{enumerate}
    <>
    ]],
      { i(1), i(0) }
    ),
    { condition = tex.in_text and tex.line_begin, show_condition = tex.in_text and tex.show_line_begin }
  ),
  s(
    { trig = 'desc', name = 'description', dscr = 'description list (description)', snippetType = 'autosnippet' },
    fmta(
      [[ 
    \begin{description}
    \item[<>] <>
    \end{description}
    <>
    ]],
      { i(1), i(2), i(0) }
    ),
    { condition = tex.in_text and tex.line_begin, show_condition = tex.in_text and tex.show_line_begin }
  ),
  -- Generate new bullet points
  s(
    { trig = 'it', hidden = true, snippetType = 'autosnippet' },
    { t '\\item' },
    { condition = in_bullets * tex.line_begin, show_condition = in_bullets * tex.show_line_begin }
  ),
  s(
    { trig = 'id', name = 'bullet point', dscr = 'bullet point with custom text', snippetType = 'autosnippet' },
    fmta(
      [[ 
    \item [<>]<>
    ]],
      { i(1), i(0) }
    ),
    { condition = in_bullets * tex.line_begin, show_condition = in_bullets * tex.show_line_begin }
  ),
}
