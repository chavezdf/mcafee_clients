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
REM		TITLE: Update-EPOAgent 
REM		PURPOSE: Trigger Updates for McAfee EPO Agent
REM		VERSION: 1.1
REM	-------------------------------------------------------------------------------

CLS
ECHO.	>> %MCAFEELOG%
ECHO	[ATTEMPTING EPO AGENT UPDATES] (%DATE% %TIME%) >> %MCAFEELOG%
CALL %CHECKVERSIONS%
REM CHECK IF EPO INSTALLED
IF "%EPOVER%"=="Not Installed" GOTO ERROR1
GOTO START

:START
CLS
ECHO.
ECHO	[TRIGGERING EPO AGENT UPDATES]
ECHO.
ECHO	Please Wait...

FOR /F "usebackq tokens=1-3*" %%a IN (`%EPOPATHQUERY% ^| findstr "Installed Path"`) DO SET EPOPATH=%%d
REM Set EPO Agent Update File Path
SET EPOUPDATEFILE=%EPOPATH%\CmdAgent.exe

IF NOT EXIST "%EPOUPDATEFILE%" GOTO ERROR2

REM CREATE AND SEND PROPERTIES:
"%EPOUPDATEFILE%" /P

REM Wait about 5 seconds
CALL %SUBSCRIPTS%\WAIT.cmd 5

REM CHECK FOR NEW POLICIES:
"%EPOUPDATEFILE%" /C

REM Wait about 5 seconds
CALL %SUBSCRIPTS%\WAIT.cmd 5

REM ENFORCE POLICES:
"%EPOUPDATEFILE%" /E

REM Wait about 5 seconds
CALL %SUBSCRIPTS%\WAIT.cmd 5

REM CREATE AND SEND PROPERTIES:
"%EPOUPDATEFILE%" /P

REM Wait about 5 seconds
CALL %SUBSCRIPTS%\WAIT.cmd 5

REM ENFORCE POLICES:
"%EPOUPDATEFILE%" /E

CLS
ECHO.
ECHO	[EPO AGENT UPDATED SUCCESSFULLY]
ECHO.
ECHO.
SET ERROR=0
ECHO.	>> %MCAFEELOG%
ECHO	[EPO AGENT UPDATED SUCCESSFULLY] (%DATE% %TIME%) >> %MCAFEELOG%
REM Wait 2 seconds
CALL %SUBSCRIPTS%\WAIT.cmd 2
GOTO END

:ERROR1
COLOR 1c
CLS
ECHO.
ECHO	ERROR: [EPO AGENT NOT INSTALLED]
ECHO.
SET ERROR=1
ECHO.	>> %MCAFEELOG%
ECHO	ERROR: [EPO AGENT NOT INSTALLED] (%DATE% %TIME%) >> %MCAFEELOG%
PAUSE
GOTO END

:ERROR2
COLOR 1c
CLS
ECHO.
ECHO	ERROR: [EPO AGENT UPDATE FILE MISSING]
ECHO.
SET ERROR=1
ECHO.	>> %MCAFEELOG%
ECHO	ERROR: [EPO AGENT FILE MISSING] (%DATE% %TIME%) >> %MCAFEELOG%
PAUSE
GOTO END

:END