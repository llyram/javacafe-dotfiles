local _format, format = pcall(require, "formatter")

if not _format then return end

local prettier_common = function()
    return {
        stdin = true,
        exe = "prettierd",
        args = {vim.api.nvim_buf_get_name(0)}
    }
end

local luafmt = function() return {stdin = true, exe = "lua-format"} end

local nixpkgsfmt = function() return {stdin = false, exe = "nixpkgs-fmt"} end

format.setup({
    filetype = {
        nix = {nixpkgsfmt},
        lua = {luafmt},
        css = {prettier_common},
        svx = {prettier_common},
        mdx = {prettier_common},
        scss = {prettier_common},
        yaml = {prettier_common},
        json = {prettier_common},
        html = {prettier_common},
        astro = {prettier_common},
        svelte = {prettier_common},
        markdown = {prettier_common},
        javascript = {prettier_common},
        typescript = {prettier_common},
        javascriptreact = {prettier_common},
        typescriptreact = {prettier_common}
    }
})
