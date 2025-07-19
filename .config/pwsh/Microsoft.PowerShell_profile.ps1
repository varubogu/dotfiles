#!/usr/bin/env pwsh

# スクリプトフォルダを読み込むようにする
#f45873b3-b655-43a6-b217-97c00aa0db58 PowerToys CommandNotFound module

Import-Module -Name Microsoft.WinGet.CommandNotFound
#f45873b3-b655-43a6-b217-97c00aa0db58

### My Custom


# コマンドが存在するかチェック
function Is-Command-Found {
    param (
        [string]$command
    )
    return (Get-Command $command -ErrorAction SilentlyContinue)
}

# コマンド存在チェック＋存在しない場合にメッセージ
function Is-Command-Exists {
    param (
        [string]$command
    )
    if (Is-Command-Found $command) {
        return $true
    } else {
        Write-Host "'$command' is not installed." -ForegroundColor Red
        return $false
    }
}

# PowerShellスクリプトを実行する関数
# スクリプト名を引数に取り、インストール済みのスクリプトから取得して実行します。
# スクリプトが存在する場所について環境変数PATHを通さずに実行することを目的としています。
# Parameters:
#    [string] $scriptName 呼び出したいスクリプトのファイル名（拡張子を除く）
function Invoke-PowerShellScript {
    param (
        [string]$scriptName
    )
    $script = Get-installedScript -name $scriptName
    if (-not $script) {
        Write-Host "$scriptName script is not installed. Please install it first." -ForegroundColor Red
        return
    }
    $scriptDir = $script.installedLocation
    $scriptPath = Join-Path -Path $scriptDir -ChildPath "$scriptName.ps1"
    if (Test-Path $scriptPath) {
        & $scriptPath @args
    } else {
        Write-Host "Script not found: $scriptPath" -ForegroundColor Red
    }
}

# yadmスクリプトの実行。
function yadm {
    Invoke-PowerShellScript -scriptName "yadm" @args
}

if (Is-Command-Exists starship) {
    Invoke-Expression (&starship init powershell)
}

### mise start
if (Is-Command-Exists Is-Command-Found mise) {
    $env:MISE_SHELL = 'pwsh'
    $env:__MISE_ORIG_PATH = $env:PATH

    function mise {
        # Read line directly from input to workaround powershell input parsing for functions
        $code = [System.Management.Automation.Language.Parser]::ParseInput($MyInvocation.Statement.Substring($MyInvocation.OffsetInLine - 1), [ref]$null, [ref]$null)
        $myLine = $code.Find({ $args[0].CommandElements }, $true).CommandElements | ForEach-Object { $_.ToString() } | Join-String -Separator ' '
        $command, [array]$arguments = Invoke-Expression ('Write-Output -- ' + $myLine)

        if ($null -eq $arguments) {
            & C:\Users\toyos\AppData\Local\Microsoft\WinGet\Links\mise.exe
            return
        }

        $command = $arguments[0]
        $arguments = $arguments[1..$arguments.Length]

        if ($arguments -contains '--help') {
            return & C:\Users\toyos\AppData\Local\Microsoft\WinGet\Links\mise.exe $command $arguments
        }

        switch ($command) {
            { $_ -in 'deactivate', 'shell', 'sh' } {
                if ($arguments -contains '-h' -or $arguments -contains '--help') {
                    & C:\Users\toyos\AppData\Local\Microsoft\WinGet\Links\mise.exe $command $arguments
                }
                else {
                    & C:\Users\toyos\AppData\Local\Microsoft\WinGet\Links\mise.exe $command $arguments | Out-String | Invoke-Expression -ErrorAction SilentlyContinue
                }
            }
            default {
                & C:\Users\toyos\AppData\Local\Microsoft\WinGet\Links\mise.exe $command $arguments
                $status = $LASTEXITCODE
                if ($(Test-Path -Path Function:\_mise_hook)){
                    _mise_hook
                }
                # Pass down exit code from mise after _mise_hook
                pwsh -NoProfile -Command exit $status
            }
        }
    }

    function Global:_mise_hook {
        if ($env:MISE_SHELL -eq "pwsh"){
            & C:\Users\toyos\AppData\Local\Microsoft\WinGet\Links\mise.exe hook-env $args -s pwsh | Out-String | Invoke-Expression -ErrorAction SilentlyContinue
        }
    }

    function __enable_mise_chpwd{
        if (-not $__mise_pwsh_chpwd){
            $Global:__mise_pwsh_chpwd= $true
            $_mise_chpwd_hook = [EventHandler[System.Management.Automation.LocationChangedEventArgs]] {
                param([object] $source, [System.Management.Automation.LocationChangedEventArgs] $eventArgs)
                end {
                    _mise_hook
                }
            };
            $__mise_pwsh_previous_chpwd_function=$ExecutionContext.SessionState.InvokeCommand.LocationChangedAction;

            if ($__mise_original_pwsh_chpwd_function) {
                $ExecutionContext.SessionState.InvokeCommand.LocationChangedAction = [Delegate]::Combine($__mise_pwsh_previous_chpwd_function, $_mise_chpwd_hook)
            }
            else {
                $ExecutionContext.SessionState.InvokeCommand.LocationChangedAction = $_mise_chpwd_hook
            }
        }
    }
    __enable_mise_chpwd
    Remove-Item -ErrorAction SilentlyContinue -Path Function:/__enable_mise_chpwd

    function __enable_mise_prompt {
        if (-not $__mise_pwsh_previous_prompt_function){
            $Global:__mise_pwsh_previous_prompt_function=$function:prompt
            function global:prompt {
                if (Test-Path -Path Function:\_mise_hook){
                    _mise_hook
                }
                & $__mise_pwsh_previous_prompt_function
            }
        }
    }
    __enable_mise_prompt
    Remove-Item -ErrorAction SilentlyContinue -Path Function:/__enable_mise_prompt

    _mise_hook
    if (-not $__mise_pwsh_command_not_found){
        $Global:__mise_pwsh_command_not_found= $true
        function __enable_mise_command_not_found {
            $_mise_pwsh_cmd_not_found_hook = [EventHandler[System.Management.Automation.CommandLookupEventArgs]] {
                param([object] $Name, [System.Management.Automation.CommandLookupEventArgs] $eventArgs)
                end {
                    if ([Microsoft.PowerShell.PSConsoleReadLine]::GetHistoryItems()[-1].CommandLine -match ([regex]::Escape($Name))) {
                        if (& C:\Users\toyos\AppData\Local\Microsoft\WinGet\Links\mise.exe hook-not-found -s pwsh -- $Name){
                            _mise_hook
                            if (Get-Command $Name -ErrorAction SilentlyContinue){
                                $EventArgs.Command = Get-Command $Name
                                $EventArgs.StopSearch = $true
                            }
                        }
                    }
                }
            }
            $current_command_not_found_function = $ExecutionContext.SessionState.InvokeCommand.CommandNotFoundAction
            if ($current_command_not_found_function) {
                $ExecutionContext.SessionState.InvokeCommand.CommandNotFoundAction = [Delegate]::Combine($current_command_not_found_function, $_mise_pwsh_cmd_not_found_hook)
            }
            else {
                $ExecutionContext.SessionState.InvokeCommand.CommandNotFoundAction = $_mise_pwsh_cmd_not_found_hook
            }
        }
        __enable_mise_command_not_found
        Remove-Item -ErrorAction SilentlyContinue -Path Function:/__enable_mise_command_not_found
    }
}
### mise end

### uutils start
@"
  arch, base32, base64, basename, cat, cksum, comm, cp, cut, date, df, dircolors, dirname,
  echo, env, expand, expr, factor, false, fmt, fold, hashsum, head, hostname, join, link, ln, ls,
  md5sum, mkdir, mktemp, more, mv, nl, nproc, od, paste, printenv, printf, ptx, pwd,
  readlink, realpath, relpath, rm, rmdir, seq, sha1sum, sha224sum, sha256sum, sha3-224sum,
  sha3-256sum, sha3-384sum, sha3-512sum, sha384sum, sha3sum, sha512sum, shake128sum,
  shake256sum, shred, shuf, sleep, sort, split, sum, sync, tac, tail, tee, test, touch, tr,
  true, truncate, tsort, unexpand, uniq, wc, whoami, yes
"@ -split ',' |
ForEach-Object { $_.trim() } |
Where-Object { ! @('tee', 'sort', 'sleep').Contains($_) } |
ForEach-Object {
    $cmd = $_
    if (Test-Path Alias:$cmd) { Remove-Item -Path Alias:$cmd }
    $fn = '$input | ~\.cargo\bin\coreutils ' + $cmd + ' $args'
    Invoke-Expression "function global:$cmd { $fn }"
}
### uutils end


Set-Alias -Name "which" -Value "Get-Command"
