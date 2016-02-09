$file = get-Content server.txt
$jobs = foreach ($srv in $file) {
    
    Start-Job -Name "dirstatb $srv" -ArgumentList $srv -ScriptBlock {
      param($srv)
$ips = [System.Net.Dns]::GetHostAddresses($srv)
$out= "c:\repl\soft\dir_sizes\log\DIRS_$srv.log"
net use \\$ips\tii /user:name password

dir \\$ips\somedir -rec -Exclude('.log')| Measure-Object -property length -sum | ft @{Label="SERVER";Expression={$srv}}, Count,@{Label="SIZE";Expression={$_.sum/1mb -as [int]}}, @{Label="DT_COLLECT";Expression={get-date}} -hidetableheaders | out-file -filepath $out

net use \\$ips\somedir /delete /YES


   }
}

$jobs | Wait-Job
$jobs | Receive-Job

cat log\DIRS*.log > log\DIRS.log
(gc log\DIRS.log) | ? {$_.trim() -ne "" } | set-content log\BYTDIRS.log

exit