param (
    [switch] $ShowWork
)

# Part 1 & 2 - Calculate and display top 3 elves sorted descending by total calories
$top3 = .\Get-Calorie-Counts .\calories.txt `
        | Sort-Object -Property Calories -Descending `
        | Select-Object -First 3
Write-Host "Top 3 Elves"
Format-Table -InputObject $top3
        
# Part 2 - Display total calories carried by top 3 elves
Write-Host "Total Calories of Top 3 Elves: $(($top3 | Measure-Object -Property Calories -Sum).Sum)`n"

# Extra Credit! Run ".\Get-Elf-Stats -ShowWork" (no quotes) to show the intermediate steps
if ($ShowWork) {
    # Show York Work? Ok...
    # Calculate and display all elf calorie totals
    $caloriesPerElf = .\Get-Calorie-Counts .\calories.txt
    Write-Host "Calories per Elf"
    Format-Table -InputObject $caloriesPerElf

    # Display all elves sorted descending by total calories
    $caloriesPerElfDescending = $caloriesPerElf | Sort-Object -Property Calories -Descending
    Write-Host "Calories per Elf, Sorted Descending"
    Format-Table -InputObject $caloriesPerElfDescending
}