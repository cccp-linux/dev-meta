local function map(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, {noremap = true})
end

-- highlight
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client or not client.server_capabilities.documentHighlightProvider then
            return
        end

        vim.keymap.set("n", "<leader>h", vim.lsp.buf.document_highlight, {buffer = args.buf})

        local group = vim.api.nvim_create_augroup("LspDocHighlight", {clear = false})
        vim.api.nvim_clear_autocmds({buffer = args.buf, group = group})

        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = args.buf, group = group,
            callback = vim.lsp.buf.clear_references,
        })
    end
})

-- CMake
vim.api.nvim_create_user_command("CMake", function(opts)
   local mp0 = vim.opt.makeprg
   vim.opt.makeprg = "cmake"
   vim.cmd("make " .. table.concat(opts.fargs, " "))
   vim.opt.makeprg = mp0
end, {nargs = "*"})

if type(create_alias) == "function" then
   create_alias("cmake", "CMake")
end

map("n", "<leader>mb", ":CMake --build build -j `nproc`")
map("n", "<leader>mg", ":CMake -B build")
map("n", "<leader>mx", ":CMake -E rm -rf build")

-- diff
map("n", "<leader>do", "<cmd>windo diffoff<cr>")
map("n", "<leader>dt", "<cmd>windo diffthis<cr>")

-- termdebug
vim.cmd([[
    packadd termdebug

    if !exists("g:termdebug_config")
        let g:termdebug_config = { }
    endif

    let g:termdebug_config.signs = ["󰲠", "󰲢", "󰲤", "󰲦", "󰲨", "󰲪", "󰲬", "󰲮", "󰲰"]
    let g:termdebug_config.sign = "󰲲"
    let g:termdebug_config.wide = 1

    highlight debugBreakpoint ctermfg=darkred ctermbg=NONE guifg=darkred guibg=NONE
]])

-- Debug
vim.api.nvim_create_user_command("Debug", function(opts)
    local spr = vim.opt.splitright
    vim.opt.splitright = false

    vim.cmd("Termdebug " .. opts.args)
    vim.api.nvim_win_set_width(0, 42)

    vim.opt.splitright = spr
end, {nargs = "*", complete = "file"})

-- Launch
vim.api.nvim_create_user_command("Launch", function(opts)
    local spr = vim.opt.splitright
    vim.opt.splitright = false

    vim.cmd("TermdebugCommand " .. opts.args)
    vim.api.nvim_win_set_width(0, 42)

    vim.opt.splitright = spr
    vim.cmd("wincmd p | stopinsert")
end, {nargs = "+", complete = "file"})

if type(create_alias) == "function" then
   create_alias("launch", "Launch")
end

map("n", "<f5>", "<cmd>Cont<cr>")
map("n", "<c-f5>", "<cmd>Run<cr>")
map("n", "<s-f5>", "<cmd>Stop<cr>")

map("n", "<f9>", "<cmd>Break<cr>")
map("n", "<s-f9>", "<cmd>Clear<cr>")

map("n", "<f10>", "<cmd>Over<cr>")
map("n", "<c-f10>", "<cmd>Until<cr>")

map("n", "<f11>", "<cmd>Step<cr>")
map("n", "<s-f11>", "<cmd>Finish<cr>")

map("n", "<f12>", "<cmd>Eval<cr>")
map("v", "<f12>", ":'<,'>Eval<cr>")
