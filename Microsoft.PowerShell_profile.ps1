
Import-Module posh-git
Import-Module oh-my-posh

$ProfileScriptDir = Split-Path $script:MyInvocation.MyCommand.Path

Set-PoshPrompt -Theme $ProfileScriptDir\oh-my-posh-theme.json

if ($host.Name -eq 'ConsoleHost')
{
    Import-Module PSReadLine
}
