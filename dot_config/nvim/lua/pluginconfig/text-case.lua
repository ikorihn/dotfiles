local status_ok, textcase = pcall(require, "textcase")
if not status_ok then
  return
end

textcase.setup({})

local tele_status_ok, telescope = pcall(require, "telescope")
if not tele_status_ok then
  return
end

telescope.load_extension("textcase")
