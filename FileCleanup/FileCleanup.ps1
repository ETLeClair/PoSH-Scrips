#Delete's logs older than 2 months old (This can be changed on line 6)
#Can be run at a frequency per task scheduler
#Looks at commandline arguments for directory


$CutoffDate = (Get-Date).AddMonths(-2)

$directory = $args[0]

Get-ChildItem $directory | Select-Object Name,CreationTime | Export-CSV C:\Scripts\temp.csv

$csv = Import-CSV C:\Scripts\temp.csv 
$cdates = @()
$cnames = @()
$cnamesprocessed = @()


foreach($line in $csv)
{
     $cdates = $cdates + $line.CreationTime
     $cnames = $cnames + $line.Name
}

for ($i=0; $i -lt $cdates.length; $i++) {
    if ((get-date $cdates[$i]) -lt $CutoffDate) {
        $cnamesprocessed += $cnames[$i]
    }
}

cd $directory
for ($j = 0; $j -lt $cnamesprocessed.length; $j++) {
    Remove-Item $cnamesprocessed[$j] 
}
