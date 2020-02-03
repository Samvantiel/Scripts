color a
@echo off
:menu
title welcome to remote control client V1.2
cls
:: Check WMIC is available
WMIC.EXE Alias /? >NUL 2>&1 ll GOTO s_error

:: Use WMIC to retrieve date and time
FOR /F "skip=1 tokens=1-6" %%G IN ('WMIC Path Win32_LocalTime Get Day^,Hour^,Minute^,Month^,Second^,Year /Format:table') DO (
   IF "%%~L"=="" goto s_done
      Set _dd=00%%G
	  Set _mm=00%%J
	  Set _yyyy=%%L
      Set _hour=00%%H
      SET _minute=00%%I
)
:s_done

:: Pad digits with leading zeros
      Set _mm=%_mm:~-2%
      Set _dd=%_dd:~-2%
      Set _hour=%_hour:~-2%
      Set _minute=%_minute:~-2%

:: Display the date/time in ISO 8601 format:
Set _isodate=%_dd%-%_mm%-%_yyyy% %_hour%:%_minute%
@echo off
color a
echo off
:menu
echo %_isodate%
echo                                _                               _                 _ 
echo                               / /                             / /               / /
echo  _ __   ___  _ __ ___    ___  / /_   ___    ___   ___   _ __  / /_  _ __   ___  / /
echo / '__/ / _ \/ '_ ` _ \  / _ \ / __/ / _ \  / __/ / _ \ / '_ \ / __// '__/ / _ \ / /
echo / /   /  __// / / / / // (_) // /_ /  __/ / (__ / (_) // / / // /_ / /   / (_) // /
echo /_/    \___//_/ /_/ /_/ \___/  \__/ \___/  \___/ \___/ /_/ /_/ \__//_/    \___/ /_/                                                                             
echo welcome to remote control client V1.0
echo. 
echo press exit to exit the prompt
echo press menu to get to the menu again
echo press 1 to get to the SSH-client

set /p keuze=
if %keuze%==1 goto SSH-client
if %keuze%==menu goto menu
if %keuze%==exit goto exit
pause
goto menu
:exit
pause
exit
:Telnet-client
cls

echo	  _       _            _   
echo	 / /     / /          / /  
echo	 / /_ ___/ /_ __   ___/ /_ 
echo	 / __/ _ \ / '_ \ / _ \ __/
echo	 / //  __/ / / / /  __/ /_ 
echo	  \__\___/_/_/ /_/\___/\__/
echo.                          
echo.
echo Comming Soon!
pause
goto menu

:SSH-client
cls

echo   _____ _____ _    _ 
echo  / ____/ ____/ /  / /
echo / (___/ (___ / /__/ /
echo  \___ \\___ \/  __  /
echo  ____) /___) / /  / /
echo /_____/_____//_/  /_/
echo.
echo.
set /p SSHip=what is the ip address of the server?
set /p SSHusername=what is the username?
ssh -p 22 %SSHusername%@%SSHip%
echo. 
pause
goto menu