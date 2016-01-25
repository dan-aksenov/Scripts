$src = "d:\Users\Данила\Pictures\Мои фотографии"
$dst = "K:\Мои документы"

$src1 = get-childitem -recurse -path $scr
$dst1 = get-childitem -recurse -path $dst

compare-object -referenceobject $src1 -differenceobject $dst1
