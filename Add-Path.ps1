param(
	[Parameter(Mandatory = $true, Position = 0)]
	[string[]] $Paths,

	[switch] $Permanent,
	[switch] $CurrentUser
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

$currentPath = [Environment]::GetEnvironmentVariable("Path", $target)
$existingPaths = $currentPath.Split([IO.Path]::PathSeparator)
$paths = $paths | ? { -not ($_ -in $existingPaths) }
if ($paths) {
    $addedPaths = [String]::Join(';', $paths)
    $newPath = "$currentPath;$addedPaths"
    [Environment]::SetEnvironmentVariable("Path", $newPath, $target)
}

if ($Permanent) {
    & $PSCommandPath $Paths -CurrentUser
}
