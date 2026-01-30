local function map(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, {noremap = true})
end

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

-- termdebug
vim.cmd([[
    packadd termdebug

    if !exists("g:termdebug_config")
        let g:termdebug_config = { }
    endif

    let g:termdebug_config.signs = ["󰲠", "󰲢", "󰲤", "󰲦", "󰲨", "󰲪", "󰲬", "󰲮", "󰲰"]
    let g:termdebug_config.sign = "󰲲"

    highlight debugBreakpoint ctermfg=darkred ctermbg=NONE guifg=darkred guibg=NONE
]])

map("n", "<f4>", "<cmd>Termdebug<cr>")
map("n", "<f16>", "<cmd>Source<cr><cmd>wincmd L<cr>")

map("n", "<f5>", "<cmd>Run<cr>")
map("n", "<f17>", "<cmd>Stop<cr>") -- s-f5
map("n", "<f29>", "<cmd>Cont<cr>") -- c-f5

map("n", "<f6>", "<cmd>Gdb<cr>")
map("n", "<f18>", "<cmd>Source<cr>") -- s-f6
map("n", "<f30>", "<cmd>Program<cr>") -- c-f6

map("n", "<f9>", "<cmd>Break<cr>")
map("n", "<f21>", "<cmd>Clear<cr>") -- s-f9

map("n", "<f10>", "<cmd>Over<cr>")
map("n", "<f34>", "<cmd>Until<cr>") -- c-f10

map("n", "<f11>", "<cmd>Step<cr>")
map("n", "<f23>", "<cmd>Finish<cr>") -- s-f11
