param ($n)
$absPath = Resolve-Path -Path "./"

# bump build version (Version.lua)
(Get-Content "$absPath/mod/Mods/AuridhDS/ScriptExtender/Lua/Version.lua") `
    -replace '(Build =) (\d*)',{ '{0}' -f $_.Groups[1].Value + ' ' + ([int]$_.Groups[2].Value + 1) } `
    -replace '(\d*\.\d*\.\d*\.)(\d*)',{ '{0}' -f $_.Groups[1].Value + ([int]$_.Groups[2].Value + 1) } `
| Set-Content "$absPath/mod/Mods/AuridhDS/ScriptExtender/Lua/Version.lua"
# (meta.lsx)
(Get-Content "$absPath/mod/Mods/AuridhDS/meta.lsx") `
    -replace '((?<! ) {20}<attribute id="Version" type="int64" value=")(\d*)("\/>)',{ '{0}' -f $_.Groups[1].Value + ([long]$_.Groups[2].Value + 1) + $_.Groups[3].Value } `
| Set-Content "$absPath/mod/Mods/AuridhDS/meta.lsx"

# loop localization files
$locaFiles = Get-ChildItem "$absPath/mod/Localization/" -Filter *.loca -File -Recurse
foreach ($f in $locaFiles) {
    divine -a convert-loca -g bg3 -s $f.FullName -d "$(join-path $f.DirectoryName $f.BaseName).loca"
}
# loop lsx files
$lsxFiles = Get-ChildItem "$absPath/mod/Public" -Filter *.lsx -File -Recurse
foreach ($f in $lsxFiles) {
    divine -a convert-resource -g bg3 -s $f.FullName -d "$(join-path $f.DirectoryName $f.BaseName).lsf"
}

divine -a create-package -g bg3 -s "$absPath/mod" -d "$absPath/compile/files/$n.pak" -c lz4
Compress-Archive -Path "$absPath/compile/files/$n.pak" -DestinationPath "$absPath/compile/files/$n.zip" -Force