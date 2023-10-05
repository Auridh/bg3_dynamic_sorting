param ($m)

function CompileMod {
    param ($AbsPath,$Handle,$Output,$Branch)

    git checkout $Branch

    # bump build version (Version.lua)
    (Get-Content "$AbsPath/Mods/$Handle/ScriptExtender/Lua/Version.lua") `
        -replace '(Build =) (\d*)',{ '{0}' -f $_.Groups[1].Value + ' ' + ([int]$_.Groups[2].Value + 1) } `
        -replace '(\d*\.\d*\.\d*\.)(\d*)',{ '{0}' -f $_.Groups[1].Value + ([int]$_.Groups[2].Value + 1) } `
        | Set-Content "$AbsPath/Mods/$Handle/ScriptExtender/Lua/Version.lua"
    # (meta.lsx)
    (Get-Content "$AbsPath/Mods/$Handle/meta.lsx") `
        -replace '((?<! ) {20}<attribute id="Version" type="int64" value=")(\d*)("\/>)',{ '{0}' -f $_.Groups[1].Value + ([long]$_.Groups[2].Value + 1) + $_.Groups[3].Value } `
        | Set-Content "$AbsPath/Mods/$Handle/meta.lsx"

    # loop localization files
    $locaFiles = Get-ChildItem "$AbsPath/Localization/" -Filter *.xml -File -Recurse
    foreach ($f in $locaFiles) {
        divine -a convert-loca -g bg3 -s $f.FullName -d "$(join-path $f.DirectoryName $f.BaseName).loca"
    }
    # loop lsx files
    $lsxFiles = Get-ChildItem "$AbsPath/Public" -Filter *.lsx -File -Recurse
    foreach ($f in $lsxFiles) {
        divine -a convert-resource -g bg3 -s $f.FullName -d "$(join-path $f.DirectoryName $f.BaseName).lsf"
    }

    divine -a create-package -g bg3 -s "$AbsPath/" -d "$Output.pak" -c lz4
    Compress-Archive -Path "$Output.pak" -DestinationPath "$Output.zip" -Force
    Remove-Item -Path "$Output.pak"
}

$workingDir = Resolve-Path -Path "./"
$config = Get-Content "$workingDir/compile/config.json" -Raw -Encoding "UTF8" | ConvertFrom-Json -AsHashtable

if ($m -eq "all") {
    $mods = $config.keys
} else {
    $mods = $m -split ";"
}

foreach ($mod in $mods) {
    $modInfo = $mod -split ":"
    $modKey = $modInfo[0]
    $modVersion = $modInfo.Length -eq 1 ? $null : $modInfo[1]

    $modConfig = $config[$modKey]
    $branch = $modVersion -ne $null ? $modConfig.versions[$modVersion].branch : $modConfig.versions.main.branch
    $output = "$workingDir/compile/files/$($modConfig.pakName)"

    CompileMod -AbsPath "$workingDir/$($modConfig.path)" -Handle $modConfig.handle -Output $output -Branch $branch
}
