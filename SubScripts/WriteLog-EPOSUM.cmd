@ECHO OFF
COLOR 1f

REM	-------------------------------------------------------------------------------
REM	+CHANGE LOG
REM 12/06/2011: Created
REM 01/03/2012: Added Source install path for debugging.
REM	-------------------------------------------------------------------------------	

REM	-------------------------------------------------------------------------------
REM		AUTHOR: Levon Becker 
REM		TITLE: WriteLog-EPOSUM 
REM		PURPOSE: Write EPO Summary to McAfee-Clients.log
REM		VERSION: 1.1
REM	-------------------------------------------------------------------------------

REM ECHO.	>> %MCAFEELOG%
ECHO	------------------------------------------------------------------------------- >> %MCAFEELOG%
ECHO	EPO SUMMARY                                          %DATE% %TIME% >> %MCAFEELOG%
ECHO	------------------------------------------------------------------------------- >> %MCAFEELOG%
ECHO	MCTEMP:            %McAfeeClientsTemp% >> %MCAFEELOG%
ECHO	EPOTEMP:           %EPOTEMP% >> %MCAFEELOG%
ECHO	EPOVERTEMP:        %EPOVERTEMP% >> %MCAFEELOG%
ECHO	PROD VERSION:      %CUREPOVER% >> %MCAFEELOG%
ECHO	INSTALLED VERSION: %EPOVER% >> %MCAFEELOG%
ECHO	CURRENT:           %CUREPOANS% >> %MCAFEELOG%
ECHO	LOCAL INST PATH:   %EPOPATH% >> %MCAFEELOG%
ECHO	SOURCE INST PATH:  %EPOINST% >> %MCAFEELOG%
ECHO	------------------------------------------------------------------------------- >> %MCAFEELOG%