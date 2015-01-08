@ECHO OFF
COLOR 1f

REM	-------------------------------------------------------------------------------
REM	+CHANGE LOG
REM	11/23/2011: Created
REM	12/06/2011: Changed to use Checkversions
REM				Added logging
REM				Added install check and accompanied error for if not installed
REM	-------------------------------------------------------------------------------	

REM	-------------------------------------------------------------------------------
REM		AUTHOR: Levon Becker 
REM		TITLE: Update-VSEClient 
REM		PURPOSE: Trigger Update for McAfee VirusScan Enterprise Client
REM		VERSION: 1.1
REM	-------------------------------------------------------------------------------

CLS
ECHO.	>> %MCAFEELOG%
ECHO	[ATTEMPTING VSE CLIENT UPDATE] (%DATE% %TIME%) >> %MCAFEELOG%
CALL %CHECKVERSIONS%
REM CHECK IF VSE INSTALLED
IF "%VSEVER%"=="Not Installed" GOTO ERROR1
GOTO START

:START
CLS
ECHO.
ECHO	[TRIGGERING VSE CLIENT UPDATE]
ECHO.
ECHO	Please Wait...

REM Set VSE Client Update File Path
FOR /F "usebackq tokens=1-2*" %%a IN (`%VSEPATHQUERY% ^| findstr "szInstallDir"`) DO SET VSEPATH=%%c
SET VSEUPDATEFILE=%VSEPATH%\Mcupdate.exe

IF NOT EXIST "%VSEUPDATEFILE%" GOTO ERROR2

REM Remove trailing backslash
SET VSEPATH=%VSEPATH:~0,-1%
REM Wait 5 seconds
CALL %SUBSCRIPTS%\WAIT.cmd 5

:VSEUPDATE
"%VSEUPDATEFILE%" /UPDATE

:VSEUPDATED
CLS
ECHO.
ECHO	[VSE CLIENT UPDATED SUCCESSFULLY]
ECHO.
ECHO.
SET ERROR=0
ECHO.	>> %MCAFEELOG%
ECHO	[VSE CLIENT UPDATED SUCCESSFULLY] (%DATE% %TIME%) >> %MCAFEELOG%
REM Wait 2 seconds
CALL %SUBSCRIPTS%\WAIT.cmd 2
GOTO END

:ERROR1
COLOR 1c
CLS
ECHO.
ECHO	[VSE CLIENT NOT INSTALLED]
ECHO.
SET ERROR=1
ECHO.	>> %MCAFEELOG%
ECHO	ERROR: [VSE CLIENT NOT INSTALLED] (%DATE% %TIME%) >> %MCAFEELOG%
PAUSE
GOTO END

:ERROR2
COLOR 1c
CLS
ECHO.
ECHO	[VSE CLIENT UPDATE FILE MISSING]
ECHO.
SET ERROR=1
ECHO.	>> %MCAFEELOG%
ECHO	ERROR: [VSE CLIENT UPDATE FILE MISSING] (%DATE% %TIME%) >> %MCAFEELOG%
ECHO.	>> %MCAFEELOG%
PAUSE
GOTO END

:END