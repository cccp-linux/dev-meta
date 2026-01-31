local function switch_source_header(client, bufnr)
    local method_name = "textDocument/switchSourceHeader"
    if not client or not client:supports_method(method_name) then
        return vim.notify(("method %s is not supported by any servers active on the current buffer"):format(method_name))
    end

    local params = vim.lsp.util.make_text_document_params(bufnr)
    client:request(method_name, params, function(err, result)
        if err then error(tostring(err)) end
        if not result then
            vim.notify("corresponding file cannot be determined")
            return
        end
        vim.cmd.edit(vim.uri_to_fname(result))
    end, bufnr)
end

vim.lsp.config("clangd", {
    cmd = {"clangd", "--compile-commands-dir=build", "--header-insertion=never"},
    root_markers = {
        "build",
        ".clangd",
        "configure.ac",
        ".git",
    },
    capabilities = { textDocument = { completion = {
        editsNearCursor = true,
    }}},

    on_attach = function(client, bufnr)
        vim.api.nvim_buf_create_user_command(bufnr, "LspClangdSwitchSourceHeader",
            function() switch_source_header(client, bufnr) end,
            {desc = "Switch between source/header"}
        )
        vim.keymap.set("n", "gh", "<cmd>LspClangdSwitchSourceHeader<cr>", {buffer = bufnr})
    end
})

vim.lsp.enable("clangd")
