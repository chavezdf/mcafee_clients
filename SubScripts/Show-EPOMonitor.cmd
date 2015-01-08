@ECHO OFF
COLOR 1f

REM	-------------------------------------------------------------------------------
REM	+CHANGE LOG
REM	11/23/2011: Created
REM	-------------------------------------------------------------------------------	

REM	-------------------------------------------------------------------------------
REM		AUTHOR: Levon Becker 
REM		TITLE: Show-EPOUI 
REM		PURPOSE: Launch the McAfee EPO Agent Monitor UI
REM		CREATED: 11/23/2011 
REM		LAST MOD: 11/23/2011
REM		VERSION: 1.0
REM	-------------------------------------------------------------------------------

IF NOT EXIST "%EPOUPDATEFILE%" GOTO ERROR

:LAUNCHUI
"%EPOUPDATEFILE%" /s
SET ERROR=0
GOTO END

:ERROR
COLOR 1c
CLS
ECHO.
ECHO	!!!!!!!!!!!!!!!!!!!!!!!!!!!
ECHO	!                         !
ECHO	!   NO EPO AGENT FOUND    !
ECHO	!                         !
ECHO	!!!!!!!!!!!!!!!!!!!!!!!!!!!
ECHO.
SET ERROR=1
PAUSE
GOTO END

:END