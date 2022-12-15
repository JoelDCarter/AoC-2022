param ([int] $length = 2)
$ropeX = @([int]0) * $length
$ropeY = @([int]0) * $length
$tail = 0
$tailTrail = @{ "0,0" = $true }
foreach ($line in [System.IO.File]::ReadLines((Resolve-Path ".\input.txt").Path)) {
    $direction, $distance = $line -split ' '
    $distance = [int]$distance
    switch ($direction) {
        'L' { $stepX = -1; $stepY =  0 }
        'R' { $stepX =  1; $stepY =  0 }
        'U' { $stepX =  0; $stepY =  1 }
        'D' { $stepX =  0; $stepY = -1 }
    }
    for ($i = 0; $i -lt $distance; $i++) {
        $tail++
        if ($tail -eq $length) { $tail = $length - 1 }
        $ropeX[0] += $stepX
        $ropeY[0] += $stepY
        for ([int]$j = 1; $j -le $tail; $j++) {
            $deltaX = $ropeX[$j - 1] - $ropeX[$j]
            $deltaY = $ropeY[$j - 1] - $ropeY[$j]    
            if ([Math]::Abs($deltaX) -gt 1 -and [Math]::Abs($deltaY) -eq 1) { 
                $ropeY[$j] += [Math]::Sign($deltaY)
            } elseif ([Math]::Abs($deltaY) -gt 1 -and [Math]::Abs($deltaX) -eq 1) {
                $ropeX[$j] += [Math]::Sign($deltaX)
            } 
            if ([Math]::Abs($deltaX) -gt 1) { $ropeX[$j] += [Math]::Sign($deltaX) }
            if ([Math]::Abs($deltaY) -gt 1) { $ropeY[$j] += [Math]::Sign($deltaY) }    
        }
        $tailTrail["$($ropeX[$tail]),$($ropeY[$tail])"] = $true    
    }
}
$tailTrail.Count