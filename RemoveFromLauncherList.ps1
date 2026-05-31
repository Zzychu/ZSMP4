$path = "$env:APPDATA\.minecraft\launcher_profiles.json"
$json = Get-Content $path | ConvertFrom-Json
$json.profiles.PSObject.Properties.Remove('ZSMP4')
$json | ConvertTo-Json -Depth 100 | Set-Content $path
