@echo off
set OriginalDirectory=%~dp0
echo 1 - Install, 2 - Update
set /p opcja=""

@REM Instalowanie potrzebnych składników
winget install --id Git.Git -e --source winget --accept-source-agreements --accept-package-agreements

if /i "%opcja%"=="1" goto Install
if /i "%opcja%"=="2" goto Update


:Update
echo Wybrano update
mkdir UpdateFiles
cd UpdateFiles
git clone https://github.com/Zzychu/ZSMP4.git .
goto end

:Install
echo Wybrano install
mkdir InstallFiles
cd InstallFiles
git clone https://github.com/Zzychu/ZSMP4.git .

@REM Java
curl -L https://download.oracle.com/java/21/archive/jdk-21.0.10_windows-x64_bin.zip --output zip.zip
tar -xf zip.zip
ren jdk-21.0.10 java

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

:end
cd %OriginalDirectory%
rmdir /S /Q UpdateFiles
rmdir /S /Q InstallFiles
pause
