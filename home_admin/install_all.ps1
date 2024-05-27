Get-ChildItem "." -Filter *.exe | 
Foreach-Object {
    Start-Process -FilePath $_.FullName -ArgumentList '/silent', '/install' -Wait
}