vim.lsp.config("pylsp", {
    cmd = {"pylsp"},
    filetypes = {"python"},
    root_markers = {
        ".git",
        "Pipfile",
        "pyproject.toml",
        "requirements.txt",
        "setup.cfg",
        "setup.py",
    },
})

vim.lsp.enable("pylsp")
