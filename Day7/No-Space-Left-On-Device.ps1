$cwd = "/"
$size = @{}
foreach ($line in [System.IO.File]::ReadLines((Resolve-Path ".\input.txt").Path)) {
    switch -Regex ($line) {
        '^\$ cd (\w+)$'          { $cwd = "${cwd}$(if ($cwd -ne "/") { "/" })$($matches[1])" }
        '^\$ cd ..$'             { $cwd = (Split-Path $cwd).Replace([IO.Path]::DirectorySeparatorChar, "/") }
        '^\$ ls$'                { if ($size[$cwd] -eq $null) { $size[$cwd] = 0 } }
        '^(\d+|dir)\s([\w\.]+)$' { if ($matches[1] -ne "dir") { $size[$cwd] += [int]$matches[1] } }
    }
}
$stats = @{}
foreach ($dir in $size.Keys) {
    $stats[$dir] = $size[$dir]
    foreach ($subdir in $size.Keys | Where-Object { $_ -ne $dir -and $_.StartsWith($dir) }) {
        $stats[$dir] += $size[$subdir]
    }
}
$stats.Keys | Where-Object { $stats[$_] -le 100000 } | ForEach-Object { $stats[$_] } | Measure-Object -Sum
$stats.Keys | Where-Object { 70000000 - $stats["/"] + $stats[$_] -ge 30000000 } | ForEach-Object { $stats[$_] } | Measure-Object -Minimum