$sum = 0
$count = 0
$group = 1
$groups = New-Object 'object[,]' 2,3
$groupSackCount = 0
$badgeSum = 0
foreach($rucksack in [System.IO.File]::ReadLines((Resolve-Path ".\input.txt").Path))
{
    $count++
    $items = $rucksack.ToCharArray() | ForEach-Object {
        $item = [int][char]$_
        switch ($item) {
            { $_ -ge 65 -and $_ -le 90 } { $_ - 38 }
            { $_ -ge 97 -and $_ -le 122 } { $_ - 96 }
        }
    }

    $groups[($group - 1), $groupSackCount++] = $items
    if ($groupSackCount -gt 2) {
        $badgeSum += ($groups[($group - 1), 0] | Where-Object -FilterScript { $_ -in $groups[($group - 1), 1] -and $_ -in $groups[($group - 1), 2] })[0]
        $groupSackCount = 0
        $group++
        if ($group -gt 2) {
            $group = 1
        }
    }

    $startOfCompartment2 = [int]($items.Length / 2)
    $compartment1 = $items[0..($startOfCompartment2 - 1)]
    $compartment2 = $items[$startOfCompartment2..($items.Length - 1)]
    $commonItem = $compartment1 | Where-Object { $compartment2 -contains $_ }
    $sum += $commonItem[0]
}
@{
    ItemPrioritiesSum = $sum
    BadgePriortiesSum = $badgeSum
}