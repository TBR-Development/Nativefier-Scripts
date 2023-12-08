@echo off
setlocal EnableExtensions DisableDelayedExpansion 

set "FullVersion=%~1" 

if not defined FullVersion set "FullVersion=1.0.0.0"

set "MajorVersion=" 
set "MinorVersion=" 
set "Maintenance=" 
set "BuildNumber="

for /F "tokens=1-4 delims=." %%I in ("%FullVersion%") do ( if not "%%L" == "" ( set "MajorVersion=%%I." set "MinorVersion=%%J." set "Maintenance=%%K." set "BuildNumber=%%L" ) else if not "%%K" == "" ( set "MajorVersion=%%I." set "MinorVersion=%%J." set "BuildNumber=%%K" ) else if not "%%J" == "" ( set "MajorVersion=%%I." set "BuildNumber=%%J" ) else set "BuildNumber=%%I" )
if defined BuildNumber for /F "tokens=* delims=0" %%I in ("%BuildNumber%") do set "BuildNumber=%%I" 

set /A BuildNumber+=1 
set "BuildNumber=000%BuildNumber%" 
set "BuildNumber=%BuildNumber:~-4%" 
set "FullVersion=%MajorVersion%%MinorVersion%%Maintenance%%BuildNumber%" 

echo Incremented version is: %FullVersion% 

set CurYYYY=%date:~10,4%
set CurMM=%date:~4,2%
set CurDD=%date:~7,2%
set CurHH=%time:~0,2%

if %CurHH% lss 10 (set CurHH=0%time:~1,1%)

set CurNN=%time:~3,2%
set CurSS=%time:~6,2%
set CurMS=%time:~9,2%
set DateTime= %CurYYYY%%CurMM%%CurDD%-%CurHH%%CurNN%%CurSS%
set AppTitle = "netflix"
set AppName = "https://www.netflix.com/"
set AppIcon = "./icon.ico"
set ElectronVersion = 
set InternalUrls = "(*.?)(*.netflix.*)(*.?)"
set FileDownloadOptions = "{\"saveAs\": true}"
set BuildPath = ../out/%AppName%/
set LogPath = ../logs/%AppTitle%-%DateTime%.log

echo "Compiling the requested %APP_NAME% app ..."
echo "Please be patient ..."

wait .5

echo.
echo "================================"
echo "App Name: %APP_NAME%"
echo "Build Path: %BUILD_PATH%"
echo "Log File: %LOG_PATH%"
echo "Version: %FullVersion%"
echo "================================"
echo.

wait .5

mkdir ../logs/ && mkdir ../out/

wait .5

nativefier -e %ELECTRON_VERSION% -v %APP_TITLE% %APP_URL% \
  --tray \
  --enable-es3-apis \
  --icon %APP_ICON% \
  --internal-urls %INTERNAL_URLS% \
  --app-verosion %FullVersion% \
  --file-download-options %FILE_DOWNLOAD_OPTIONS% \
  %BUILD_PATH% > %LOG_PATH%
endlocal
pause > Press any key to exit ...
