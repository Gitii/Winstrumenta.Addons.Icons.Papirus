Remove-Item .\Addon.msix -ErrorAction SilentlyContinue

MakeAppx pack /d ./Package /p Addon.msix
signtool.exe sign /fd SHA256 /td SHA256 /sha1 "102EE732156FA0872B3A0697F4A78767C8EFB3B3" /tr http://timestamp.digicert.com Addon.msix