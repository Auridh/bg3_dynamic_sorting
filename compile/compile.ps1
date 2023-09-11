param ($n)
$modName = "DynamicSorting"
$modHandle = "AuridhDS"
$absPath = Resolve-Path -Path "./"
divine -a convert-loca -g bg3 -s "$absPath/mod/Localization/English/$modName.xml" -d "$absPath/mod/Localization/English/$modName.loca";
divine -a convert-resources -g bg3 -s "$absPath/mod/Public/$modHandle/RootTemplates" -d "$absPath/mod/Public/$modHandle/RootTemplates" -i lsx -o lsf;
divine -a convert-resources -g bg3 -s "$absPath/mod/Public/$modHandle/Content/UI/[PAK]_UI" -d "$absPath/mod/Public/$modHandle/Content/UI/[PAK]_UI" -i lsx -o lsf;
divine -a convert-resources -g bg3 -s "$absPath/mod/Public/$modHandle/GUI" -d "$absPath/mod/Public/$modHandle/GUI" -i lsx -o lsf;
divine -a create-package -g bg3 -s "$absPath/mod" -d "$absPath/compile/files/$n.pak" -c lz4;
Compress-Archive -Path "$absPath/compile/files/$n.pak" -DestinationPath "$absPath/compile/files/$n.zip" -Force