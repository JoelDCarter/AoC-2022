param (
    [ValidateSet(1,2)] [int] $Part = 1
)
$crates = @{}
$moveCrates = $false
foreach ($line in [System.IO.File]::ReadLines((Resolve-Path ".\input.txt").Path)) {
    if ([string]::IsNullOrWhiteSpace($line)) {
        $moveCrates = $true
    }
    if ($moveCrates) {
        $moves = Select-String "move (\d+) from (\d+) to (\d+)" -inputobject $line
        if ($moves.Matches.Count -gt 0) {
            $from = [int]$moves.Matches.Groups[2].Value
            $to = [int]$moves.Matches.Groups[3].Value
            for([int]$i = $moves.Matches.Groups[1].Value; $i -gt 0; $i--) {
                switch ($Part) {
                    { 1 } { $index = [int]$crates[$from].Count - 1 }
                    { 2 } { $index = [int]$crates[$from].Count - $i }
                }
                $crates[$to].Add($crates[$from][$index])
                $crates[$from].RemoveAt($index)
            }
        }
    } else {
        $cratesRaw = Select-String "(?:\s?\[(\w)\])" -inputobject $line -AllMatches
        for ([int]$i = 1; $i -le $cratesRaw.Matches.Count; $i++) {
            $to = [int](($cratesRaw.Matches[$i - 1].Groups[1].Index - 1) / 4 + 1)
            if ($crates[$to] -eq $null) {
                $crates[$to] = [System.Collections.ArrayList]@()
            }
            $crates[$to].Insert(0, $cratesRaw.Matches[$i - 1].Groups[1].Value)
        }
    }
}
$message = ""
for ([int]$i = 1; $i -le $crates.Count; $i++) {
    $end = [int]$crates[$i].Count - 1
    $message += $crates[$i][$end]
}
$message
