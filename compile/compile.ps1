param ($n)
$absPath = Resolve-Path -Path "./"
divine -a create-package -g bg3 -s "$absPath/mod" -d "$absPath/compile/files/$n.pak" -c lz4;
Compress-Archive -Path "$absPath/compile/files/$n.pak" -DestinationPath "$absPath/compile/files/$n.zip" -Force