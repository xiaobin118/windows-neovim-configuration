# Neovim 配置指南

欢迎使用这份功能强大的 Neovim 配置！本配置是为 Windows 系统优化的现代化编辑器设置，整合了众多强大的插件和自定义快捷键。

## 📋 目录

- [快速开始](#快速开始)
- [系统要求](#系统要求)
- [安装说明](#安装说明)
- [快捷键映射](#快捷键映射)
- [插件说明](#插件说明)
- [常见问题](#常见问题)

---

## 🚀 快速开始

### 系统要求

- **Neovim 0.9+** （推荐 0.11+）
- **Windows 10/11** 或 WSL2
- **Git** （用于克隆和管理插件）
- **Node.js** （某些 LSP 服务器需要）
- **Python 3** （某些语言服务器需要）

### 推荐安装

推荐使用 **Neovide**（Neovim 的 GUI）以获得最佳体验：
- 支持动画光标效果
- 平滑滚动
- 透明窗口
- 更好的字体渲染

下载地址：https://github.com/neovide/neovide/releases

---

## 📦 安装说明

### 1. 克隆配置文件

```bash
git clone <your-repo-url> $env:APPDATA\nvim
```

### 2. 首次启动 Neovim

启动时 Lazy.nvim 会自动安装所有插件。首次启动可能需要 1-3 分钟。

```bash
nvim
```

### 3. 安装 LSP 服务器（可选但推荐）

打开任意代码文件后，使用以下命令安装语言服务器：

```vim
:Mason
```

然后选择需要的服务器安装。本配置预配置了以下 LSP：
- `lua_ls` - Lua 语言支持
- `pylsp` - Python 语言支持
- `html` - HTML 语言支持
- `cssls` - CSS 语言支持
- `ltex_plus` - Markdown/LaTeX 语法检查

---

## ⌨️ 快捷键映射

### 基础编辑快捷键

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `jj` | 插入模式 | 退出到普通模式 |
| `jd` | 插入模式 | 退出并在下一行插入 |
| `<C-L>` | 插入模式 | 右移光标 |
| `<C-v>` | 插入模式 | 粘贴（系统剪贴板） |
| `<C-a>` | 插入模式 | 光标移动到行首 |
| `<C-e>` | 插入模式 | 光标移动到行尾 |
| `<Space>` | 普通模式 | 进入命令模式（代替 `:`) |

### 窗口和缓冲区操作

| 快捷键 | 功能 |
|--------|------|
| `<S-Left>` | 切换到上一个 Tab |
| `<S-Right>` | 切换到下一个 Tab |
| `<leader>w` | 在窗口间切换 |
| `<C-Up>` | 增加当前窗口高度 |
| `<C-Down>` | 减少当前窗口高度 |
| `<C-Left>` | 减少当前窗口宽度 |
| `<C-Right>` | 增加当前窗口宽度 |

### 文件操作快捷键

| 快捷键 | 功能 |
|--------|------|
| `<leader>ff` | 查找文件（全项目） |
| `<leader>fn` | 查找文件（当前缓冲区目录） |
| `<leader>fg` | 全文搜索（Live Grep） |
| `<leader>fb` | 查看打开的缓冲区 |
| `<leader>fr` | 查看最近文件 |
| `<leader>fh` | 查看帮助标签 |
| `<leader>fc` | 查看配置文件 |

### LSP 相关快捷键

| 快捷键 | 功能 |
|--------|------|
| `K` | 显示悬停文档 |
| `<leader>d` | 跳转到定义 |
| `<leader>rn` | 重命名符号 |
| `<leader>re` | 查看所有引用 |
| `<leader>t` | 跳转到类型定义 |
| `<leader>s` | 显示函数签名 |
| `<leader>ai` | 代码操作（Code Action） |
| `<leader>oi` | 组织导入 |
| `gj` | 跳转到上一个诊断 |
| `gk` | 跳转到下一个诊断 |

### 代码格式化

| 快捷键 | 功能 |
|--------|------|
| `~` | 格式化当前文件 |
| `<F2>` | 删除空行（视觉模式） |
| `<C-F2>` | 垂直分屏比较文件 |

### 终端相关快捷键

| 快捷键 | 功能 |
|--------|------|
| `<leader>tt` | 打开/关闭水平终端 |
| `<leader>tv` | 打开/关闭竖直终端 |
| `<leader>tf` | 打开/关闭浮动终端 |
| `<leader>tg` | 打开 LazyGit |
| `<leader>tp` | 打开 Python REPL |
| `<leader>tn` | 打开 Node REPL |
| `<leader>ts` | 打开 PowerShell |
| `<leader>t1-t4` | 打开/切换特定终端 |
| `<Esc>` | 在终端模式下退出（进入普通模式） |

### 调试相关快捷键

| 快捷键 | 功能 |
|--------|------|
| `<Alt>dc` | DAP 继续执行 |
| `<Alt>dt` | 切换断点 |
| `<Alt>dov` | 单步步过 |
| `<Alt>di` | 单步进入 |
| `<Alt>dot` | 单步步出 |
| `<leader>du` | 切换 DAP UI |

### 代码片段和补全

| 快捷键 | 功能 |
|--------|------|
| `<Tab>` | 在补全菜单中选择下一项 / 展开片段 |
| `<S-Tab>` | 在补全菜单中选择上一项 / 跳转到前一个片段位置 |
| `<C-Space>` | 手动触发补全菜单 |
| `<C-b>` | 补全窗口向上滚动 |
| `<C-f>` | 补全窗口向下滚动 |
| `<C-e>` | 关闭补全菜单 |
| `<CR>` | 确认选择 |

### 注释操作（NERDCommenter）

| 快捷键 | 功能 |
|--------|------|
| `<leader>cc` | 注释当前行 |
| `<leader>cu` | 取消注释当前行 |
| `<leader>cb` | 块注释 |
| `<leader>c<Space>` | 切换注释状态 |

### 代码导航（Flash）

| 快捷键 | 功能 |
|--------|------|
| `s` | 快速跳转到字符 |
| `S` | 使用 Treesitter 快速跳转 |
| `r` | 远程快速跳转（操作符模式） |
| `R` | Treesitter 搜索 |
| `<C-s>` | 切换 Flash 搜索（命令模式） |

### 复制粘贴相关

| 快捷键 | 功能 |
|--------|------|
| `<C-c>` | 复制到系统剪贴板（视觉模式） |
| `<C-a>` | 全选并复制（普通模式） |
| `<C-v>` | 粘贴系统剪贴板（多种模式） |

### Copilot 相关

| 快捷键 | 功能 |
|--------|------|
| `<C-R>` | 接受 Copilot 建议 |
| `<leader>ne` | 接受并跳转到下一个编辑 |
| `<Esc>` | 拒绝 Copilot 建议 |

### 诊断相关

| 快捷键 | 功能 |
|--------|------|
| `<leader>qe` | 打开快速修复列表（显示所有诊断） |

### Neovide 特定快捷键

| 快捷键 | 功能 |
|--------|------|
| `<F11>` | 切换全屏模式 |
| `<C-=>` | 放大 |
| `<C-->` | 缩小 |
| `<C-0>` | 重置缩放 |
| `<A-]>` | 增加透明度 |
| `<A-[>` | 降低透明度 |

---

## 🔌 插件说明

### 核心插件

#### Lazy.nvim
- **作用**: 插件管理器
- **配置**: 自动管理所有插件的加载和更新

#### Mason & Mason LSP Config
- **作用**: 语言服务器管理
- **配置**: 自动安装和配置 LSP 服务器
- **支持语言**: Lua, Python, HTML, CSS, LaTeX 等

### UI/UX 插件

#### Catppuccin
- **作用**: 主题配色方案
- **特点**: 优雅的配色，支持多种变体

#### Lualine
- **作用**: 状态栏
- **特点**: 显示 Git 分支、诊断、Copilot 状态等

#### Barbar
- **作用**: 缓冲区导航栏
- **特点**: 在顶部显示打开的缓冲区

#### Telescope
- **作用**: 模糊查找和快速导航
- **功能**: 文件查找、全文搜索、缓冲区列表等

#### Neo-tree
- **作用**: 文件浏览器
- **快捷键**: 详见文件浏览器配置

### 编程工具

#### nvim-treesitter
- **作用**: 代码语法解析和高亮
- **支持**: 自动配对标签、缩进等

#### nvim-cmp
- **作用**: 代码补全引擎
- **来源**: LSP、Snippets、Buffer、Path 等

#### LuaSnip
- **作用**: 代码片段管理
- **来源**: VSCode 格式的片段库

#### Conform
- **作用**: 代码格式化
- **支持**: Prettier, Stylua, Autopep8 等

#### nvim-dap
- **作用**: 代码调试
- **支持**: JavaScript/TypeScript, Python 等

### 增强工具

#### Copilot
- **作用**: AI 代码助手
- **功能**: 代码补全建议、NES（Neovim Edit Suggestions）

#### Avante
- **作用**: AI 对话助手
- **功能**: 与 AI 交互，代码讨论等

#### Flash
- **作用**: 快速代码导航
- **特点**: 类似 Vim 的 EasyMotion

#### Toggleterm
- **作用**: 集成终端管理
- **功能**: 多个终端、LazyGit、REPL 等

#### Auto-save
- **作用**: 自动保存
- **触发**: 离开插入模式时自动保存

### 语言支持

#### VimTeX
- **作用**: LaTeX 编辑支持
- **查看器**: SumatraPDF（Windows）

#### Typescript-tools
- **作用**: TypeScript/JavaScript 增强支持
- **功能**: 类型检查、代码操作等

#### vim-dadbod
- **作用**: 数据库客户端
- **功能**: SQL 执行、DBUI 界面等

---

## 📝 常用工作流

### 编写代码

1. 打开文件: `<leader>ff`
2. 使用 LSP 进行代码导航和补全
3. 使用 Copilot 获取建议: `<C-R>` 接受
4. 格式化代码: `~`
5. 提交前查看诊断: `<leader>qe`

### 调试代码

1. 设置断点: `<Alt>dt`
2. 启动调试: `<Alt>dc`
3. 单步执行: `<Alt>dov` / `<Alt>di`
4. 查看 DAP UI: `<leader>du`

### 使用终端

1. 打开终端: `<leader>tt`
2. 执行 LazyGit: `<leader>tg`
3. 打开 Python/Node REPL: `<leader>tp` / `<leader>tn`

### 快速导航

1. 快速跳转: `s` (Flash)
2. 全文搜索: `<leader>fg`
3. 跳转到定义: `<leader>d`

---

## 🛠️ 高级配置

### 自定义快捷键

编辑 `lua/config/keymaps.lua` 文件修改快捷键。

### 自定义配置选项

编辑 `lua/config/options.lua` 文件修改编辑器选项。

### 自定义自动命令

编辑 `lua/config/autocmds.lua` 文件添加自定义自动命令。

### 添加新插件

编辑 `lua/plugins/` 中对应的文件，按 Lazy.nvim 格式添加插件配置。

---

## 🐛 常见问题

### Q: 启动时很慢怎么办？

**A**: 首次启动会安装所有插件，这是正常的。后续启动会很快。如果持续缓慢：
1. 检查插件数量
2. 运行 `:Lazy profile` 查看性能瓶颈
3. 禁用不需要的插件

### Q: LSP 无法连接怎么办？

**A**:
1. 确认已安装 LSP: `:Mason`
2. 检查诊断信息: `:checkhealth`
3. 查看 LSP 日志: `:LspLog`

### Q: Copilot 无法工作？

**A**:
1. 确认已认证: `:Copilot auth`
2. 检查网络连接
3. 查看 `:messages` 输出

### Q: 如何禁用某个插件？

**A**: 在插件配置中添加 `enabled = false` 选项，或将整个插件块注释掉。

### Q: 如何修改主题？

**A**: 在 `init.lua` 中修改:
```lua
vim.cmd.colorscheme("catppuccin")
```

### Q: Neovide 不工作？

**A**:
1. 确保已安装 Neovide
2. 检查 `lua/config/options.lua` 中的 Neovide 配置
3. 使用 `nvim` 直接启动测试

### Q: 如何自动运行代码？

**A**: 使用快捷键 `:run`（需要在对应文件类型中定义）。已支持的语言：
- C/C++: `:run`
- Python: `:run`
- JavaScript: `:run`
- Rust: `:run`
- LaTeX: `:run`

---

## 📚 进阶资源

- [Neovim 官方文档](https://neovim.io/doc/user/)
- [Lazy.nvim 文档](https://github.com/folke/lazy.nvim)
- [Neovide 文档](https://github.com/neovide/neovide)
- [LSPConfig 文档](https://github.com/neovim/nvim-lspconfig)

---

## 📄 许可证

本配置基于个人需求定制，欢迎 Fork 和修改。

---

**最后更新**: 2026-03-24

**配置作者**: Xiaobin118

**联系方式**: 3350844208@qq.com

---

## 🎯 快速命令参考

```vim
" 插件管理
:Lazy                  " 打开 Lazy 面板
:Lazy sync             " 同步所有插件
:Lazy update           " 更新所有插件
:Lazy profile          " 查看性能分析

" LSP 相关
:Mason                 " 打开 Mason 管理器
:LspInfo               " 查看 LSP 信息
:LspLog                " 查看 LSP 日志
:checkhealth           " 检查系统健康

" 代码操作
:Telescope live_grep   " 全文搜索
:Telescope find_files  " 查找文件
:Neotree               " 打开文件浏览器
:ToggleTerm            " 切换终端

" 调试
:DapContinue           " 继续执行
:DapToggleBreakpoint   " 切换断点
:DapUI                 " 打开调试界面

" 其他
:Copilot auth          " 认证 Copilot
:Avante                " 打开 Avante 对话
:LeetCode              " 打开 LeetCode
:DBUI                  " 打开数据库界面
```

---

祝您使用愉快！ 🎉

