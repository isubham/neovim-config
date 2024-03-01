local js_based_languages = {
    "typescript",
    "javascript",
    "typescriptreact",
    "javascriptreact"
}

return {
    {
        "mfussenegger/nvim-dap",
        config = function ()
            local dap = require("dap")

            -- vim.api.nvim_set_hl(0, "DapStoppedLine", { default: true, link = "Visual" })
        end
    }
}
