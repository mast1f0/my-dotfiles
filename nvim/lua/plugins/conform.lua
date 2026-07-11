return {
    {
        "stevearc/conform.nvim",

        config = function()

            require("conform").setup({
                formatters_by_ft = {
                    go = { "gofmt" },
                    python = { "ruff_format" },
                    rust = { "rustfmt" },
                    javascript = { "prettier" },
                    html = { "prettier" },
                    css = { "prettier" },
                },
            })

            vim.keymap.set("n", "<leader>f", function()
                require("conform").format()
            end)
        end,
    },
}
