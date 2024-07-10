local status_ok, pounce = pcall(require, "pounce")
if not status_ok then
  return
end

pounce.setup({
  accept_keys = "JFKDLSAHGNUVRBYTMICEOXWPQZ",
  accept_best_key = "<enter>",
  multi_window = true,
  debug = false,
})
