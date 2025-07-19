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
  s({ trig = '=>', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\implies',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '=<', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\impliedby',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = 'iff', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\iff',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '...', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\ldots',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '<=', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\le',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '>=', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\ge',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = 'AA', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\forall',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = 'EE', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\E',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = 'VV', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\V',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = 'NN', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\N',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = 'QQ', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\Q',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = 'RR', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\R',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = 'CC', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\C',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = 'ZZ', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\Z',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = 'PP', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\PP',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = 'xx', wordTrig = false, priority = 100, snippetType = 'autosnippet' }, {
    t '\\times',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = 'oxx', wordTrig = false, priority = 1000, snippetType = 'autosnippet' }, {
    t '\\otimes',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '**', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\cdot',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = 'max', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\max',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = 'min', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\min',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = 'dd', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\d',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = 'to', wordTrig = false, priority = 100, snippetType = 'autosnippet' }, {
    t '\\to',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = 'mto', wordTrig = false, priority = 1000, snippetType = 'autosnippet' }, {
    t '\\mapsto',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = 'inn', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\in',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = 'nii', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\ni',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '->', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\rightarrow',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '<-', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\leftarrow',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '<->', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\leftrightarrow',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '\\\\\\', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\setminus',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '<<', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\ll',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '>>', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\gg',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '||', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\mid',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = 'cc', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\subseteq',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = 'øø', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\emptyset',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = 'notin', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\not\\in',
  }, { condition = tex_utils.in_mathzone }),
}
