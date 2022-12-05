$fullyContained = 0
$overlapping = 0
foreach($pair in [System.IO.File]::ReadLines((Resolve-Path ".\input.txt").Path))
{
    $sections = $pair -split ','
    $sections = foreach($section in $sections) {
        $ids = $section -split '-' | % { [int]$_ }
        $list = ""
        for($id = $ids[0]; $id -le $ids[1]; $id++) { $list += [char]($id + 31) }
        $list
    }
    if ($sections[0].Contains($sections[1]) -or $sections[1].Contains($sections[0]) ) {
        $fullyContained++
    }
    $duplicates = $sections[0].ToCharArray() | Where-Object { $sections[1].Contains($_) }
    if ($duplicates.Length -gt 0) { $overlapping++ }
}
$fullyContained
$overlapping