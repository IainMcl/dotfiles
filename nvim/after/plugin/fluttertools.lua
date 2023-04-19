require("flutter-tools").setup {
    ui = {
        border = "rounded",
        notification_style = "native"
    },
    debugger = {
        enabled = true,
        register_configurations = function(_)
            require("dap").configurations.dart = {}
            require("dap.ext.vscode").load_launchjs()
        end,
    },
}
