@ECHO OFF
COLOR 1f

REM	-------------------------------------------------------------------------------
REM	+CHANGE LOG
REM 12/06/2011: Created
REM 01/03/2012: Added ProdVer
REM	-------------------------------------------------------------------------------	

REM	-------------------------------------------------------------------------------
REM		AUTHOR: Levon Becker 
REM		TITLE: WriteLog-Header 
REM		PURPOSE: Write Header to McAfee-Clients.log
REM		VERSION: 1.1
REM	-------------------------------------------------------------------------------

ECHO.	>> %MCAFEELOG%
ECHO.	>> %MCAFEELOG%
ECHO	******************************************************************************* >> %MCAFEELOG%
ECHO	******************************************************************************* >> %MCAFEELOG%
ECHO.	>> %MCAFEELOG%
ECHO.	>> %MCAFEELOG%
ECHO	------------------------------------------------------------------------------- >> %MCAFEELOG%
ECHO	McAfee Clients Script                                %DATE% %TIME% >> %MCAFEELOG%
ECHO	------------------------------------------------------------------------------- >> %MCAFEELOG%
ECHO	  SCRIPT:   %SCRIPTVER% >> %MCAFEELOG%
ECHO	USERNAME:   %USERDOMAIN%\%USERNAME% >> %MCAFEELOG%
ECHO	HOSTNAME:   %COMPUTERNAME% >> %MCAFEELOG%
ECHO	      OS:   %OSVER% (%OSARCH%) >> %MCAFEELOG%
ECHO	------------------------------------------------------------------------------- >> %MCAFEELOG%
ECHO	EPO Agent >> %MCAFEELOG%
ECHO	--------- >> %MCAFEELOG%
ECHO	 Version:   %EPOVER% >> %MCAFEELOG%
ECHO	 Current:   %CUREPOANS% >> %MCAFEELOG%
ECHO	 ProdVer:   %CUREPOVER% >> %MCAFEELOG%
ECHO	 Install:   %EPOPATH% >> %MCAFEELOG%
ECHO.	>> %MCAFEELOG%
ECHO	VSE Agent >> %MCAFEELOG%
ECHO	--------- >> %MCAFEELOG%
ECHO	 Version:   %VSEVER% >> %MCAFEELOG%
ECHO	 Current:   %CURVSEANS% >> %MCAFEELOG%
ECHO	 ProdVer:   %CURVSEVER% >> %MCAFEELOG%
ECHO	 Install:   %VSEPATH% >> %MCAFEELOG%
ECHO	------------------------------------------------------------------------------- >> %MCAFEELOG%
