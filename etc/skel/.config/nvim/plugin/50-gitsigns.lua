require("gitsigns").setup({
    signs = {
        delete      = {text = "╽"},
        topdelete   = {text = "╿"},
        changedelete= {text = "╽"},
    },
    signs_staged = {
        delete      = {text = "╽"},
        topdelete   = {text = "╿"},
        changedelete= {text = "╽"},
    },
    on_attach = function(bufnr)
        local gs = require("gitsigns")

        local function bufmap(mode, lhs, rhs)
            vim.keymap.set(mode, lhs, rhs, {buffer = bufnr})
        end

        bufmap("n", "]c", function()
            if vim.wo.diff then
                vim.cmd.normal({"]c", bang = true})
            else
                gs.nav_hunk("next")
            end
        end)

        bufmap("n", "[c", function()
            if vim.wo.diff then
                vim.cmd.normal({"[c", bang = true})
            else
                gs.nav_hunk("prev")
            end
        end)

        bufmap("n", "<leader>hs", gs.stage_hunk)
        bufmap("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end)
        bufmap("n", "<leader>hS", gs.stage_buffer)

        bufmap("n", "<leader>hr", gs.reset_hunk)
        bufmap("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end)
        bufmap("n", "<leader>hR", gs.reset_buffer)

        bufmap("n", "<leader>hp", gs.preview_hunk)
        bufmap("n", "<leader>hi", gs.preview_hunk_inline)

        bufmap("n", "<leader>hb", function() gs.blame_line({full = true}) end)

        bufmap("n", "<leader>hd", gs.diffthis)
        bufmap("n", "<leader>hD", function() gs.diffthis("~") end)

        bufmap("n", "<leader>hq", gs.setqflist)
        bufmap("n", "<leader>hQ", function() gs.setqflist("all") end)

        bufmap("n", "<leader>tb", gs.toggle_current_line_blame)
        bufmap("n", "<leader>tw", gs.toggle_word_diff)

        bufmap({"o", "x"}, "ih" , gs.select_hunk)
    end
})
