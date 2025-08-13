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

--- Single command snippets with optional label and choice
local scsn = function(context, command, opts, ext)
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
      sn(
        nil,
        fmta(
          [[
        <>
        \label{<>:<>}
        <>
        ]],
          { t '', t(ext.short), i(1), i(0) }
        )
      ),
      t '',
    })
  end
  -- Set the context to hidden if it is not already set
  context.hidden = context.hidden or true

  -- If the command is a trigger, we need to add a negative lookbehind
  context.docstring = context.docstring or (command .. docstring)
  local j, _ = string.find(command, context.trig)
  if j == 2 then
    context.trigEngine = 'ecma'
    context.trig = '(?<!\\\\)' .. '(' .. context.trig .. ')'
  end
  -- stype = ext.stype or s
  return s(context, fmta(command .. [[<>{<>}<><>]], { cnode or t '', d(1 + (offset or 0), tex.get_visual), (lnode or t ''), i(0) }), opts)
end

local reference_snippet_table = {
  a = 'auto',
  c = 'c',
  C = 'C',
  e = 'eq',
  r = '',
}

--- Custom command snippets
M = {
  s(
    { trig = 'lab', name = 'label', dscr = 'Add a label', snippetType = 'autosnippet' },
    fmta(
      [[
    \label{<>:<>}
    <>
    ]],
      { i(1), i(2), i(0) }
    )
  ),
  s(
    {
      trig = '([cC])ref',
      name = '(cC)?ref',
      dscr = 'add a reference (with cref, Cref)',
      trigEngine = 'pattern',
      hidden = true,
      snippetType = 'autosnippet',
    },
    fmta(
      [[
    \<>ref{<>:<>}<>
    ]],
      { f(function(_, snip)
        return reference_snippet_table[snip.captures[1]]
      end), i(1), i(2), i(0) }
    ),
    { condition = tex.in_text, show_condition = tex.in_text }
  ),
  s(
    { trig = 'href', name = 'href', dscr = 'add a hyperlink', snippetType = 'autosnippet', hidden = true },
    fmta(
      [[
    \href{<>}{<>}<>
    ]],
      { i(1, 'url'), i(2, 'text'), i(0) }
    ),
    { condition = tex.in_text, show_condition = tex.in_text }
  ),
}

--- Single Command Snippets
local single_command_specs = {
  chap = {
    context = {
      name = 'chapter',
      dscr = 'add a chapter',
      priority = 100,
    },
    command = [[\chapter]],
    ext = { label = true, short = 'ch' },
  },
  sec = {
    context = {
      name = 'section',
      dscr = 'add a section',
      priority = 250,
    },
    command = [[\section]],
    ext = { label = true, short = 'sec' },
  },
  ssec = {
    context = {
      name = 'subsection',
      dscr = 'add a subsection',
      priority = 500,
    },
    command = [[\subsection]],
    ext = { label = true, short = 'ssec' },
  },
  sssec = {
    context = {
      name = 'subsubsection',
      dscr = 'add a subsubsection',
    },
    command = [[\subsubsection]],
    ext = { label = false, short = 'sssec' },
  },
  bf = {
    context = {
      name = 'textbf',
      dscr = 'bold text',
    },
    command = [[\textbf]],
  },
  it = {
    context = {
      name = 'textit',
      dscr = 'italic text',
    },
    command = [[\textit]],
  },
  ttt = {
    context = {
      name = 'texttt',
      dscr = 'monospace text',
    },
    command = [[\texttt]],
  },
  sc = {
    context = {
      name = 'textsc',
      dscr = 'small caps text',
    },
    command = [[\textsc]],
  },
  tu = {
    context = {
      name = 'underline',
      dscr = 'underlined text in non-math mode',
    },
    command = [[\underline]],
  },
  tov = {
    context = {
      name = 'overline',
      dscr = 'overline text in non-math mode',
    },
    command = [[\overline]],
  },
  cite = {
    context = {
      name = 'citation',
      dscr = 'add a bibtex citation',
      snippetType = 'autosnippet',
    },
    command = [[\cite]],
  },
  pcite = {
    context = {
      name = 'parenthsis citation',
      dscr = 'add a bibtex parenthesis citation ',
      snippetType = 'autosnippet',
      priority = 100,
    },
    command = [[\parencite]],
  },
  inp = {
    context = {
      name = 'input',
      dscr = 'input a tex file',
      snippetType = 'autosnippet',
    },
    command = [[\input]],
  },
  inc = {
    context = {
      name = 'include',
      dscr = 'include a tex file',
      snippetType = 'autosnippet',
    },
    command = [[\include]],
  },
}

local single_command_snippets = {}
for k, v in pairs(single_command_specs) do
  table.insert(
    single_command_snippets,
    scsn(vim.tbl_deep_extend('keep', { trig = k }, v.context), v.command, v.opt or { condition = tex.in_text, show_condition = tex.in_text }, v.ext or {})
  )
end
vim.list_extend(M, single_command_snippets)

return M
