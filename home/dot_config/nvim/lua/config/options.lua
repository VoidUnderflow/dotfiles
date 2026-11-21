-- Copy to the system clipboard through the terminal (OSC 52), so no clipboard tool is needed.
-- p pastes Neovim's last yank. Paste from outside with Ctrl+Shift+V in insert mode.
-- The Mac keeps Neovim's built-in pbcopy/pbpaste support, which also pastes.
if vim.fn.has("mac") == 0 then
  local osc52 = require("vim.ui.clipboard.osc52")
  local function paste_last_yank()
    return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
  end
  vim.g.clipboard = {
    name = "OSC 52",
    copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
    paste = { ["+"] = paste_last_yank, ["*"] = paste_last_yank },
  }
end
