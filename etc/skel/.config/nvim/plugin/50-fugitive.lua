if type(create_alias) == "function" then
    create_alias("git", "Git")
end

local function map(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, {noremap = true})
end

map("n", "<leader>gb", "<cmd>Git blame<cr>")
map("n", "<leader>gd", "<cmd>Gdiffsplit<cr>")
map("n", "<leader>gg", "<cmd>Git<cr>")
map("n", "<leader>gl", "<cmd>Git log --oneline<cr>")
