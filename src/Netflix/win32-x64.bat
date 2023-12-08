@echo off

setlocal EnableExtensions DisableDelayedExpansion 
set "FullVersion=%~1" 

if not defined FullVersion set "FullVersion=1.0.0.0" 
set "MajorVersion=" 
set "MinorVersion=" 
set "Maintenance=" 
set "BuildNumber="

for /F "tokens=1-4 delims=." %%I in ("%FullVersion%") do ( 
    if not "%%L" == "" ( 
        set "MajorVersion=%%I." 
        set "MinorVersion=%%J." 
        set "Maintenance=%%K." 
        set "BuildNumber=%%L"
    ) else if not "%%K" == "" ( 
        set "MajorVersion=%%I." 
        set "MinorVersion=%%J." 
        set "BuildNumber=%%K"
    ) else if not "%%J" == "" ( 
        set "MajorVersion=%%I." 
        set "BuildNumber=%%J"
    ) else set "BuildNumber=%%I" )

if defined BuildNumber for /F "tokens=* delims=0" %%I in ("%BuildNumber%") do set "BuildNumber=%%I" 

set /A BuildNumber+=1 

set "BuildNumber=000%BuildNumber%" 
set "BuildNumber=%BuildNumber:~-4%" 
set "FullVersion=%MajorVersion%%MinorVersion%%Maintenance%%BuildNumber%" 

set CurYYYY=%date:~10,4%
set CurMM=%date:~4,2%
set CurDD=%date:~7,2%

if %CurHH% lss 10 (set CurHH=0%time:~1,1%)

set AppTitle = Netflix
set AppName = netflix
set AppUrl = https://www.netflix.com/
set InternalUrls = (*.?)(*.netflix.*)(*.?)
set FileDownloadOptions = {\"saveAs\": true}

set BuildPath = ../out/%AppName%/
set LogDate = %CurYYYY%%CurMM%%CurDD%
set LogPath = ../logs/%AppTitle%%LogDate%.log

echo "======================================"
echo " - Compiling the requested app ...    "
echo " - Please be patient ...              "
echo "======================================"
echo " - App Name: %AppName%                "
echo " - Build Path: %BuildPath%            "
echo " - Log File: %LogPath%                "
echo " - Build Version: %FullVersion%       "
echo "======================================"
wait .5
mkdir ../logs/ >1&2 "%LogPath%"
mkdir ../out/ >1&2 "%LogPath%"
nativefier -e %ElectronVersion% -v "%AppTitle"% "%AppUrl%" \
  --tray \
  --enable-es3-apis \
  --internal-urls "%InternalUrls%" \
  --app-version "%FullVersion%" \
  --file-download-options "%FileDownloadOptions%" \
  "%BUILD_PATH%" >1&2 "%LogPath%"
endlocal
pause > Press any key to exit ...
