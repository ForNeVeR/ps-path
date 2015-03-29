$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
$AddPath = "$here\$sut"

Describe "Add-Path" {
    It "does not adds items twice" {
        $drive = Get-PSDrive | ? { $_.Provider.Name -eq 'FileSystem' } | Select-Object -First 1
        $randomName = "${drive}:\$([Guid]::NewGuid())"

        $oldPath = $env:PATH
        & $AddPath -CurrentUser $randomName
        & $AddPath -CurrentUser $randomName
        $newPath = $env:PATH

        $count = ($newPath.Split([IO.Path]::PathSeparator) | ? { $_ -eq $randomName }).Count
        $count | Should BeExactly 1
    }
}
