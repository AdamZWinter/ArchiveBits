 param (
    [Parameter(Mandatory=$true)][string]$path,
    [Parameter(Mandatory=$false)][string]$filename,
    [Parameter(Mandatory=$false)][int]$minsize,
    [Parameter(Mandatory=$false)][switch]$newest,
    [Parameter(Mandatory=$false)][switch]$sizeonly
)

#param must be the first line in the script
 
#Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted

$minimum = 0;
if(![string]::IsNullOrEmpty($minsize)){$minimum=$minsize;}

$bigArray = [System.Collections.ArrayList]@();
$bigStringArray = [System.Collections.ArrayList]@();
$directory = '';
$totalSize = 0;

(cmd /c dir $path /c /s /a:a) | ForEach-Object { if( $_ -match '^(\s)(Directory)(\s)(of)(\s)(.*)'){ 
        $directory = $Matches[6];
    } ElseIf ($_ -match '^(\d\d)/(\d\d)/(\d\d\d\d)(\s\s)(\d\d:\d\d)(\s)([AP]M)(\s+)(\S+)(\s)(\S+)') {
        $smallArray = @(0,'init','init', 'init', 'init');
        $smallArray[0] = $Matches[9];
        $smallArray[1] = $Matches[11];
        $smallArray[2] = "$Matches[3]/$Matches[1]/$Matches[2]";
        $smallArray[3] = $Matches[5];
        $smallArray[4] = $directory;
        $totalSize += $Matches[9];

        if($Matches[9] -ge $minimum){
            $reformated = "$($Matches[3])/$($Matches[1])/$($Matches[2])  $($Matches[7])  $($Matches[5])`t$($Matches[9])`t$directory\\$($Matches[11])";
            $null = $bigStringArray.Add($reformated);
            $null = $bigArray.Add($smallArray);
        }else{}
    } Else {} 
}


echo "$totalSize Bytes = sum-total size of files with archive bit set, within given directory and subdirectories of it.";
if($sizeonly){exit;}

$stringsArray = [System.Collections.ArrayList]@();

if(!([string]::IsNullOrEmpty($newest))){
    $stringsArray = $bigStringArray | sort-object -Descending;
}else{
    $sortedArray = $bigArray | sort-object @{Expression={$_[0]}; Descending = $True};
    $null = $stringsArray.Add("Sum-total size of files with archive bit set: $totalSize Bytes");
    For ($i=0; $i -lt $sortedArray.Length; $i++){
        $size = $sortedArray[$i][0];
        $file = $sortedArray[$i][1];
        $date = $sortedArray[$i][2];
        $time = $sortedArray[$i][3];
        $location = $sortedArray[$i][4];
        $null = $stringsArray.Add("$size`t$location\\$file`t`t$date`t$time");
    }
}

if([string]::IsNullOrEmpty($filename)){
    echo 'No filename provided.  Using "results.txt"';
    $filename = 'results.txt';
}else{}

$outputPath = $path+'/'+$filename;
$stringsArray > $outputPath;

