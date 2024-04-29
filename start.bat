@echo off
setlocal

set APP_NAME=app.jar
set JAVA_PATH="C:\Program Files\Java\jdk-11.0.1\bin\java.exe"
set APP_PATH=C:\path\to\your\application\%APP_NAME%

:MENU
echo.
echo 1. Start Application
echo 2. Stop Application
echo 3. Check Application Status
echo 4. Restart Application
echo 5. Exit
echo.
set /p CHOICE=Enter your choice:

if "%CHOICE%"=="1" goto START_APP
if "%CHOICE%"=="2" goto STOP_APP
if "%CHOICE%"=="3" goto CHECK_APP
if "%CHOICE%"=="4" goto RESTART_APP
if "%CHOICE%"=="5" goto END

goto MENU

:START_APP
echo Starting Application...
start "SpringBootApp" %JAVA_PATH% -jar %APP_PATH%
echo Application started.
goto MENU

:STOP_APP
echo Stopping Application...
for /f "tokens=2" %%i in ('tasklist /NH /FI "IMAGENAME eq java.exe" /FI "WINDOWTITLE eq SpringBootApp"') do (
    taskkill /PID %%i /F
)
echo Application stopped.
goto MENU

:CHECK_APP
tasklist /FI "IMAGENAME eq java.exe" /FI "WINDOWTITLE eq SpringBootApp" | find /I "java.exe" >nul && (
    echo Application is running.
) || (
    echo Application is not running.
)
goto MENU

:RESTART_APP
echo Restarting Application...
call :STOP_APP
call :START_APP
echo Application restarted.
goto MENU

:END
endlocal
echo Exiting...
