local cop_status_ok, copilot = pcall(require, "copilot")
if not cop_status_ok then return end
local chat_status_ok, copilot_chat = pcall(require, "CopilotChat")
if not chat_status_ok then return end

copilot.setup({
  suggestion = { enabled = false },
  panel = { enabled = false },
})

copilot_chat.setup({
  show_help = "yes",
  prompts = {
    Explain = {
      prompt = "/COPILOT_EXPLAIN コードを日本語で説明してください",
      description = "コードの説明をお願いする",
    },
    Review = {
      prompt = "/COPILOT_REVIEW コードを日本語でレビューしてください。",
      description = "コードのレビューをお願いする",
    },
    Fix = {
      prompt = "/COPILOT_FIX このコードには問題があります。バグを修正したコードを表示してください。説明は日本語でお願いします。",
      description = "コードの修正をお願いする",
    },
    Optimize = {
      prompt = "/COPILOT_REFACTOR 選択したコードを最適化し、パフォーマンスと可読性を向上させてください。説明は日本語でお願いします。",
      description = "コードの最適化をお願いする",
    },
    Docs = {
      prompt = "/COPILOT_GENERATE 選択したコードに関するドキュメントコメントを日本語で生成してください。",
      description = "コードのドキュメント作成をお願いする",
    },
    Tests = {
      prompt = "/COPILOT_TESTS 選択したコードの詳細なユニットテストを書いてください。説明は日本語でお願いします。",
      description = "テストコード作成をお願いする",
    },
    FixDiagnostic = {
      prompt = "コードの診断結果に従って問題を修正してください。修正内容の説明は日本語でお願いします。",
      description = "コードの修正をお願いする",
      selection = require("CopilotChat.select").diagnostics,
    },
    Commit = {
      prompt = "実装差分に対するコミットメッセージを日本語で記述してください。",
      description = "コミットメッセージの作成をお願いする",
      selection = require("CopilotChat.select").gitdiff,
    },
    CommitStaged = {
      prompt = "ステージ済みの変更に対するコミットメッセージを日本語で記述してください。",
      description = "ステージ済みのコミットメッセージの作成をお願いする",
      selection = function(source) return require("CopilotChat.select").gitdiff(source, true) end,
    },
  },
})

-- keymaps
local opts = { noremap = true, silent = true }
function ShowCopilotChatActionPrompt()
  require("CopilotChat.integrations.telescope").pick(require("CopilotChat.actions").prompt_actions())
end

function CopilotChatBuffer()
  local input = vim.fn.input("Quick Chat: ")
  if input ~= "" then require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer }) end
end

vim.keymap.set("n", "<leader>ccp", "<cmd>lua ShowCopilotChatActionPrompt()<cr>", opts)
vim.keymap.set("n", "<leader>ccq", "<cmd>lua CopilotChatBuffer()<cr>", opts)
