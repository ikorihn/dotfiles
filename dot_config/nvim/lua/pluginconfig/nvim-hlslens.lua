local status_ok, hlslens = pcall(require, "hlslens")
if not status_ok then
  return
end

hlslens.setup()
