return {
    "goolord/alpha-nvim",
    dependencies = { "nvim-mini/mini.icons"},
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.startify")

        -- Function to get fortune | cowsay output
        local function get_fortune()
            local handle = io.popen("fortune | cowsay")
            if handle then
                local result = handle:read("*a")
                handle:close()
                return result
            else
                return "Moo! 🐄"
            end
        end

        -- Set the header to fortune | cowsay output
        dashboard.section.header.val = vim.split(get_fortune(), "\n")

        -- Optional: Set header highlighting
        dashboard.section.header.opts.hl = "AlphaHeader"

        -- Setup alpha with the modified dashboard
        alpha.setup(dashboard.config)
    end,
}
