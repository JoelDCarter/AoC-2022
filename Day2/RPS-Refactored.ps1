param(
    [ValidateSet(1,2)] [int] $Part = 1,
    [ValidateSet("Player1", "Player2", "Both")] [string] $Score = "Player2"
)

$map = @{
    A = 0
    B = 1
    C = 2
    X = { param($play) switch($Part) { 1 { 0 } 2 { switch($play) { 0 { 2 } 1 { 0 } 2 { 1 } } } } }
    Y = { param($play) switch($Part) { 1 { 1 } 2 { switch($play) { 0 { 0 } 1 { 1 } 2 { 2 } } } } }
    Z = { param($play) switch($Part) { 1 { 2 } 2 { switch($play) { 0 { 1 } 1 { 2 } 2 { 0 } } } } }
}
$scoreMatrix = New-Object 'object[,]' 3,3
$scoreMatrix[0, 0] = @((1 + 3), (1 + 3))
$scoreMatrix[0, 1] = @((1 + 0), (2 + 6))
$scoreMatrix[0, 2] = @((1 + 6), (3 + 0))
$scoreMatrix[1, 0] = @((2 + 6), (1 + 0))
$scoreMatrix[1, 1] = @((2 + 3), (2 + 3))
$scoreMatrix[1, 2] = @((2 + 0), (3 + 6))
$scoreMatrix[2, 0] = @((3 + 0), (1 + 6))
$scoreMatrix[2, 1] = @((3 + 6), (2 + 0))
$scoreMatrix[2, 2] = @((3 + 3), (3 + 3))

$rounds = foreach($line in [System.IO.File]::ReadLines((Resolve-Path ".\input.txt").Path))
{
    $round = $line -split " "
    $player1 = $map[$round[0]]
    $player2 = &($map[$round[1]]) -play $player1
    $scores = $scoreMatrix[$player1, $player2]
    $result = [PSCustomObject]@{
        Player1 = $scores[0]
        Player2 = $scores[1]
    }
    $result
}

if ($Score -eq "Both") {
    $Score = "Player1", "Player2"
}

$rounds | Measure-Object -Property $Score -Sum