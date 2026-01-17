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
    local k = stripped:sub(j, j)
    if k == '(' then
      depth = depth + 1
    elseif k == ')' then
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
  context.snippetType = 'autosnippet'
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

--- Single math command snippets
local single_command_snippet = function(context, command, opts, ext)
  opts = opts or {}
  if not context.trig then
    error("context doesn't include a `trig` key which is mandatory", 2)
  end
  context.dscr = context.dscr or command
  context.name = context.name or context.dscr
  local docstring, offset, cnode, lnode
  if ext.choice == true then
    docstring = '[' .. [[(<1>)?]] .. ']' .. [[{]] .. [[<2>]] .. [[}]] .. [[<0>]]
    offset = 1
    cnode = c(1, { t '', sn(nil, { t '[', i(1, 'opt'), t ']' }) })
  else
    docstring = [[{]] .. [[<1>]] .. [[}]] .. [[<0>]]
  end
  if ext.label == true then
    docstring = [[{]] .. [[<1>]] .. [[}]] .. [[\label{(]] .. ext.short .. [[:<2>)?}]] .. [[<0>]]
    ext.short = ext.short or command
    lnode = c(2 + (offset or 0), {
      t '',
      sn(
        nil,
        fmta(
          [[
        \label{<>:<>}
        ]],
          { t(ext.short), i(1) }
        )
      ),
    })
  end
  context.docstring = context.docstring or (command .. docstring)
  local j, _ = string.find(command, context.trig)
  if j == 2 then
    context.trigEngine = 'ecma'
    context.trig = '(?<!\\\\)' .. '(' .. context.trig .. ')'
    context.hidden = true
  end
  -- stype = ext.stype or s
  return s(context, fmta(command .. [[<>{<>}<><>]], { cnode or t '', d(1 + (offset or 0), tex.get_visual), (lnode or t ''), i(0) }), opts)
end

--- Get capture function for subscript and superscript
local get_capture = function(_, snip, user_arg1, user_arg2, user_arg3)
  -- define arguments
  local idx = user_arg1 or 1
  return snip.captures[idx]
end

--- postfix helper function - generates dynamic node
local generate_postfix_dynamicnode = function(_, parent, _, user_arg1, user_arg2)
  local capture = parent.snippet.env.POSTFIX_MATCH
  if #capture > 0 then
    return sn(
      nil,
      fmta(
        [[
        <><><><>
        ]],
        { t(user_arg1), t(capture), t(user_arg2), i(0) }
      )
    )
  else
    local visual_placeholder = parent.snippet.env.LS_SELECT_RAW
    return sn(
      nil,
      fmta(
        [[
        <><><><>
        ]],
        { t(user_arg1), i(1, visual_placeholder), t(user_arg2), i(0) }
      )
    )
  end
end

--- Postfix math command snippets
local postfix_snippet = function(context, command, opts)
  opts = opts or {}
  if not context.trig then
    error("context doesn't include a `trig` key which is mandatory", 2)
  end
  if not context.trig then
    error("context doesn't include a `trig` key which is mandatory", 2)
  end
  context.dscr = context.dscr
  context.name = context.name or context.dscr
  context.docstring = command.pre .. [[(POSTFIX_MATCH|VISUAL|<1>)]] .. command.post
  context.match_pattern = [[[%w%.%_%-%"%']*$]]
  local j, _ = string.find(command.pre, context.trig)
  if j == 2 then
    context.trigEngine = 'ecma'
    context.trig = '(?<!\\\\)' .. '(' .. context.trig .. ')'
    context.hidden = true
  end
  return postfix(context, { d(1, generate_postfix_dynamicnode, {}, { user_args = { command.pre, command.post } }) }, opts)
end

M = {
  --- special superscripts
  s(
    { trig = 'sr', name = 'squared', desc = 'squared', wordTrig = false, snippetType = 'autosnippet' },
    { t '^2 ' },
    { condition = tex.in_math, show_condition = tex.in_math }
  ),
  s(
    { trig = 'rd', name = 'diff .. times', desc = 'differentiated .. times', wordTrig = false, snippetType = 'autosnippet' },
    fmta([[^{(<>)} <>]], { i(1), i(0) }),
    { condition = tex.in_math, show_condition = tex.in_math }
  ),
  s(
    { -- a1 -> a_1 or \alpha1 -> \alpha_1
      trig = [[(\\[a-zA-Z]+|[a-zA-Z]+|\)|\}|\])(\d)]],
      trigEngine = 'ecma',
      name = 'auto subscript',
      dscr = 'auto subscript (1 digits)',
      snippetType = 'autosnippet',
    },
    f(function(_, snip)
      local head, digits = snip.captures[1], snip.captures[2]
      return head .. '_' .. digits
    end, {}),
    { condition = tex.in_math, show_condition = tex.in_math }
  ),
  s(
    { -- a_11 -> a_{11} or \alpha_11 -> \alpha_{11}
      trig = [[(\\[a-zA-Z]+|[a-zA-Z]+|\)|\}|\])_(\d\d)]], -- ECMA regex: \w = [A-Za-z]
      trigEngine = 'ecma',
      name = 'auto subscript',
      dscr = 'auto subscript (2 digits)',
      snippetType = 'autosnippet',
    },
    f(function(_, snip)
      local head, digits = snip.captures[1], snip.captures[2]
      return head .. '_{' .. digits .. '}'
    end, {}),
    { condition = tex.in_math, show_condition = tex.in_math }
  ),

  --- Over and under set and brace
  s(
    { trig = 'over', name = 'overset', dscr = 'overset', snippetType = 'autosnippet' },
    fmta(
      [[
    \overset{<>}{<>} <>
    ]],
      { i(1, 'top'), i(2, 'bottom'), i(0) }
    ),
    { condition = tex.in_math, show_condition = tex.in_math }
  ),
  s(
    { trig = 'under', name = 'underset', dscr = 'underset', snippetType = 'autosnippet' },
    fmta(
      [[
    \underset{<>}{<>} <>
    ]],
      { i(1, 'bottom'), i(2, 'top'), i(0) }
    ),
    { condition = tex.in_math, show_condition = tex.in_math }
  ),
  s(
    { trig = 'obr', name = 'overbrace', dscr = 'overbrace', snippetType = 'autosnippet' },
    fmta(
      [[
    \overbrace{<>}^{<>} <>
    ]],
      { i(1), i(2, 'top'), i(0) }
    ),
    { condition = tex.in_math, show_condition = tex.in_math }
  ),
  s(
    { trig = 'ubr', name = 'underbrace', dscr = 'underbrace', snippetType = 'autosnippet' },
    fmta(
      [[
    \underbrace{<>}_{<>} <>
    ]],
      { i(1), i(2, 'bottom'), i(0) }
    ),
    { condition = tex.in_math, show_condition = tex.in_math }
  ),

  --- Fracitions
  s( --- basic fraction
    { trig = '//', name = 'fraction', dscr = 'fraction (general)', snippetType = 'autosnippet' },
    fmta(
      [[
    \frac{<>}{<>} <>
    ]],
      { d(1, tex.get_visual), i(2), i(0) }
    ),
    { condition = tex.in_math, show_condition = tex.in_math }
  ),
  s(
    {
      trig = [[\v((\d+)|(\d*)(\\)?(\w+)((\^|_)(\{\d+\}|\d))*)/]],
      name = 'fraction',
      dscr = 'auto fraction 1',
      trigEngine = 'vim', -- use Neovim regex engine (UTF-8 safe)
      snippetType = 'autosnippet',
    },
    fmta(
      [[
    \frac{<>}{<>} <>
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
    { trig = 'dint', name = 'definite integral', dscr = 'definite integral', snippetType = 'autosnippet', priority = 250 },
    fmta(
      [[
    \int_{<>}^{<>} <>
    ]],
      { i(1, 'a'), i(2, 'b'), i(0) }
    ),
    { condition = tex.in_math, show_condition = tex.in_math }
  ),
  s(
    { trig = 'nnn', name = 'big intersection', dscr = 'big intersection', snippetType = 'autosnippet' },
    fmta(
      [[
    \bigcap_{<>}^{<>} <>
    ]],
      { i(1, 'i=1'), i(2, '\\infty'), i(0) }
    ),
    { condition = tex.in_math, show_condition = tex.in_math }
  ),
  s(
    { trig = 'uuu', name = 'big union', dscr = 'big union', snippetType = 'autosnippet' },
    fmta(
      [[
    \bigcup_{<>}^{<>} <>
    ]],
      { i(1, 'i=1'), i(2, '\\infty'), i(0) }
    ),
    { condition = tex.in_math, show_condition = tex.in_math }
  ),
  s(
    { trig = 'pf', name = 'partial derivative', dscr = 'partial derivative', snippetType = 'autosnippet' },
    fmta(
      [[
    \frac{\partial <>}{\partial <>} <>
    ]],
      { i(1, 'f'), i(2, 'x'), i(0) }
    ),
    { condition = tex.in_math, show_condition = tex.in_math }
  ),
  s(
    { trig = 'set', name = 'set', dscr = 'set notation', snippetType = 'autosnippet' },
    fmta(
      [[
    \{ <> \}<>
    ]],
      { i(1), i(0) }
    ),
    { condition = tex.in_math, show_condition = tex.in_math }
  ),

  --- Special handling for conflicting symbols
}

--- Auto backslashes
local auto_backslash_specs = {
  'sin',
  'argsin',
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
  'triangle',
  'perp',
  'sup',
  'inf',
  'det',
  'max',
  'argmax',
  'argmin',
  'min',
  'deg',
  'angle',
  'int',
}

local auto_backslash_snippets = {}
for _, v in ipairs(auto_backslash_specs) do
  table.insert(auto_backslash_snippets, auto_backslash_snippet({ trig = v }, { condition = tex.in_math, show_condition = tex.in_math }))
end
vim.list_extend(M, auto_backslash_snippets)

local single_command_math_specs = {
  tt = {
    context = {
      name = 'text (math)',
      dscr = 'text in math mode',
    },
    command = [[\text]],
  },
  bm = {
    context = {
      name = 'bold math',
      dscr = 'bold math',
    },
    command = [[\bm]],
  },
  mth = {
    context = {
      name = 'mathrm',
      dscr = 'math roman (mathrm)',
    },
    command = [[\mathrm]],
  },
  ['__'] = {
    context = {
      name = 'subscript',
      dscr = 'auto subscript 3',
      wordTrig = false,
    },
    command = [[_]],
  },
  td = {
    context = {
      name = 'superscript',
      dscr = 'auto superscript alt',
      wordTrig = false,
    },
    command = [[^]],
  },
  sq = {
    context = {
      name = 'sqrt',
      dscr = 'square root (sqrt)',
      wordTrig = false,
    },
    command = [[\sqrt]],
  },
}

local single_command_math_snippets = {}
for k, v in pairs(single_command_math_specs) do
  table.insert(
    single_command_math_snippets,
    single_command_snippet(
      vim.tbl_deep_extend('keep', { trig = k, snippetType = 'autosnippet' }, v.context),
      v.command,
      { condition = tex.in_math, show_condition = tex.in_math },
      v.ext or {}
    )
  )
end
vim.list_extend(M, single_command_math_snippets)

local postfix_math_specs = {
  mbb = {
    context = {
      name = 'mathbb',
      dscr = 'math blackboard bold',
    },
    command = {
      pre = [[\mathbb{]],
      post = [[}]],
    },
  },
  mcal = {
    context = {
      name = 'mathcal',
      dscr = 'math calligraphic',
    },
    command = {
      pre = [[\mathcal{]],
      post = [[}]],
    },
  },
  mscr = {
    context = {
      name = 'mathscr',
      dscr = 'math script',
    },
    command = {
      pre = [[\mathscr{]],
      post = [[}]],
    },
  },
  mfr = {
    context = {
      name = 'mathfrak',
      dscr = 'mathfrak',
    },
    command = {
      pre = [[\mathfrak{]],
      post = [[}]],
    },
  },
  hat = {
    context = {
      name = 'hat',
      dscr = 'hat',
    },
    command = {
      pre = [[\hat{]],
      post = [[}]],
    },
  },
  bar = {
    context = {
      name = 'bar',
      dscr = 'bar (overline)',
    },
    command = {
      pre = [[\overline{]],
      post = [[}]],
    },
  },
  floor = {
    context = {
      name = 'floor',
      priority = 1000,
      dscr = 'floor',
    },
    command = {
      pre = [[\floor{]],
      post = [[}]],
    },
  },
  ceil = {
    context = {
      name = 'ceil',
      priority = 500,
      dscr = 'ceil',
    },
    command = {
      pre = [[\ceil{]],
      post = [[}]],
    },
  },
  tld = {
    context = {
      name = 'tilde',
      priority = 500,
      dscr = 'tilde',
    },
    command = {
      pre = [[\tilde{]],
      post = [[}]],
    },
  },
}

local postfix_math_snippets = {}
for k, v in pairs(postfix_math_specs) do
  table.insert(
    postfix_math_snippets,
    postfix_snippet(
      vim.tbl_deep_extend('keep', { trig = k, snippetType = 'autosnippet' }, v.context),
      v.command,
      { condition = tex.in_math, show_condition = tex.in_math }
    )
  )
end
vim.list_extend(M, postfix_math_snippets)

return M
