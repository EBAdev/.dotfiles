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

--- fractions (parentheses case)
local generate_fraction = function(_, snip)
  local stripped = snip.captures[1]
  local depth = 0
  local j = #stripped
  while true do
    local c = stripped:sub(j, j)
    if c == '(' then
      depth = depth + 1
    elseif c == ')' then
      depth = depth - 1
    end
    if depth == 0 then
      break
    end
    j = j - 1
  end
  return sn(
    nil,
    fmta(
      [[
        <>\frac{<>}{<>}
        ]],
      { t(stripped:sub(1, j - 1)), t(stripped:sub(j + 1, -2)), i(1) }
    )
  )
end

--- Auto Backslash math commands
local auto_backslash_snippet = function(context, opts)
  opts = opts or {}
  if not context.trig then
    error("context doesn't include a `trig` key which is mandatory", 2)
  end
  context.dscr = context.dscr or (context.trig .. 'with automatic backslash')
  context.name = context.name or context.trig
  context.docstring = context.docstring or ([[\]] .. context.trig)
  context.trigEngine = 'ecma'
  context.trig = '(?<!\\\\)' .. '(' .. context.trig .. ')'
  context.SnippetType = 'autosnippet'
  return s(
    context,
    fmta(
      [[
    \<><>
    ]],
      { f(function(_, snip)
        return snip.captures[1]
      end), i(0) }
    ),
    opts
  )
end

M = {
  --- special superscripts
  s({ trig = 'sr', wordTrig = false, snippetType = 'autosnippet' }, { t '^2' }, { condition = tex.in_math, show_condition = tex.in_math }),

  --- Fracitions
  s( --- basic fraction
    { trig = '//', name = 'fraction', dscr = 'fraction (general)', snippetType = 'autosnippet' },
    fmta(
      [[
    \frac{<>}{<>}<>
    ]],
      { d(1, tex.get_visual), i(2), i(0) }
    ),
    { condition = tex.in_math, show_condition = tex.in_math }
  ),
  s( --- auto fraction between numbers and letters
    {
      trig = '((\\d+)|(\\d*)(\\\\)?([A-Za-z]+)((\\^|_)(\\{\\d+\\}|\\d))*)\\/',
      name = 'fraction',
      dscr = 'auto fraction 1',
      trigEngine = 'ecma',
      snippetType = 'autosnippet',
    },
    fmta(
      [[
    \frac{<>}{<>}<>
    ]],
      { f(function(_, snip)
        return snip.captures[1]
      end), i(1), i(0) }
    ),
    { condition = tex.in_math, show_condition = tex.in_math }
  ),
  s( --- auto fraction with parentheses
    { trig = '(^.*\\))/', name = 'fraction', dscr = 'auto fraction 2', trigEngine = 'ecma', snippetType = 'autosnippet' },
    { d(1, generate_fraction) },
    { condition = tex.in_math, show_condition = tex.in_math }
  ),

  --- Limits
  s(
    { trig = 'limr', name = 'limit', dscr = 'limit', snippetType = 'autosnippet' },
    fmta(
      [[
    \lim_{<> \to <>} <>
    ]],
      { i(1, 'n'), i(2, '\\infty'), i(0) }
    ),
    { condition = tex.in_math, show_condition = tex.in_math }
  ),
  s(
    { trig = 'limi', name = 'limes inferior', dscr = 'limes inferior', snippetType = 'autosnippet' },
    fmta(
      [[
    \liminf_{<> \to <>} <>  
    ]],
      { i(1, 'n'), i(2, '\\infty'), i(0) }
    ),
    { condition = tex.in_math, show_condition = tex.in_math }
  ),
  s(
    { trig = 'lims', name = 'limes superior', dscr = 'limes superior', snippetType = 'autosnippet' },
    fmta(
      [[
    \limsup_{<> \to <>} <>  
    ]],
      { i(1, 'n'), i(2, '\\infty'), i(0) }
    ),
    { condition = tex.in_math, show_condition = tex.in_math }
  ),

  --- Operators
  s(
    { trig = 'sum', name = 'summation', dscr = 'summation', snippetType = 'autosnippet' },
    fmta(
      [[
    \sum_{<>}^{<>} <>
    ]],
      { i(1, 'i=1'), i(2, '\\infty'), i(0) }
    ),
    { condition = tex.in_math, show_condition = tex.in_math }
  ),
  s(
    { trig = 'prod', name = 'product', dscr = 'product', snippetType = 'autosnippet' },
    fmta(
      [[
    \prod_{<>}^{<>} <>
    ]],
      { i(1, 'i=1'), i(2, '\\infty'), i(0) }
    ),
    { condition = tex.in_math, show_condition = tex.in_math }
  ),
  s(
    { trig = 'dint', name = 'integral', dscr = 'integral', snippetType = 'autosnippet' },
    fmta(
      [[
    \int_{<>}^{<>} <>
    ]],
      { i(1, 'a'), i(2, 'b'), i(0) }
    ),
    { condition = tex.in_math, show_condition = tex.in_math }
  ),
  s(
    { trig = 'nnn', name = 'Big intersection', dscr = 'Big intersection', snippetType = 'autosnippet' },
    fmta(
      [[
    \bigcap_{<>}^{<>} <>
    ]],
      { i(1, 'i=1'), i(2, '\\infty'), i(0) }
    ),
    { condition = tex.in_math, show_condition = tex.in_math }
  ),
  s(
    { trig = 'uuu', name = 'Big union', dscr = 'Big union', snippetType = 'autosnippet' },
    fmta(
      [[
    \bigcup_{<>}^{<>} <>
    ]],
      { i(1, 'i=1'), i(2, '\\infty'), i(0) }
    ),
    { condition = tex.in_math, show_condition = tex.in_math }
  ),
  s(
    { trig = 'pd', name = 'partial derivative', dscr = 'partial derivative', snippetType = 'autosnippet' },
    fmta(
      [[
    \frac{\partial <>}{\partial <>} <>
    ]],
      { i(1, 'f'), i(2, 'x'), i(0) }
    ),
    { condition = tex.in_math, show_condition = tex.in_math }
  ),
}

--- Auto backslashes
local auto_backslash_specs = {
  'arcsin',
  'sin',
  'arccos',
  'cos',
  'arctan',
  'tan',
  'cot',
  'csc',
  'sec',
  'log',
  'ln',
  'exp',
  'ast',
  'star',
  'perp',
  'sup',
  'inf',
  'det',
  'max',
  'min',
  'argmax',
  'argmin',
  'deg',
  'angle',
}

local auto_backslash_snippets = {}
for _, v in ipairs(auto_backslash_specs) do
  table.insert(auto_backslash_snippets, auto_backslash_snippet({ trig = v }, { condition = tex.in_math, show_condition = tex.in_math }))
end
vim.list_extend(M, auto_backslash_snippets)

return M
