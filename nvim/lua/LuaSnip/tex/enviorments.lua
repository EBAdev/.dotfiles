local ls = require 'luasnip'
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require('luasnip.extras.fmt').fmt
local fmta = require('luasnip.extras.fmt').fmta
local rep = require('luasnip.extras').rep

--- Environment condition and such

local tex_utils = require 'LuaSnip.luasnip-utils'

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
    { condition = tex_utils.line_begin }
  ),
  s(
    { trig = 'h1', dscr = 'Top-level section' },
    fmta([[\section{<>}]], { i(1) }),
    { condition = tex_utils.line_begin } -- set condition in the `opts` table
  ),
}
