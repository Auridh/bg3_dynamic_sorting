param ($n,$addon)
$absPath = Resolve-Path -Path "./"
divine -a convert-loca -g bg3 -s "$absPath/addons/$addon/Localization/English/$addon.xml" -d "$absPath/addons/$addon/Localization/English/$addon.loca";
divine -a convert-resources -g bg3 -s "$absPath/addons/$addon/Public/$addon/RootTemplates" -d "$absPath/addons/$addon/Public/$addon/RootTemplates" -i lsx -o lsf;
divine -a convert-resources -g bg3 -s "$absPath/addons/$addon/Public/$addon/Content/UI/[PAK]_UI" -d "$absPath/addons/$addon/Public/$addon/Content/UI/[PAK]_UI" -i lsx -o lsf;
divine -a convert-resources -g bg3 -s "$absPath/addons/$addon/Public/$addon/GUI" -d "$absPath/addons/$addon/Public/$addon/GUI" -i lsx -o lsf;
divine -a create-package -g bg3 -s "$absPath/addons/$addon" -d "$absPath/compile/files/$n.pak" -c lz4;
Compress-Archive -Path "$absPath/compile/files/$n.pak" -DestinationPath "$absPath/compile/files/$n.zip" -Force