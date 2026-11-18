# Installs (or with -Uninstall removes) More Options for Saints Row The Third into a game folder.
#   powershell -ExecutionPolicy Bypass -File install.ps1 -Game "<your Saints Row The Third folder>"
#   powershell -ExecutionPolicy Bypass -File install.ps1 -Game "<your Saints Row The Third folder>" -Uninstall
# Needs SR3 Mod UI (version 2 or newer) installed first, an ASI loader (dinput8.dll) and the DX11 executable.
# The game must be closed.
param([Parameter(Mandatory = $true)][string]$Game, [switch]$Uninstall)
$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not (Test-Path "$Game\SaintsRowTheThird_DX11.exe")) { "No SaintsRowTheThird_DX11.exe in '$Game' - pass -Game <folder>"; exit 1 }
$running = Get-Process SaintsRowTheThird* -ea 0 | Where-Object { $_.Path -like "$Game\*" }
if ($running) { 'The game is running from that folder - close it first.'; exit 1 }

if ($Uninstall) {
    Remove-Item "$Game\MoreOptionsSRTT.asi", "$Game\SR3ModUI\mods\moreoptions.lua" -ea 0
    'removed MoreOptionsSRTT.asi and SR3ModUI\mods\moreoptions.lua; kept MoreOptionsSRTT.ini (your settings)'
    exit 0
}
if (-not (Test-Path "$Game\SR3ModUI.asi")) { 'SR3 Mod UI is not installed in that folder - install it first (see the README).'; exit 1 }
$asi = @("$here\out\MoreOptionsSRTT.asi", "$here\MoreOptionsSRTT.asi") | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $asi) { 'MoreOptionsSRTT.asi not found - run build.bat or use the release zip'; exit 1 }
New-Item -ItemType Directory -Force "$Game\SR3ModUI\mods" | Out-Null
$files = [ordered]@{ 'MoreOptionsSRTT.asi' = $asi; 'SR3ModUI\mods\moreoptions.lua' = "$here\lua\moreoptions.lua" }
foreach ($k in $files.Keys) {
    Copy-Item $files[$k] "$Game\$k" -Force
    $ok = (Get-FileHash $files[$k]).Hash -eq (Get-FileHash "$Game\$k").Hash
    '{0,-34} {1}' -f $k, $(if ($ok) { 'OK' } else { 'HASH MISMATCH' })
}
'Installed. In game: Options > Display. Settings: MoreOptionsSRTT.ini. Log: SR3ModUI.log'
