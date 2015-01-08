@ECHO OFF
COLOR 1f

REM	-------------------------------------------------------------------------------
REM	+CHANGE LOG
REM 12/06/2011: Created
REM 01/03/2012: Added Source install path for debugging.
REM	-------------------------------------------------------------------------------	

REM	-------------------------------------------------------------------------------
REM		AUTHOR: Levon Becker 
REM		TITLE: WriteLog-VSESUM 
REM		PURPOSE: Write VSE Summary to McAfee-Clients.log
REM		VERSION: 1.1
REM	-------------------------------------------------------------------------------

REM ECHO.	>> %MCAFEELOG%
ECHO	------------------------------------------------------------------------------- >> %MCAFEELOG%
ECHO	VSE SUMMARY                                          %DATE% %TIME% >> %MCAFEELOG%
ECHO	------------------------------------------------------------------------------- >> %MCAFEELOG%
ECHO	MCTEMP:            %McAfeeClientsTemp% >> %MCAFEELOG%
ECHO	VSETEMP:           %VSETEMP% >> %MCAFEELOG%
ECHO	VSEVERTEMP:        %VSEVERTEMP% >> %MCAFEELOG%
ECHO	PROD VERSION:      %CURVSEVER% >> %MCAFEELOG%
ECHO	INSTALLED VERSION: %VSEVER% >> %MCAFEELOG%
ECHO	CURRENT:           %CURVSEANS% >> %MCAFEELOG%
ECHO	LOCAL INST PATH:   %VSEPATH% >> %MCAFEELOG%
ECHO	SOURCE INST PATH:  %VSEINST% >> %MCAFEELOG%
ECHO	------------------------------------------------------------------------------- >> %MCAFEELOG%