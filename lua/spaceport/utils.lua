local M = {}

--- Resolved GitHub-style slug like owner/repo from git remote, else plugin folder name.
---@return string
function M.plugin_install_hint()
    local paths = vim.api.nvim_get_runtime_file("lua/spaceport/init.lua", false)
    if not paths or #paths == 0 then
        return "spaceport.nvim"
    end
    local root = vim.fn.fnamemodify(paths[1], ":p:h:h:h")
    local url = vim.trim(vim.fn.system({
        "git",
        "-C",
        root,
        "remote",
        "get-url",
        "origin",
    }))
    if vim.v.shell_error == 0 and url ~= "" then
        local owner, repo = url:match("github%.com[:/]([^/]+)/([^%s/]+)")
        if owner and repo then
            repo = repo:gsub("%.git$", "")
            return owner .. "/" .. repo
        end
    end
    local name = vim.fn.fnamemodify(root, ":t")
    if name ~= "" and name ~= "." then
        return name
    end
    return "spaceport.nvim"
end

---@return number
function M.getSeconds()
    return vim.fn.localtime()
end

---@return boolean
---@param time number
function M.isToday(time)
    local today = vim.fn.strftime("%Y-%m-%d")
    local t = vim.fn.strftime("%Y-%m-%d", time)
    return today == t
end

---@return boolean
---@param time number
function M.isYesterday(time)
    local yesterday = vim.fn.strftime("%Y-%m-%d",
        vim.fn.localtime() - 24 * 60 * 60)
    local t = vim.fn.strftime("%Y-%m-%d", time)
    return yesterday == t
end

---@return boolean
---@param time number
function M.isPastWeek(time)
    return time > M.getSeconds() - 7 * 24 * 60 * 60
end

---@return boolean
---@param time number
function M.isPastMonth(time)
    return time > M.getSeconds() - 30 * 24 * 60 * 60
end

return M
