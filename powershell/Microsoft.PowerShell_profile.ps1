# Use the Oh-my-posh terminal prompt: https://ohmyposh.dev/docs/
oh-my-posh init pwsh --config '$home/dotfiles/PowerSehll/.oh-my-posh/iainm.omp.json' | Invoke-Expression



# Use the PSGallery terminal icons: https://www.hanselman.com/blog/take-your-windows-terminal-and-powershell-to-the-next-level-with-terminal-icons
Import-Module -Name Terminal-Icons

Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows

# Aliases
Set-Alias -Name vi -Value nvim
Set-Alias -Name vim -Value nvim

New-Alias which get-command
