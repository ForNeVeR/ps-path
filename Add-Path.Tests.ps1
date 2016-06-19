$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
$AddPath = "$here\$sut"
$GetPath = "$here/Get-Path"

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

    It "should also add the path to the current process if the change is permanent" {
        $drive = Get-PSDrive | ? { $_.Provider.Name -eq 'FileSystem' } | Select-Object -First 1
        $randomName = "${drive}:\$([Guid]::NewGuid())"

        $oldPath = $env:PATH
        & $AddPath -CurrentUser -Permanent $randomName
        $newPath = $env:PATH

        $items = & $GetPath
        $contains = $items -contains $randomName
        $contains | Should BeExactly $true
    }

    It "should prepend the path when asked" {
        $drive = Get-PSDrive | ? { $_.Provider.Name -eq 'FileSystem' } | Select-Object -First 1
        $randomName = "${drive}:\$([Guid]::NewGuid())"

        $oldPath = $env:PATH
        & $AddPath $randomName -CurrentUser -Prepend
        $newPath = $env:PATH

        $newPath | Should BeExactly "$randomName$([IO.Path]::PathSeparator)$oldPath"
    }
}
