@echo off

setlocal EnableExtensions DisableDelayedExpansion 
set "FullVersion=%~1" 
if not defined FullVersion set "FullVersion=1.0.0.0"

rem Make sure that the environment variables used below are
rem not defined already by chance outside the batch file. 
set "MajorVersion=" 
set "MinorVersion=" 
set "Maintenance=" 
set "BuildNumber="

rem Split up the version string into four integer values. 
for /F "tokens=1-4 delims=." %%I in ("%FullVersion%") do ( if not "%%L" == "" ( set "MajorVersion=%%I." set "MinorVersion=%%J." set "Maintenance=%%K." set "BuildNumber=%%L" ) else if not "%%K" == "" ( set "MajorVersion=%%I." set "MinorVersion=%%J." set "BuildNumber=%%K" ) else if not "%%J" == "" ( set "MajorVersion=%%I." set "BuildNumber=%%J" ) else set "BuildNumber=%%I" )

rem Remove leading zeros from build number to get the build number always rem interpreted as decimal number and never as valid or invalid octal number. 
if defined BuildNumber for /F "tokens=* delims=0" %%I in ("%BuildNumber%") do set "BuildNumber=%%I" 

rem It is possible that the build number is not defined anymore because of rem having value 0. But that is no problem on using the arithmetic expression rem below which uses value 0 for not defined environment variable BuildNumber 
rem and so BuildNumber has the correct value 1 after the next command line. 
set /A BuildNumber+=1 

rem The command lines below can be enabled by removing REM to define rem the build number with a fixed number of digits like four digits. 
REM set "BuildNumber=000%BuildNumber%" 
REM set "BuildNumber=%BuildNumber:~-4%" 

rem Concatenate the version string together with incremented build number. 
set "FullVersion=%MajorVersion%%MinorVersion%%Maintenance%%BuildNumber%" 
echo Incremented version is: %FullVersion% 
endlocal

rem Set the variables for compiling your app below
set APP_TITLE = "netflix"
set APP_URL = "https://www.netflix.com/"
set APP_ICON = "./icon.ico"
set ELECTRON_VERSION = 
set INTERNAL_URLS = "(*.?)(*.netflix.*)(*.?)"
set FILE_DDOWNLOAD_OPTIONS = "{\"saveAs\": true}"

rem Get the time and date for use with the log file
set CUR_YYYY=%date:~10,4%
set CUR_MM=%date:~4,2%
set CUR_DD=%date:~7,2%
set CUR_HH=%time:~0,2%

if %CUR_HH% lss 10 (set CUR_HH=0%time:~1,1%)

set CUR_NN=%time:~3,2%
set CUR_SS=%time:~6,2%
set CUR_MS=%time:~9,2%
set DATE_TIME = %CUR_YYYY%%CUR_MM%%CUR_DD%-%CUR_HH%%CUR_NN%%CUR_SS%

rem Set the build path and log path
set BUILD_PATH = ../out/%APP_NAME%/
set LOG_PATH = ../logs/%APP_TITLE%-%DATE_TIME%.log

echo "Compiling the requested %APP_NAME% app ..."
echo "Please be patient ..."
rem Wait before moving forward 
wait 1
echo.
echo "================================"
echo "App Name: %APP_NAME%"
echo "Build Path: %BUILD_PATH%"
echo "Log File: %LOG_PATH%"
echo "Version: %FullVersion%"
echo "================================"
echo.
rem Wait before moving forward 
wait 1
rem Create the out and logs directories 
mkdir ../logs/ && mkdir ../out/
rem Wait before moving forward 
wait 1
rem Compile the native app with nativefier 
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
