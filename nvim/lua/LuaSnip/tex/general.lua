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

return {
  s(
    { trig = 'preamble', name = 'Preamble', dscr = 'Insert a basic Preamble for LaTeX documents' },
    fmta(
      [[
    \documentclass[a4paper,oneside,article,<>]{memoir}
    % remember to change language
    \input{../../<>-preamble.tex}
    \selectlanguage{<>}
    \title{<>}
    \author{Emil Beck Aagaard Korneliussen}
    \date{<>}

    \begin{document}
    \maketitle

    <>

    \end{document}
    ]],
      {
        i(1, 'english'),
        i(2, 'en'),
        rep(1),
        i(3, 'Document title'),
        i(4, '\\today'),
        i(0),
      }
    ),
    { condition = tex.in_preamble, show_condition = tex.in_preamble }
  ),
}
