return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
	branch =  'master',
        lazy = false,

        opts = {
            ensure_installed = {
                "go",
                "c",
                "lua",
                "javascript",
                "html",
                "css",
                "python",
                "rust",
            },

            highlight = {
                enable = true,
            },
        },

        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },
}
