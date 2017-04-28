#logging directory
$log_dir="e:\tmp"

if(!(Test-Path -Path $log_dir )){
    New-Item -ItemType directory -Path $log_dir
}

#set source
$src=[environment]::getfolderpath("myvideos")

# set Wdmycloud destination
# check folder name!
$dst="\\WDMYCLOUD\danila\!BUPS\Videos"

$log="/unilog:$log_dir\video_to_mycloud.log"

# get list of diffs
robocopy $src $dst *.* /z /mir /mt /l
pause

robocopy $src $dst *.* $log /tee /z /mir /mt