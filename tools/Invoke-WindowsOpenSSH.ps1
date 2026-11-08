#Requires -Version 7.3
[CmdletBinding(DefaultParameterSetName = 'Check')]
param(
    [Parameter(Mandatory, ParameterSetName = 'Connect')]
    [ValidatePattern('\A[A-Za-z0-9][A-Za-z0-9._-]*\z')]
    [string] $HostAlias,

    [Parameter(Mandatory, ParameterSetName = 'Connect')]
    [ValidateNotNullOrEmpty()]
    [string] $RemoteCommand
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $false

if (-not $IsWindows) {
    throw 'Run this script from PowerShell on Windows.'
}

$systemDirectory = [Environment]::SystemDirectory
if ([Environment]::Is64BitOperatingSystem -and -not [Environment]::Is64BitProcess) {
    $systemDirectory = Join-Path $env:SystemRoot 'Sysnative'
}
$client = Join-Path $systemDirectory 'OpenSSH\ssh.exe'
if (-not (Test-Path -LiteralPath $client -PathType Leaf)) {
    throw 'The Windows OpenSSH Client optional feature is required.'
}

$originalProgramData = $env:ProgramData
try {
    if ([string]::IsNullOrWhiteSpace($originalProgramData)) {
        $env:ProgramData = [Environment]::GetFolderPath('CommonApplicationData')
        if ([string]::IsNullOrWhiteSpace($env:ProgramData)) {
            throw 'Windows did not provide a common application data path.'
        }
    }

    $options = @(
        '-n', '-T', '-x', '-S', 'none',
        '-o', 'BatchMode=yes',
        '-o', 'StrictHostKeyChecking=yes',
        '-o', 'ForwardAgent=no',
        '-o', 'ClearAllForwardings=yes',
        '-o', 'PermitLocalCommand=no',
        '-o', 'UpdateHostKeys=no',
        '-o', 'ConnectTimeout=10'
    )

    if ($PSCmdlet.ParameterSetName -eq 'Connect') {
        & $client @options -- $HostAlias $RemoteCommand
        exit $LASTEXITCODE
    }

    $version = (& $client -V 2>&1 | Out-String).Trim()
    if ($LASTEXITCODE -ne 0 -or $version -notmatch '^OpenSSH_for_Windows_') {
        throw 'The Windows OpenSSH version check failed.'
    }

    $config = & $client -F NUL -G @options -- openssh-check.invalid 2>$null
    if ($LASTEXITCODE -ne 0 -or
        $config -notcontains 'batchmode yes' -or
        $config -notcontains 'forwardagent no' -or
        $config -notcontains 'clearallforwardings yes' -or
        ($config -notcontains 'stricthostkeychecking true' -and $config -notcontains 'stricthostkeychecking yes')) {
        throw 'The offline Windows OpenSSH configuration check failed.'
    }

    [pscustomobject]@{
        Status = 'OPENSSH_CLIENT_OK'
        Version = $version
        Client = $client
    } | ConvertTo-Json -Compress
} finally {
    $env:ProgramData = $originalProgramData
}
