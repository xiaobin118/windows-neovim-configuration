local M = {}

--- 在 PATH 或候选目录中查找可执行文件
---@param name string 可执行文件名（如 "gcc"、"SumatraPDF.exe"）
---@param candidates string[]? 候选目录列表（绝对路径，正斜杠）
---@return string|nil 找到则返回路径，否则 nil
function M.find_executable(name, candidates)
  if vim.fn.executable(name) == 1 then
    return name
  end
  if candidates then
    local ext = vim.fn.has("win32") == 1 and ".exe" or ""
    for _, dir in ipairs(candidates) do
      local full = dir .. "/" .. name .. ext
      if (vim.uv or vim.loop).fs_stat(full) then
        return full
      end
    end
  end
  return nil
end

return M
