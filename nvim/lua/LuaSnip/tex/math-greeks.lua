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
  --- Greek letter snippets, autotriggered for efficiency,
  --- wordTrig allows for trigger within a word i.e. \d@a -> \d\alpha.
  s({ trig = '@a', wordTrig = false, snippetType = 'autosnippet', name = 'α', dscr = 'alpha' }, {
    t '\\alpha',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = '@A', wordTrig = false, snippetType = 'autosnippet', name = 'Α', dscr = 'Alpha' }, {
    t '\\Alpha',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = '@b', wordTrig = false, snippetType = 'autosnippet', name = 'β', dscr = 'beta' }, {
    t '\\beta',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
  s({ trig = '@B', wordTrig = false, snippetType = 'autosnippet', name = 'Β', dscr = 'Beta' }, {
    t '\\Beta',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = '@g', wordTrig = false, snippetType = 'autosnippet', name = 'γ', dscr = 'gamma' }, {
    t '\\gamma',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = '@G', wordTrig = false, snippetType = 'autosnippet', name = 'Γ', dscr = 'Gamma' }, {
    t '\\Gamma',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = '@d', wordTrig = false, snippetType = 'autosnippet', name = 'δ', dscr = 'delta' }, {
    t '\\delta',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = '@D', wordTrig = false, snippetType = 'autosnippet', name = 'Δ', dscr = 'Delta' }, {
    t '\\Delta',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = '@l', wordTrig = false, snippetType = 'autosnippet', name = 'λ', dscr = 'lambda' }, {
    t '\\lambda',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = '@L', wordTrig = false, snippetType = 'autosnippet', name = 'Λ', dscr = 'Lambda' }, {
    t '\\Lambda',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = '@f', wordTrig = false, snippetType = 'autosnippet', name = 'φ', dscr = 'phi' }, {
    t '\\phi',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = '@F', wordTrig = false, snippetType = 'autosnippet', name = 'Φ', dscr = 'Phi' }, {
    t '\\Phi',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = '@p', wordTrig = false, snippetType = 'autosnippet', name = 'π', dscr = 'pi' }, {
    t '\\pi',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = '@P', wordTrig = false, snippetType = 'autosnippet', name = 'Π', dscr = 'Pi' }, {
    t '\\Pi',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = '@c', wordTrig = false, snippetType = 'autosnippet', name = 'ψ', dscr = 'psi' }, {
    t '\\psi',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = '@C', wordTrig = false, snippetType = 'autosnippet', name = 'Ψ', dscr = 'Psi' }, {
    t '\\Psi',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = '@s', wordTrig = false, snippetType = 'autosnippet', name = 'σ', dscr = 'sigma' }, {
    t '\\sigma',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = '@S', wordTrig = false, snippetType = 'autosnippet', name = 'Σ', dscr = 'Sigma' }, {
    t '\\Sigma',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = '@y', wordTrig = false, snippetType = 'autosnippet', name = 'υ', dscr = 'upsilon' }, {
    t '\\upsilon',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = '@Y', wordTrig = false, snippetType = 'autosnippet', name = 'Υ', dscr = 'Upsilon' }, {
    t '\\Upsilon',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = '@j', wordTrig = false, snippetType = 'autosnippet', name = 'ξ', dscr = 'xi' }, {
    t '\\xi',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = '@J', wordTrig = false, snippetType = 'autosnippet', name = 'Ξ', dscr = 'Xi' }, {
    t '\\Xi',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = '@o', wordTrig = false, snippetType = 'autosnippet', name = 'ω', dscr = 'omega' }, {
    t '\\omega',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = '@O', wordTrig = false, snippetType = 'autosnippet', name = 'Ω', dscr = 'Omega' }, {
    t '\\Omega',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = '@e', wordTrig = false, snippetType = 'autosnippet', name = 'ε', dscr = 'epsilon' }, {
    t '\\epsilon',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = '@E', wordTrig = false, snippetType = 'autosnippet', name = 'ϵ', dscr = 'Epsilon' }, {
    t '\\Epsilon',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = '@z', wordTrig = false, snippetType = 'autosnippet', name = 'ζ', dscr = 'zeta' }, {
    t '\\zeta',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = '@Z', wordTrig = false, snippetType = 'autosnippet', name = 'Ζ', dscr = 'Zeta' }, {
    t '\\Zeta',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = '@h', wordTrig = false, snippetType = 'autosnippet', name = 'η', dscr = 'eta' }, {
    t '\\eta',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = '@H', wordTrig = false, snippetType = 'autosnippet', name = 'Η', dscr = 'Eta' }, {
    t '\\Eta',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = '@u', wordTrig = false, snippetType = 'autosnippet', name = 'θ', dscr = 'theta' }, {
    t '\\theta',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = '@U', wordTrig = false, snippetType = 'autosnippet', name = 'Θ', dscr = 'Theta' }, {
    t '\\Theta',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = '@i', wordTrig = false, snippetType = 'autosnippet', name = 'ι', dscr = 'iota' }, {
    t '\\iota',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = '@I', wordTrig = false, snippetType = 'autosnippet', name = 'Ι', dscr = 'Iota' }, {
    t '\\Iota',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = '@k', wordTrig = false, snippetType = 'autosnippet', name = 'κ', dscr = 'kappa' }, {
    t '\\kappa',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = '@K', wordTrig = false, snippetType = 'autosnippet', name = 'Κ', dscr = 'Kappa' }, {
    t '\\Kappa',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = '@m', wordTrig = false, snippetType = 'autosnippet', name = 'μ', dscr = 'mu' }, {
    t '\\mu',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = '@M', wordTrig = false, snippetType = 'autosnippet', name = 'Μ', dscr = 'Mu' }, {
    t '\\Mu',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = '@n', wordTrig = false, snippetType = 'autosnippet', name = 'ν', dscr = 'nu' }, {
    t '\\nu',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = '@N', wordTrig = false, snippetType = 'autosnippet', name = 'Ν', dscr = 'Nu' }, {
    t '\\Nu',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = '@r', wordTrig = false, snippetType = 'autosnippet', name = 'ρ', dscr = 'rho' }, {
    t '\\rho',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = '@R', wordTrig = false, snippetType = 'autosnippet', name = 'Ρ', dscr = 'Rho' }, {
    t '\\Rho',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = '@t', wordTrig = false, snippetType = 'autosnippet', name = 'τ', dscr = 'tau' }, {
    t '\\tau',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = '@T', wordTrig = false, snippetType = 'autosnippet', name = 'Τ', dscr = 'Tau' }, {
    t '\\Tau',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = '@x', wordTrig = false, snippetType = 'autosnippet', name = 'χ', dscr = 'chi' }, {
    t '\\chi',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = '@X', wordTrig = false, snippetType = 'autosnippet', name = 'Χ', dscr = 'Chi' }, {
    t '\\Chi',
  }, { condition = tex.in_math, show_condition = tex.in_math }),

  s({ trig = 'nab', wordTrig = false, snippetType = 'autosnippet', name = '∇', dscr = 'nabla' }, {
    t '\\nabla',
  }, { condition = tex.in_math, show_condition = tex.in_math }),
}
