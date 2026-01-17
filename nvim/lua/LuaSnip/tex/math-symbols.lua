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

local symbol_snippet = function(context, command, opts)
  opts = opts or {}
  if not context.trig then
    error("context doesn't include a `trig` key which is mandatory", 2)
  end
  context.dscr = context.dscr or command
  context.name = context.name or command:gsub([[\]], '')
  context.docstring = context.docstring or (command .. [[{0}]])
  context.wordTrig = context.wordTrig or false
  context.snippetType = context.snippetType or 'autosnippet'
  local j, _ = string.find(command, context.trig)
  if j == 2 then -- command always starts with backslash
    context.trigEngine = 'ecma'
    context.trig = '(?<!\\\\)' .. '(' .. context.trig .. ')'
    context.hidden = true
  end
  return s(context, t(command), opts)
end

M = { -- Custom snippets
  s(
    { trig = '==', snippetType = 'autosnippet', name = '&=', dscr = 'aligned equality' },
    fmta(
      [[
    &=<> \\ <>
    ]],
      { i(1), i(0) }
    ),
    { condition = tex.in_align, show_condition = tex.in_align }
  ),
}

local symbol_specs = {
  ---  Arrows
  ['=>'] = { context = { name = '⇒' }, command = [[\implies ]] },
  ['=<'] = { context = { name = '⇐' }, command = [[\impliedby ]] },
  iff = { context = { name = '⟺' }, command = [[\iff ]] },
  ['->'] = { context = { name = '→', priority = 250 }, command = [[\to ]] },
  too = { context = { name = '→', priority = 250 }, command = [[\to ]] },
  ['!>'] = { context = { name = '↦' }, command = [[\mapsto ]] },
  mto = { context = { name = '↦', priority = 500 }, command = [[\mapsto ]] },
  ['<-'] = { context = { name = '↦', priority = 250 }, command = [[\leftarrow ]] },
  ['-->'] = { context = { name = '⟶', priority = 500 }, command = [[\longrightarrow ]] },
  ['<--'] = { context = { name = '⟶', priority = 500 }, command = [[\longrightarrow ]] },
  ['<->'] = { context = { name = '↔', priority = 500 }, command = [[\leftrightarrow ]] },
  uar = { context = { name = '↑' }, command = [[\uparrow ]] },
  dar = { context = { name = '↓' }, command = [[\downarrow ]] },

  --- Math operators
  AA = { context = { name = '∀' }, command = [[\forall ]] },
  exi = { context = { name = '∃' }, command = [[\exists ]] },
  ['!='] = { context = { name = '!=' }, command = [[\neq ]] },
  ['<='] = { context = { name = '≤' }, command = [[\le ]] },
  ['>='] = { context = { name = '≥' }, command = [[\ge ]] },
  ['<<'] = { context = { name = '<<' }, command = [[\ll ]] },
  ['>>'] = { context = { name = '>>' }, command = [[\gg ]] },
  sim = { context = { name = '~' }, command = [[\sim ]] },
  app = { context = { name = '≈' }, command = [[\approx ]] },
  eqv = { context = { name = '≡' }, command = [[\equiv ]] },
  ['**'] = { context = { name = '·', priority = 100 }, command = [[\cdot ]] },
  xx = { context = { name = '×' }, command = [[\times ]] },
  ['opp'] = { context = { name = '⊕' }, command = [[\oplus ]] },
  ['ox'] = { context = { name = '⊗' }, command = [[\otimes ]] },
  ['...'] = { context = { name = '…' }, command = [[\ldots ]] },
  ['||'] = { context = { name = '∣' }, command = [[\mid ]] },
  ['inn'] = { context = { name = '∈', priority = 100 }, command = [[\in ]] },
  ['ni'] = { context = { name = '∋' }, command = [[\ni ]] },
  notni = { context = { name = '∌' }, command = [[\not\ni ]] },
  notin = { context = { name = '∉' }, command = [[\not\in ]] },
  cap = { context = { name = '∩' }, command = [[\cap ]] },
  cup = { context = { name = '∪' }, command = [[\cup ]] },
  cq = { context = { name = '⊂' }, command = [[\subset ]] },
  cc = { context = { name = '⊆' }, command = [[\subseteq ]] },
  qc = { context = { name = '⊃' }, command = [[\supset ]] },
  qq = { context = { name = '⊇' }, command = [[\supseteq ]] },
  ['\\\\\\'] = { context = { name = '⧵' }, command = [[\setminus ]] },

  --- Blackboard bold symbols
  NN = { context = { name = 'ℕ' }, command = [[\N]] },
  ZZ = { context = { name = 'ℤ' }, command = [[\Z]] },
  QQ = { context = { name = 'ℚ' }, command = [[\Q]] },
  RR = { context = { name = 'ℝ' }, command = [[\R]] },
  CC = { context = { name = 'ℂ' }, command = [[\C]] },
  PP = { context = { name = 'ℙ' }, command = [[\P]] },
  EE = { context = { name = '𝔼' }, command = [[\E]] },
  VV = { context = { name = '𝕍' }, command = [[\V]] },
  --- Math Caligraphic symbols
  LL = { context = { name = 'ℒ' }, command = [[\L]] },
  MM = { context = { name = 'ℳ' }, command = [[\M]] },
  SS = { context = { name = '𝒮' }, command = [[\S]] },
  FF = { context = { name = 'ℱ' }, command = [[\F]] },
  TT = { context = { name = '𝒯' }, command = [[\T]] },
  BB = { context = { name = 'ℬ' }, command = [[\B]] },
  HH = { context = { name = 'ℋ' }, command = [[\H]] },
  --- Math Fraktur symbols
  XX = { context = { name = '𝖃' }, command = [[\X]] },
  YY = { context = { name = '𝖄' }, command = [[\Y]] },

  -- quantifiers and logic stuffs
  ['wedge'] = { context = { name = '∨' }, command = [[\wedge ]] },
  ['vee'] = { context = { name = '∧' }, command = [[\vee ]] },
  dd = { context = { name = 'd' }, command = [[\d]] },
  pd = { context = { name = '∂' }, command = [[\partial]] },

  -- etc
  ['øø'] = { context = { name = '∅' }, command = [[\emptyset ]] },
  pwr = { context = { name = 'P' }, command = [[\powerset ]] },
  ooo = { context = { name = '∞' }, command = [[\infty ]] },
  top = { context = { name = '⊤' }, command = [[\top ]] },
  ll = { context = { name = 'ℓ' }, command = [[\ell]] },
  dag = { context = { name = '†' }, command = [[\dagger ]] },
  ['+-'] = { context = { name = '±' }, command = [[\pm ]] },
  ['-+'] = { context = { name = '∓' }, command = [[\mp ]] },
  quad = { context = { name = ' ' }, command = [[\quad ]] },
  qquad = { context = { name = '  ' }, command = [[\qquad ]] },
  circ = { context = { name = '∘' }, command = [[\circ ]] },
}

local symbol_snippets = {}
for k, v in pairs(symbol_specs) do
  table.insert(
    symbol_snippets,
    -- make all commands have a space after them
    symbol_snippet(vim.tbl_deep_extend('keep', { trig = k }, v.context), v.command, { condition = tex.in_math, show_condition = tex.in_math })
  )
end
vim.list_extend(M, symbol_snippets)

return M
