param (
    [string] $InputFile
)

$elf = 1
$calories = 0
foreach($line in [System.IO.File]::ReadLines((Resolve-Path $InputFile).Path))
{
    if ([System.String]::IsNullOrWhiteSpace($line)) {
        Write-Output ([PSCustomObject]@{
            Elf = $elf
            Calories = $calories
        })
        
        $elf++
        $calories = 0
    } else {
        $calories += [int]$line
    }
}
