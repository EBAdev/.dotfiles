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
  s({ trig = '()', wordTrig = false, snippetType = 'autosnippet', name = '()', desc = 'left right parenthesis' }, {
    t '\\left( ',
    d(1, tex.get_visual),
    t ' \\right)',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = '[]', wordTrig = false, snippetType = 'autosnippet', name = '[]', dscr = 'left rigth bracket' }, {
    t '\\left[ ',
    d(1, tex.get_visual),
    t ' \\right]',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = '{}', wordTrig = false, snippetType = 'autosnippet', name = '{}', dscr = 'left rigth curly bracket' }, {
    t '\\left\\{ ',
    d(1, tex.get_visual),
    t ' \\right\\}',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = '<>', wordTrig = false, snippetType = 'autosnippet', name = '<>', dscr = 'left right angle' }, {
    t '\\left\\langle ',
    d(1, tex.get_visual),
    t ' \\right\\rangle',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = 'abs', wordTrig = false, snippetType = 'autosnippet', name = '||', dscr = 'left right mid (abs)' }, {
    t '\\left| ',
    d(1, tex.get_visual),
    t ' \\right|',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = 'nrm', wordTrig = false, snippetType = 'autosnippet', name = '|| ||', dscr = 'left right double mid (norm)' }, {
    t '\\left\\| ',
    d(1, tex.get_visual),
    t ' \\right\\|',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
}
