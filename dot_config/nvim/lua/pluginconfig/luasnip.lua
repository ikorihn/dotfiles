local status_ok, luasnip = pcall(require, "luasnip")
if not status_ok then return end

local snip = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node
local parse = require("luasnip.util.parser").parse_snippet

vim.keymap.set({ "i", "s" }, "<C-J>", function() luasnip.jump(1) end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-K>", function() luasnip.jump(-1) end, { silent = true })

luasnip.add_snippets(nil, {
	go = {
		snip({
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
		snip(
			{ trig = "snpifew", name = "If Err Wrapped", dscr = "Insert a if err not nil statement with wrapped error" },
			{
				t("if err != nil {"),
				t({ "", '  return fmt.Errorf("failed to ' }),
				i(1, "message"),
				t(': %w", err)'),
				t({ "", "}" }),
			}
		),
		snip({ trig = "snpifec", name = "If Err with condition" }, {
			t("if err := "),
			i(1, "condition"),
			t({ "; err != nil {", "" }),
			i(0),
			t({ "", "}" }),
		}),

		snip({
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
		snip({
			trig = "snpcmpdiff",
		}, {
			t({ 'if diff := cmp.Diff(tt.want, got); diff != "" {', '	t.Errorf("' }),
			i(1, "func"),
			t({ '() mismatch (-want +got):\\n%s", diff)', "}" }),
		}),

		snip({ trig = "snpdeferfun", name = "defer func", dscr = "Insert defer func" }, {
			t({ "defer func() {", "" }),
			i(0),
			t({ "", "}()" }),
		}),
		snip({ trig = "snpswitch", name = "switch case", dscr = "Insert switch" }, {
			t({ "switch " }),
			i(1, "var"),
			t({ " {", "case " }),
			i(2, "value"),
			t({ ":", "" }),
			i(0),
			t({ "", "}" }),
		}),

		snip({
			trig = "snpctx",
		}, {
			t({ "ctx context.Context" }),
		}),
		snip({
			trig = "snpctxbg",
		}, {
			t({ "ctx := context.Background()" }),
		}),
		snip({
			trig = "snpctxto",
		}, {
			t({ "ctx, cancel := context.WithTimeout(ctx, time.Second)", "defer cancel()" }),
		}),
		snip({
			trig = "snpctxvalue",
		}, {
			t({ "ctx = context.WithValue(ctx, " }),
			i(1, "key"),
			t({ ", " }),
			i(2, "value"),
			t({ ") " }),
		}),
	},
})
