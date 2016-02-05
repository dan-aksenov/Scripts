param(
  [string]$file
)

$date=get-date -format d

(Get-Content $file) | Foreach-Object { 
$_ -replace ("^log\\"), ("")
}| Set-Content $file

(Get-Content $file) | Foreach-Object { 
$_ -replace (".log:"), ("")
}| Set-Content $file

(Get-Content $file) | Foreach-Object { 
$_ -replace ("`c:"), ("`"c:")
}| Set-Content $file

(Get-Content $file) | Foreach-Object { 
$_ -replace ("$"), ("`"")
}| Set-Content $file

(Get-Content $file) | Foreach-Object { 
$_ -replace ("New File"), ("New_File")
}| Set-Content $file

(Get-Content $file) | Foreach-Object { 
$_ -replace ("named File"), ("named_File")
}| Set-Content $file

(Get-Content $file) | Foreach-Object { 
$_ + " " + $date
}| Set-Content $file

(Get-Content $file) | Foreach-Object { 
$_ -replace ("`\\\\"), ("`"")
}| Set-Content $file
