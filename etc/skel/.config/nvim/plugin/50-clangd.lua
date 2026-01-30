local prev_on_attach = vim.tbl_get(vim.lsp.config, "clangd", "on_attach")

vim.lsp.config("clangd", {
    cmd = {"clangd", "--compile-commands-dir=build", "--header-insertion=never"},
    root_markers = {
        "build",
        ".clangd",
        "configure.ac",
        ".git",
    },
    on_attach = function(client, bufnr)
        if prev_on_attach then
            prev_on_attach(client, bufnr)
        end
        vim.keymap.set("n", "gh", "<cmd>LspClangdSwitchSourceHeader<cr>", {buffer = bufnr})
    end
})

vim.lsp.enable("clangd")
