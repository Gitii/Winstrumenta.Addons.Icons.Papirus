param(
     [Parameter()]
     [string]$Version
 )

# Copy some stuff into package folder
Copy-Item .\mapping.csv,.\icons.zip -Destination .\Package\Assets
Copy-Item .\README.md,.\LICENSE -Destination .\Package

$(Get-Content .\AppxManifest.xml.template -Encoding utf8 -Raw) -Replace "Version=`"1.0.0.0`"","Version=`"$Version.0`"" | Out-File .\Package\AppxManifest.xml -Encoding utf8

# cleanup old package 
Remove-Item .\Addon.msix -ErrorAction SilentlyContinue

# build new package
MakeAppx pack /d ./Package /p Addon.msix

# and sign it
signtool.exe sign /fd SHA256 /td SHA256 /sha1 "102EE732156FA0872B3A0697F4A78767C8EFB3B3" /tr http://timestamp.digicert.com Addon.msix