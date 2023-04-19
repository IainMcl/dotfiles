local dap = require('dap')
dap.configurations.python = {
    {
        type = 'python';
        request = 'launch';
        name = "Launch file";
        program = "${file}";
        pythonPath = function()
            return 'C:\\Python311'
        end;
    },
}

require('dap-python').setup('C:\\Python311\\python.exe')
