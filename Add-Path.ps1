param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string[]] $Paths,

    [switch] $Permanent,
    [switch] $CurrentUser,
    [switch] $Prepend
)

$ErrorActionPreference = 'Stop'

if (-not $Permanent -and -not $CurrentUser) {
    throw "Non-permanent changes are always user-specific. You should specify at least one of -Permanent and -CurrentUser switches."
} elseif (-not $Permanent -and $CurrentUser) {
    $target = [EnvironmentVariableTarget]::Process
} elseif ($Permanent -and -not $CurrentUser) {
    $target = [EnvironmentVariableTarget]::Machine
} elseif ($Permanent -and $CurrentUser) {
    $target = [EnvironmentVariableTarget]::User
}

$paths = $Paths | % {
    $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($_)
}

$separator = [IO.Path]::PathSeparator
$currentPath = [Environment]::GetEnvironmentVariable("Path", $target)
$existingPaths = $currentPath.Split($separator)
$paths = $paths | ? { -not ($_ -in $existingPaths) }
if ($paths) {
    $addedPaths = [String]::Join($separator, $paths)
    $newPath =
        if ($Prepend) {
            "$addedPaths$separator$currentPath"
        } else {
            "$currentPath$separator$addedPaths"
        }
    [Environment]::SetEnvironmentVariable("Path", $newPath, $target)
}

if ($Permanent) {
    & $PSCommandPath $Paths -CurrentUser
}
