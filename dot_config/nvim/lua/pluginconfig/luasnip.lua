local status_ok, ls = pcall(require, "luasnip")
if not status_ok then
  return
end

local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key

vim.keymap.set({ "i", "s" }, "<C-J>", function() ls.jump(1) end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-K>", function() ls.jump(-1) end, { silent = true })

ls.add_snippets("all", {
  postfix(".br", {
    f(function(_, parent) return "[" .. parent.snippet.env.POSTFIX_MATCH .. "]" end, {}),
  }),
})

ls.add_snippets("go", {
  postfix(".len", {
    f(function(_, parent) return "len(" .. parent.snippet.env.POSTFIX_MATCH .. ")" end, {}),
  }),

  s({
    trig = "snpfpf",
    name = "Formatted Print",
    dscr = "Insert a formatted print statement",
  }, {
    t({ 'fmt.Printf("%#v\\n",' }),
    i(0),
    t({ ")" }),
  }),

  parse(
    { trig = "snpife", name = "If Err", dscr = "Insert a basic if err not nil statement" },
    [[
      if err != nil {
        return err
      }
      ]]
  ),
  parse(
    { trig = "snpifel", name = "If Err Log Fatal", dscr = "Insert a basic if err not nil statement with log.Fatal" },
    [[
      if err != nil {
        log.Fatal(err)
      }
      ]]
  ),
  s({ trig = "snpifew", name = "If Err Wrapped", dscr = "Insert a if err not nil statement with wrapped error" }, {
    t("if err != nil {"),
    t({ "", '  return fmt.Errorf("failed to ' }),
    i(1, "message"),
    t(': %w", err)'),
    t({ "", "}" }),
  }),
  s({ trig = "snpifec", name = "If Err with condition" }, {
    t("if err := "),
    i(1, "condition"),
    t({ "; err != nil {", "" }),
    i(0),
    t({ "", "}" }),
  }),

  s({
    trig = "snpassert",
  }, {
    t({
      "if tt.wantErr {",
      "	assert.Error(t, err)",
      "} else {",
      "	assert.NoError(t, err)",
      "}",
      "assert.Equal(t, tt.want, got)",
    }),
  }),
  s({
    trig = "snpcmpdiff",
  }, {
    t({ 'if diff := cmp.Diff(tt.want, got); diff != "" {', '	t.Errorf("' }),
    i(1, "func"),
    t({ '() mismatch (-want +got):\\n%s", diff)', "}" }),
  }),

  s({ trig = "snpdeferfun", name = "defer func", dscr = "Insert defer func" }, {
    t({ "defer func() {", "" }),
    i(0),
    t({ "", "}()" }),
  }),
  s({ trig = "snpswitch", name = "switch case", dscr = "Insert switch" }, {
    t({ "switch " }),
    i(1, "var"),
    t({ " {", "case " }),
    i(2, "value"),
    t({ ":", "" }),
    i(0),
    t({ "", "}" }),
  }),

  s({
    trig = "snpctx",
  }, {
    t({ "ctx context.Context" }),
  }),
  s({
    trig = "snpctxbg",
  }, {
    t({ "ctx := context.Background()" }),
  }),
  s({
    trig = "snpctxto",
  }, {
    t({ "ctx, cancel := context.WithTimeout(ctx, time.Second)", "defer cancel()" }),
  }),
  s({
    trig = "snpctxvalue",
  }, {
    t({ "ctx = context.WithValue(ctx, " }),
    i(1, "key"),
    t({ ", " }),
    i(2, "value"),
    t({ ") " }),
  }),
})
