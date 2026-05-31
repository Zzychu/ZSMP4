@echo off
set OriginalDirectory=%appdata%
cd %OriginalDirectory%
echo 1 - Install, 2 - Update, 3 - Uninstall
set /p opcja=""


if /i "%opcja%"=="1" goto Install
if /i "%opcja%"=="2" goto Update
if /i "%opcja%"=="3" goto Uninstall

:Install
echo Wybrano install
mkdir InstallFiles
cd InstallFiles

@REM Java
curl -L https://download.oracle.com/java/21/archive/jdk-21.0.10_windows-x64_bin.zip --output zip.zip
tar -xf zip.zip
ren jdk-21.0.10 java


@REM Git stuff
mkdir git
cd git
curl -L https://github.com/git-for-windows/git/releases/download/v2.54.0.windows.1/MinGit-2.54.0-64-bit.zip --output git.zip
tar -xf git.zip
cd ..
"git/cmd/git.exe" clone https://github.com/Zzychu/ZSMP4.git
xcopy /S /Y /F %OriginalDirectory%\InstallFiles\ZSMP4 ./


@REM DODAWANIE WERSJI NEOFORGE CAŁA LOGIKA
cd %APPDATA%
ren .minecraft .minecraft_backup
mkdir .minecraft
cd .minecraft_backup
xcopy /S /Y /F launcher_profiles.json ..\.minecraft
cd %OriginalDirectory%/InstallFiles
"java/bin/java.exe" -jar neoforge-21.1.233-installer.jar --installClient
cd %APPDATA%
cd .minecraft
ren launcher_profiles.json launcher_profiles2.json
cd %APPDATA%
xcopy /S /Y .minecraft .minecraft_backup
rmdir /S /Q .minecraft
ren .minecraft_backup .minecraft
cd %OriginalDirectory%/InstallFiles
Powershell.exe -executionpolicy remotesigned -File ./VersionArgumentsChange.ps1
cd %APPDATA%
cd .minecraft
del launcher_profiles2.json

@REM PRZENOSZENIE MODÓW I CONFIGÓW I INNYCH
cd %APPDATA%/.minecraft
mkdir ZSMP4
cd ZSMP4
mkdir mods
mkdir .voxy
xcopy /S /Y /F %OriginalDirectory%\InstallFiles\mods mods\
xcopy /S /Y /F %OriginalDirectory%\InstallFiles\.voxy .voxy\
xcopy /S /Y /F %OriginalDirectory%\InstallFiles\java java\
xcopy /S /Y /F %OriginalDirectory%\InstallFiles\config config\
xcopy /S /Y /F %OriginalDirectory%\InstallFiles\options.txt ./
xcopy /S /Y /F %OriginalDirectory%\InstallFiles\servers.dat ./
goto end

:Update
echo Wybrano update
mkdir UpdateFiles
cd UpdateFiles


@REM Git stuff
mkdir git
cd git
curl -L https://github.com/git-for-windows/git/releases/download/v2.54.0.windows.1/MinGit-2.54.0-64-bit.zip --output git.zip
tar -xf git.zip
cd ..
"git/cmd/git.exe" clone https://github.com/Zzychu/ZSMP4.git
xcopy /S /Y /F %OriginalDirectory%\UpdateFiles\ZSMP4 ./


goto end

:Uninstall
powershell -NoProfile -ExecutionPolicy remotesigned -Command "$path = \"$env:APPDATA\.minecraft\launcher_profiles.json\"; $json = Get-Content $path | ConvertFrom-Json; $json.profiles.PSObject.Properties.Remove('ZSMP4'); $json | ConvertTo-Json -Depth 100 | Set-Content $path"
rmdir /S /Q %appdata%\.minecraft\ZSMP4
goto end

:end
cd %OriginalDirectory%
rmdir /S /Q UpdateFiles
rmdir /S /Q InstallFiles
pause
