param()
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Definition
$serviceOut = Join-Path $root "..\out\service"
$agentOut = Join-Path $root "..\out\agent"

# 1) Скопировать файлы (пример: C:\Program Files\WinToastService)
```

$installDir = "C:\Program Files\WinToastService"
New-Item -Path $installDir -ItemType Directory -Force | Out-Null
Copy-Item -Path (Join-Path $serviceOut "*") -Destination $installDir -Recurse -Force
Copy-Item -Path (Join-Path $agentOut "*") -Destination $installDir -Recurse -Force

# 2) Создать службу (если не существует)
$svcName = "MyServiceApp"
$exe = Join-Path $installDir "MyService.exe"
if (-not (Get-Service -Name $svcName -ErrorAction SilentlyContinue)) {
    sc.exe create $svcName binPath= "`"$exe`"" start= auto
}

# 3) Зарегистрировать EventSource
$source = "MyServiceApp"
if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
    [System.Diagnostics.EventLog]::CreateEventSource($source, "Application")
}

# 4) Создать ярлык в профиле текущего пользователя с AppUserModelID
$WshShell = New-Object -ComObject WScript.Shell
$startMenu = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\WinToastService"
New-Item -ItemType Directory -Path $startMenu -Force | Out-Null
$lnkPath = Join-Path $startMenu "MyAgent.lnk"
$shortcut = $WshShell.CreateShortcut($lnkPath)
$shortcut.TargetPath = Join-Path $installDir "MyAgent.exe"
$shortcut.WorkingDirectory = $installDir
# AppUserModelID - должен совпадать с AppId в коде агента
$shortcut.Arguments = ""
$shortcut.Save()

# Set AppUserModelID via registry per user is not necessary if shortcut uses it at launch.
Write-Host "Installation finished. Please ensure the shortcut exists for the interactive user."
```
