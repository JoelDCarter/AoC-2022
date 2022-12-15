$size = 1;
$row = @{}
$maxFromTop = @{}
$maxFromLeft = @{}
$maxFromRight = @{}
$maxFromBottom = @{}
$visible = @{}

foreach ($line in [System.IO.File]::ReadLines((Resolve-Path ".\input.txt").Path)) {
    $row[$size] =  " $line"
    if ($size -eq 1) {
        $maxFromLeft[$size] = $row[$size][1]
        $maxFromRight[$size] = $row[$size][$line.Length]
    }
    for ($i = 1; $i -le $line.Length; $i++) {
        if ($size -eq 1) {
            $visible["$i,1"] = 0
            $maxFromTop[$i] = $row[$size][$i]
        } elseif ($size -eq $line.Length) {
            $visible["$i,$size"] = 0
            $maxFromBottom[$i] = $row[$size][$i]
        } elseif ($i -eq 1) {
            $visible["1,$size"] = 0
            $maxFromLeft[$size] = $row[$size][1]
            $maxFromRight[$size] = $row[$size][$line.Length]
            $visible["$($line.Length),$size"] = 0
        } else {
            if ($row[$size][$i] -gt $maxFromTop[$i]) {
                $maxFromTop[$i] = $row[$size][$i]
                $visible["$i,$size"] = 0
            }
            if ($row[$size][$i] -gt $maxFromLeft[$size]) {
                $maxFromLeft[$size] = $row[$size][$i]
                $visible["$i,$size"] = 0
            }
            if ($row[$size][$line.Length + 1 - $i] -gt $maxFromRight[$size]) {
                $maxFromRight[$size] = $row[$size][$line.Length + 1 - $i]
                $visible["$($line.Length + 1 - $i),$size"] = 0
            }
        }
    }
    $size++
}
for ($j = $size - 1; $j -gt 1; $j--) {
    for ($i = 2; $i -lt $size; $i++) {
        if ($row[$j - 1][$i] -gt $maxFromBottom[$i]) {
            $maxFromBottom[$i] = $row[$j - 1][$i]
            $visible["$i,$($j - 1)"] = 0
        }
    }
}
$visible.Count

# step through each tree
for ($i = 1; $i -lt $size; $i++) {
    for ($j = 1; $j -lt $size; $j++) {
        $visibleUp = $visibleDown = $visibleLeft = $visibleRight = 0
        $height = $row[$j][$i]
        # search right
        for ($x = $i + 1; $x -lt $size; $x++) {
            $visibleRight++
            if ($row[$j][$x] -ge $height) { break }
        }
        # search left
        for ($x = $i - 1; $x -ge 1; $x--) {
            $visibleLeft++
            if ($row[$j][$x] -ge $height) { break }
        }
        # search up
        for ($y = $j - 1; $y -ge 1; $y--) {
            $visibleUp++
            if ($row[$y][$i] -ge $height) { break }
        }
        #search down
        for ($y = $j + 1; $y -lt $size; $y++) {
            $visibleDown++
            if ($row[$y][$i] -ge $height) { break }
        }
        $visible["$i,$j"] = $visibleUp * $visibleDown * $visibleLeft * $visibleRight
    }
}
$visible.Keys | Sort-Object { $visible[$_] } -Descending | Select-Object -First 1 | ForEach-Object { "$_`: $($visible[$_])" }
