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
  s({ trig = '=>', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\implies',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = '=<', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\impliedby',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = 'iff', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\iff',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = '...', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\ldots',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = '<=', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\le',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = '>=', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\ge',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = 'AA', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\forall',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = 'EE', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\E',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = 'VV', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\V',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = 'NN', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\N',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = 'QQ', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\Q',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = 'RR', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\R',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = 'CC', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\C',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = 'ZZ', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\Z',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = 'PP', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\PP',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = 'xx', wordTrig = false, priority = 100, snippetType = 'autosnippet' }, {
    t '\\times',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = 'oxx', wordTrig = false, priority = 1000, snippetType = 'autosnippet' }, {
    t '\\otimes',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = '**', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\cdot',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = 'max', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\max',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = 'min', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\min',
  }, { condition = tex.in_math, show_condition = tex.in_math, priority = 100 }), -- Conflict with in
  s({ trig = 'dd', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\d',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = 'to', wordTrig = false, priority = 100, snippetType = 'autosnippet' }, {
    t '\\to',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = 'mto', wordTrig = false, priority = 1000, snippetType = 'autosnippet' }, {
    t '\\mapsto',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = 'in', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\in',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = 'ni', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\ni',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = '->', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\rightarrow',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = '<-', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\leftarrow',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = '<->', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\leftrightarrow',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = '\\\\\\', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\setminus',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = '<<', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\ll',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = '>>', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\gg',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = '||', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\mid',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = 'cc', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\subseteq',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = 'sub', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\subseteq',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = 'sup', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\supseteq',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = 'øø', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\emptyset',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = 'notin', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\not\\in',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = 'notni', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\not\\ni',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
}
