# 设计：nvim 配置跨机器可移植化（Windows）

日期：2026-08-31
状态：已批准（用户 2026-08-31 确认）

## 背景与问题

配置仓库已推到 GitHub（`windows-neovim-configuration`），但在**其它 Windows 机器**上克隆导入时频繁报错。根因两类：

1. **硬编码绝对路径**（本机专属，跨机器不存在）：
   - `lua/plugins/treesitter.lua:8-20` — 写死 `E:\scoop\apps\msys2\current`（MSYS2 gcc）
   - `lua/plugins/lang.lua:36` — 写死 `D:\SumatraPDF\SumatraPDF.exe`（vimtex 查看器）
   - `init.lua:3-7` — 写死 `C:\Windows\System32\curl.exe`（copilot/plenary）
   - `lua/plugins/dap.lua` — 反斜杠拼接 + 硬编码 `codelldb.cmd` / `sharpdbg.exe`，且依赖的 mason 包未安装
   - `lua/plugins/lang.lua:126` — `stdpath("data") .. "\\db_ui"` 反斜杠拼接

2. **外部依赖丢失**：ripgrep（telescope live_grep 必需）、gcc/make（treesitter 编译 parser）、格式化器等。`install.ps1` 目前只检查 nvim/git，缺失只警告不安装。

## 目标

- 任何 Windows 机器 clone 仓库 + 运行 `install.ps1` 即可使用
- **必需依赖**（gcc/make、ripgrep）由脚本自动安装
- 所有本机硬编码路径改为自动探测，找不到时优雅降级（跳过而非报错）
- 保持"只 Windows"（用户明确不需要跨平台）

## 非目标

- 不支持 macOS / Linux
- 不改变插件选择、按键映射、整体目录布局
- 不重写现有配置逻辑，只做可移植性修复

## 具体改动

### 1. 新增 `lua/config/util.lua`

提供可执行文件探测工具，供各处复用：

```lua
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
```

### 2. 修改五处硬编码路径

| 文件:行 | 现状 | 改为 |
|---|---|---|
| `init.lua:3-7` | 写死 `C:\Windows\System32\curl.exe` | `find_executable("curl", {"C:/Windows/System32"})`，nil 则跳过不设置 |
| `treesitter.lua:8-20` | 写死 msys2 三路径 | **主要**：探测 PATH 里的 `gcc`（mingw 装后自动进 PATH）；**兜底**：`os.getenv("SCOOP")` 拼 `/apps/msys2/current/mingw64/bin` 候选（兼容本机现有 msys2 环境）；找到则设 `compilers`，找不到跳过 |
| `lang.lua:36` | 写死 `D:\SumatraPDF\SumatraPDF.exe` | `find_executable("SumatraPDF.exe", {LOCALAPPDATA/SumatraPDF, Program Files/SumatraPDF})`；nil 则不设 viewer |
| `lang.lua:126` | `"\\db_ui"` | `"/db_ui"` |
| `dap.lua:22-30,78,111` | 反斜杠 + 硬编码二进制名 | 统一 `/`；`mason_bin_file(name)` 按平台加 `.cmd`；adapter 定义前 `filereadable` 检查；缺失则跳过该 adapter |

`lsp.lua` 的 mason `ensure_installed` 增加 `codelldb`、`js-debug-adapter`、`sharpdbg`，保证新机器首次启动自动装好 DAP 依赖。

### 3. 增强 `install.ps1`

- **包管理器自动选择**：检测已有的 winget / scoop → 优先用已有的；都没有则引导安装 scoop（便携、免管理员）
- **必需依赖自动装**：`mingw`（gcc+make，scoop 包，装后自动进 PATH）、`ripgrep`；缺失则自动装，装完重新验证
- **可选依赖提示不装**：lazygit、node、python、SumatraPDF、格式化器（prettier/stylua/clang-format/autopep8/beautysh）——脚本列出安装命令，用户自行决定

## 验证

1. 本机 nvim 中 `:luafile lua/config/util.lua` 验证探测函数
2. 启动 nvim，确认改后配置无报错、telescope/vimtex/dap 正常加载
3. 通过参数模拟新机器（备份 nvim-data，走一遍依赖安装流程，验证必需依赖装好后配置可运行）
