local M = {}

local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux

local home_dir = wezterm.home_dir

local function shorten_path(path, base_dir)
  -- Exceptionally, if the path is the base dir itself or not a child of the
  -- base dir, then we don't shorten it.
  if path:sub(1, #base_dir + 1) ~= base_dir .. "/" then
    return path
  end

  local short_base_dir = base_dir

  if short_base_dir:sub(1, #home_dir) == home_dir then
    short_base_dir = "~" .. short_base_dir:sub(#home_dir + 1)
  end

  short_base_dir = short_base_dir:gsub("/(.).*", "/%1")

  return short_base_dir .. path:sub(#base_dir + 1)
end

---@param opts { base_dirs: { path: string, min_depth: number?, max_depth: number? }[], rooters: string[]?, shorten_paths: boolean? }
local function ProjectWorkspaceSelect(opts)
  local base_dirs = {}
  local rooters = opts.rooters or { ".git" }
  local shorten_paths = opts.shorten_paths

  if shorten_paths == nil then
    shorten_paths = true
  end

  local rooter_find_args = {}

  for i, base_dir in ipairs(opts.base_dirs) do
    base_dirs[i] = ({
      path = base_dir.path,
      min_depth = base_dir.min_depth or 1,
      max_depth = base_dir.max_depth or 1,
    })
  end

  for i, rooter in ipairs(rooters) do
    if 1 < i then
      table.insert(rooter_find_args, "-o")
    end
    table.insert(rooter_find_args, "-name")
    table.insert(rooter_find_args, rooter)
  end

  return wezterm.action_callback(function(window, pane)
    local projects = {}

    for _, base_dir in ipairs(base_dirs) do
      local find_args = {
        "find", base_dir.path,
        "-mindepth", tostring(base_dir.min_depth + 1),
        "-maxdepth", tostring(base_dir.max_depth + 1),
        "(",
        table.unpack(rooter_find_args),
      }
      table.insert(find_args, ")")

      local _, stdout, _ = wezterm.run_child_process(find_args)
      local more_projects = wezterm.split_by_newlines(stdout)

      for _, project in ipairs(more_projects) do
        -- Strip the rooter from the path
        project = project:gsub("/[^/]*$", "")
        local label = project

        if shorten_paths then
          label = shorten_path(project, base_dir.path)
        end

        table.insert(projects, { id = project, label = label })
      end
    end

    window:perform_action(act.InputSelector({
      title = "Switch to project workspace",
      choices = projects,
      action = wezterm.action_callback(function(_, _, id, _)
        if not id then
          return
        end

        local found = false

        for _, workspace in ipairs(mux.get_workspace_names()) do
          if workspace == id then
            found = true
            break
          end
        end

        if not found then
          mux.spawn_window({ cwd = id, workspace = id })
        end

        mux.set_active_workspace(id)
      end),
      fuzzy = true,
    }), pane)
  end)
end

M.action = { ProjectWorkspaceSelect = ProjectWorkspaceSelect }

function M.apply_to_config(_, _)
end

return M
