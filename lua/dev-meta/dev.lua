local function map(mode, lhs, rhs, opts)
    vim.keymap.set(mode, lhs, rhs, opts)
end

-- highlight
local group = vim.api.nvim_create_augroup("LspDocHighlight", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client or not client.server_capabilities.documentHighlightProvider then
            return
        end

        map("n", "<leader>l", vim.lsp.buf.document_highlight, { buffer = args.buf })

        vim.api.nvim_clear_autocmds({ buffer = args.buf, group = group })
        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = args.buf, group = group,
            callback = vim.lsp.buf.clear_references,
        })
    end
})

-- CMake
vim.api.nvim_create_user_command("CMake", function(opts)
   local mp = vim.bo.makeprg
   vim.bo.makeprg = "cmake"
   vim.cmd("make " .. table.concat(opts.fargs, " "))
   vim.bo.makeprg = mp
end, { nargs = "*" })

if type(create_alias) == "function" then
   create_alias("cmake", "CMake")
end

map("n", "<leader>mb", ":CMake --build build -j `nproc` ")
map("n", "<leader>mg", ":CMake -B build ")
map("n", "<leader>mx", ":CMake -E rm -rf build ")

-- diff
map("n", "<leader>do", "<cmd>windo diffoff<cr>")
map("n", "<leader>dt", "<cmd>windo diffthis<cr>")

-- termdebug
vim.g.termdebug_config = {
    command = { "gdb", "-iex", "set debuginfod enabled off" },
    signs = { "󰲠", "󰲢", "󰲤", "󰲦", "󰲨", "󰲪", "󰲬", "󰲮", "󰲰" },
    sign = "󰲲",
    wide = 1
}

local function load_termdebug()
    if vim.fn.exists(":Termdebug") == 0 then vim.cmd.packadd("termdebug") end
end

local function set_breakpoint_hl()
    vim.api.nvim_set_hl(0, "debugBreakpoint", { ctermfg = "darkred", fg = "darkred" })
end
set_breakpoint_hl()
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_breakpoint_hl })

-- Debug
vim.api.nvim_create_user_command("Debug", function(opts)
    load_termdebug()

    local spr = vim.o.splitright
    vim.o.splitright = false
    local ok, err = pcall(vim.cmd, "Termdebug " .. opts.args)
    vim.o.splitright = spr

    if ok then vim.api.nvim_win_set_width(0, 42)
    else error(err) end
end, { nargs = "*", complete = "file" })

-- Launch
vim.api.nvim_create_user_command("Launch", function(opts)
    load_termdebug()

    local spr = vim.o.splitright
    vim.o.splitright = false
    local ok, err = pcall(vim.cmd, "TermdebugCommand " .. opts.args)
    vim.o.splitright = spr

    if ok then
        vim.api.nvim_win_set_width(0, 42)
        vim.cmd("wincmd p | stopinsert")
    else error(err) end
end, { nargs = "+", complete = "file" })

if type(create_alias) == "function" then
   create_alias("launch", "Launch")
end

map("n", "<f5>",    "<cmd>Cont<cr>"  )
map("n", "<c-f5>",  "<cmd>Run<cr>"   )
map("n", "<s-f5>",  "<cmd>Stop<cr>"  )

map("n", "<f9>",    "<cmd>Break<cr>" )
map("n", "<s-f9>",  "<cmd>Clear<cr>" )

map("n", "<f10>",   "<cmd>Over<cr>"  )
map("n", "<c-f10>", "<cmd>Until<cr>" )

map("n", "<f11>",   "<cmd>Step<cr>"  )
map("n", "<s-f11>", "<cmd>Finish<cr>")

map("n", "<f12>",   "<cmd>Eval<cr>"  )
map("v", "<f12>",   ":'<,'>Eval<cr>" )
