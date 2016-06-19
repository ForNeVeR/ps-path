PowerShell path extensions [![Status Ventis][status-ventis]][andivionian-status-classifier] [![Build status][build-status]][appveyor]
==========================

Current version: **0.2**.

Synopsis
--------

`ps-path` is a set of PowerShell functions for managing the `Path` environment
variable.

Currently, there are two functions: `Get-Path` and `Add-Path`.

Usage
-----

### Get-Path

`Get-Path` command returns list of paths for current process.

### Add-Path

Syntax:

    Add-Path [-Paths] paths [-Permanent] [-CurrentUser]

`paths` may be single path or string array.

Permanent changes may be global for machine (default) or local for current user.

Testing
-------

Install [Pester][pester] and execute `Invoke-Pester` in the package directory.
Please note that some of the tests may add items to your `Path` as a registry
setting, so you may need to remove it manually.

[andivionian-status-classifier]: https://github.com/ForNeVeR/andivionian-status-classifier#status-ventis-
[appveyor]: https://ci.appveyor.com/project/ForNeVeR/ps-path/branch/develop
[pester]: https://github.com/pester/Pester

[build-status]: https://ci.appveyor.com/api/projects/status/lvtnv59y27of6r52/branch/develop?svg=true
[status-ventis]: https://img.shields.io/badge/status-ventis-yellow.svg
