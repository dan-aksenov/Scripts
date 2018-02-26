#logging directory
$log_dir="E:\TMP"
#if not exist $log_dir% md $log_dir

#set source
$src=[environment]::getfolderpath("mypictures")+"\Мои фотографии"

#set Wdmycloud destination
$dst="Y:/!BUPS/fotos"

$log="/unilog:$log_dir\docs_to_mycloud.log"


net use Y: https://webdav.yandex.ru

# get list of diffs
robocopy $src $dst *.* /z /mir /mt /l
pause

robocopy $src $dst *.* $log /tee /z /mir /mt

net use Y: /delete