#logging directory
$log_dir="E:\TMP"
#if not exist $log_dir% md $log_dir

#set source
$src=[environment]::getfolderpath("mydocuments")

#set Wdmycloud destination
$dst="\\WDMYCLOUD\danila\!BUPS\Documents"

$log="/unilog:$log_dir\docs_to_mycloud.log"

# get list of diffs
robocopy $src $dst *.* /z /mir /mt /l
pause

robocopy $src $dst *.* $log /tee /z /mir /mt