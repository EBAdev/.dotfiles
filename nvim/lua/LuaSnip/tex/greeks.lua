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
  --- Greek letter snippets, autotriggered for efficiency,
  --- wordTrig allows for trigger within a word i.e. \d@a -> \d\alpha.
  s({ trig = '@a', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\alpha ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '@A', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\Alpha ',
  }, { condition = tex_utils.in_mathzone }),

  s({ trig = '@b', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\beta ',
  }, { condition = tex_utils.in_mathzone }),

  s({ trig = '@B', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\Beta ',
  }, { condition = tex_utils.in_mathzone }),

  s({ trig = '@g', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\gamma ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '@G', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\Gamma ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '@d', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\delta ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '@D', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\Delta ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '@l', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\lambda ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '@L', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\Lambda ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '@f', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\phi ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '@F', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\Phi ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '@p', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\pi ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '@P', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\Pi ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '@c', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\psi ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '@C', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\Psi ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '@s', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\sigma ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '@S', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\Sigma ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '@y', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\upsilon ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '@Y', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\Upsilon ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '@j', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\xi ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '@J', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\Xi ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '@o', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\omega ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '@O', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\Omega ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '@e', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\epsilon ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '@E', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\Epsilon ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '@z', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\zeta ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '@Z', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\Zeta ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '@h', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\eta ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '@H', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\Eta ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '@u', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\theta ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '@U', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\Theta ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '@i', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\iota ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '@I', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\Iota ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '@k', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\kappa ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '@K', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\Kappa ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '@m', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\mu ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '@M', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\Mu ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '@n', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\nu ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '@N', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\Nu ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '@r', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\rho ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '@R', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\Rho ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '@t', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\tau ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '@T', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\Tau ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '@x', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\chi ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = '@X', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\Chi ',
  }, { condition = tex_utils.in_mathzone }),
  s({ trig = 'nabl', wordTrig = false, snippetType = 'autosnippet' }, {
    t '\\nabla ',
  }, { condition = tex_utils.in_mathzone }),
}
