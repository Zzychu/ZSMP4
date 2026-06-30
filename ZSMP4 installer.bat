@echo off
set OriginalDirectory=%appdata%
cd %OriginalDirectory%
rmdir /S /Q UpdateFiles
rmdir /S /Q InstallFiles
rmdir /S /Q tempZSMPInstaller
mkdir tempZSMPInstaller

:info
cls
echo ========================================================================================================================
echo Witam w installatorze ZychuSMP4 sklejonego tasma klejem i dwunastoma butelkami kaucyjnymi
echo 1 - Install [ Instaluje paczke ZSMP4 na komputerze ] 
echo 2 - Update [ Pobiera aktualizacje modow ]
echo 3 - Uninstall [ Odinstalowywuje paczke i resetuje ustawienia ]
echo 4 - EXIT
echo ========================================================================================================================
set /p opcja="Wybierz numer: "
if /i "%opcja%"=="1" goto Install
if /i "%opcja%"=="2" goto Update
if /i "%opcja%"=="3" goto Uninstall

:Install
echo Wybrano install
taskkill /F /IM "Minecraft*"
@REM Odinstalowanie istniejącej paczki
powershell -NoProfile -ExecutionPolicy remotesigned -Command "$path = \"$env:APPDATA\.minecraft\launcher_profiles.json\"; $json = Get-Content $path | ConvertFrom-Json; $json.profiles.PSObject.Properties.Remove('ZSMP4'); $json | ConvertTo-Json -Depth 100 | Set-Content $path"
rmdir /S /Q %appdata%\.minecraft\ZSMP4

rmdir /S /Q InstallFiles
mkdir InstallFiles
cd InstallFiles

@REM Java
curl --ssl-no-revoke -L https://download.oracle.com/java/21/archive/jdk-21.0.10_windows-x64_bin.zip --output zip.zip
tar -xf zip.zip
ren jdk-21.0.10 java


@REM Git stuff
mkdir git
cd git
curl --ssl-no-revoke -L https://github.com/git-for-windows/git/releases/download/v2.54.0.windows.1/MinGit-2.54.0-64-bit.zip --output git.zip
tar -xf git.zip
cd ..
"git/cmd/git.exe" init
"git/cmd/git.exe" config --global core.safecrlf false
"git/cmd/git.exe" config --local core.safecrlf false
"git/cmd/git.exe" clone https://github.com/Zzychu/ZSMP4.git
xcopy /S /Y /F %OriginalDirectory%\InstallFiles\ZSMP4 ./


@REM DODAWANIE WERSJI NEOFORGE CAŁA LOGIKA
cd %APPDATA%
cd .minecraft
copy launcher_profiles.json launcher_profiles2.json
cd %OriginalDirectory%/InstallFiles
"java/bin/java.exe" -jar neoforge-21.1.233-installer.jar --installClient
cd %OriginalDirectory%/InstallFiles
Powershell.exe -executionpolicy remotesigned -File ./VersionArgumentsChange.ps1
cd %APPDATA%/.minecraft
del launcher_profiles.json
ren launcher_profiles2.json launcher_profiles.json

@REM PRZENOSZENIE MODÓW I CONFIGÓW I INNYCH
cd %APPDATA%/.minecraft
mkdir ZSMP4
cd ZSMP4
mkdir mods
xcopy /S /Y /F %OriginalDirectory%\InstallFiles\mods mods\
xcopy /S /Y /F %OriginalDirectory%\InstallFiles\java java\
xcopy /S /Y /F %OriginalDirectory%\InstallFiles\config config\
xcopy /S /Y /F %OriginalDirectory%\InstallFiles\options.txt ./
xcopy /S /Y /F %OriginalDirectory%\InstallFiles\servers.dat ./
cls
echo ========================================================================================================================
echo Przygotowalem wczesniej wygenerowane chunki do moda voxy
echo Pozwalaja one widzec dalej niz pozwala serwer i ogolnie powiekszaja dystans widzenia.
echo Pobranie takich chunkow wymaga ~5GB wiec sa one opcjonalne.
echo ========================================================================================================================
set VoxyOption="T"
set /p VoxyOption="Czy chcesz pobrac wygenerowane wczesniej chunki? [ 'T' - TAK | 'N' - NIE ]: "
if /i "%VoxyOption%"=="N" goto end
curl --ssl-no-revoke -L http://zychuhost.ddns.net/.voxy.zip --output voxy.zip
tar -xf voxy.zip
del voxy.zip
cd .voxy/saves/zychuhost.ddns.net/905087f11b320fc233b3948d9ee8f55a/storage
curl --ssl-no-revoke -L http://zychuhost.ddns.net/part1.zip --output part1.zip
tar -xf part1.zip
del part1.zip
curl --ssl-no-revoke -L http://zychuhost.ddns.net/part2.zip --output part2.zip
tar -xf part2.zip
del part2.zip
curl --ssl-no-revoke -L http://zychuhost.ddns.net/part3.zip --output part3.zip
tar -xf part3.zip
del part3.zip
curl --ssl-no-revoke -L http://zychuhost.ddns.net/part1.zip --output part4.zip
tar -xf part4.zip
del part4.zip
curl --ssl-no-revoke -L http://zychuhost.ddns.net/part5.zip --output part5.zip
tar -xf part5.zip
del part5.zip
curl --ssl-no-revoke -L http://zychuhost.ddns.net/part6.zip --output part6.zip
tar -xf part6.zip
del part6.zip
goto end

:Update
echo Wybrano update
taskkill /F /IM "Minecraft*"
mkdir UpdateFiles
cd UpdateFiles

@REM Git stuff
mkdir git
cd git
curl --ssl-no-revoke -L https://github.com/git-for-windows/git/releases/download/v2.54.0.windows.1/MinGit-2.54.0-64-bit.zip --output git.zip
tar -xf git.zip
cd ..
"git/cmd/git.exe" clone https://github.com/Zzychu/ZSMP4.git
xcopy /S /Y /F %OriginalDirectory%\UpdateFiles\ZSMP4 ./
cd %appdata%/.minecraft/ZSMP4
rmdir /S /Q mods
xcopy /S /Y /F %OriginalDirectory%\UpdateFiles\mods mods\
robocopy %OriginalDirectory%\UpdateFiles\config config\ /E /XC /XO /XN
goto end



:Uninstall
taskkill /F /IM "Minecraft*"
powershell -NoProfile -ExecutionPolicy remotesigned -Command "$path = \"$env:APPDATA\.minecraft\launcher_profiles.json\"; $json = Get-Content $path | ConvertFrom-Json; $json.profiles.PSObject.Properties.Remove('ZSMP4'); $json | ConvertTo-Json -Depth 100 | Set-Content $path"
rmdir /S /Q %appdata%\.minecraft\ZSMP4
rmdir /S /Q UpdateFiles
rmdir /S /Q InstallFiles
rmdir /S /Q tempZSMPInstaller
goto info



:end
cd %OriginalDirectory%
rmdir /S /Q UpdateFiles
rmdir /S /Q InstallFiles
rmdir /S /Q tempZSMPInstaller
cls
pause
exit