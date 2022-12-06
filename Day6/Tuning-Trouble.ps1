param ([ValidateSet(1,2)] [int] $Part = 1)
$stream = Get-Content .\input.txt
$distinctChars = if ($Part -eq 1) { 4 } else { 14 }
for ($i = 0; $i -lt $stream.Length - $distinctChars; $i++) {
    if (([Linq.Enumerable]::Distinct($stream.Substring($i, $distinctChars)) -join '').Length -eq $distinctChars) { 
        $i + $distinctChars
        break
    }
}