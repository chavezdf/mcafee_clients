@ECHO OFF
COLOR 1f

:TOP
:: USER VARIABLES
SET SHARESRVIP=<Share Server IP>
SET CUREPOVER=4.6.0.3122
SET CURVSEVER=8.8.0.975
SET WindowsScriptTemp=C:\WindowsScriptTemp

:: SCRIPT VARIABLES
SET SUBSCRIPTS=\\%SHARESRVIP%\McAfee\Scripts\SubScripts
SET EXTRAS=\\%SHARESRVIP%\McAfee\Scripts\Extras
SET EPOINST=\\%SHARESRVIP%\McAfee\EPO\Windows\%CUREPOVER%
SET VSEINST=\\%SHARESRVIP%\Mcafee\VSE\Windows\%CURVSEVER%
SET ERROR=0
SET McAfeeClientsTemp=%WindowsScriptTemp%\McAfee-Clients
SET MCAFEELOGFILE=%COMPUTERNAME%_McAfeeClients_History.log
SET MCAFEELOG=%McAfeeClientsTemp%\%MCAFEELOGFILE%
SET SCRIPTVER=1.5.0
SET UPDATEDATE=01/07/2015

CLS
ECHO	-------------------------------------------------------------------------------
ECHO	  AUTHOR:  Levon Becker
ECHO	 VERSION:  %SCRIPTVER% - %UPDATEDATE%
ECHO	 PURPOSE:  Install,Uninstall,Reinstall,Update and View Logs for McAfee Clients
ECHO	-------------------------------------------------------------------------------
:: ECHO	It may be necessary to disable VirusScan Access Protection before uninstalling.
:: ECHO	-------------------------------------------------------------------------------

:: GET OS VERSION AND OS ARCHITECTURE
CALL %SUBSCRIPTS%\Get-OSVersion.cmd
IF "%PROCESSOR_ARCHITECTURE%"=="AMD64" GOTO 64BIT
IF "%PROCESSOR_ARCHITEW6432%"=="AMD64" GOTO 64BIT
IF "%OSVER%"=="Windows NT" GOTO WINNT
GOTO 32BIT

:32BIT
SET OSARCH=32-BIT
SET CHECKVERSIONS=%SUBSCRIPTS%\Check-Versions-32bit.cmd
:: COPY REG.EXE LOCAL IF MISSING
IF "%OSVER%"=="Windows 2000" (
	IF NOT EXIST %windir%\System32\reg.exe (
		COPY %EXTRAS%\reg.exe %windir%\System32 > NUL
	)
)
GOTO SPLASH

:64BIT
SET OSARCH=64-BIT
SET CHECKVERSIONS=%SUBSCRIPTS%\Check-Versions-64bit.cmd
GOTO SPLASH

:WINNT
SET OSARCH=32-BIT
SET CHECKVERSIONS=%SUBSCRIPTS%\Check-Versions-Winnt.cmd
GOTO SPLASH

:SPLASH
:: CHECK INSTALLED VERSIONS
CALL %CHECKVERSIONS%

ECHO	HOSTNAME:  %COMPUTERNAME%
ECHO	      OS:  %OSVER% %OSARCH% (%SUPPORTEDOS%)
ECHO	-------------------------------------------------------------------------------
ECHO	EPO Agent
ECHO	---------
ECHO	 Version:  %EPOVER%
ECHO	 Current:  %CUREPOANS%
ECHO	 Install:  %EPOPATH%
ECHO.
ECHO	VSE Agent
ECHO	---------
ECHO	 Version:  %VSEVER%
ECHO	 Current:  %CURVSEANS%
ECHO	 Install:  %VSEPATH%
ECHO	-------------------------------------------------------------------------------
ECHO.
ECHO	[REMEMBER TO RUN AS ADMINISTRATOR]
ECHO.
PAUSE

:: CREATE TEMP DIRECTORY IF MISSING (LOGGING)
IF NOT EXIST "%WindowsScriptTemp%" MKDIR "%WindowsScriptTemp%" > NUL: 2>&1
IF NOT ERRORLEVEL 0 (
	SET ERRORS=Failed to Create WindowsScriptTemp ROOT DIRECTORY
	GOTO ERROR
) 
IF NOT EXIST "%McAfeeClientsTemp%" MKDIR "%McAfeeClientsTemp%" > NUL: 2>&1
IF NOT ERRORLEVEL 0 (
	SET ERRORS=Failed to Create McAfee Clients Temp Directory
	GOTO ERROR
) 

:: REMOVE OLD MCTEMP DIRECTORY AND COPY/RENAME LOG
IF EXIST "C:\McAfee-Installs\McAfee-Installs.log" COPY "C:\McAfee-Installs\McAfee-Installs.log"  "%McAfeeClientsTemp%" /Y
IF NOT ERRORLEVEL 0 (
	SET ERRORS=Failed to Copy Old Log to New Location
	GOTO ERROR
) 
IF EXIST "%McAfeeClientsTemp%\McAfee-Installs.log" REN "%McAfeeClientsTemp%\McAfee-Installs.log" "%MCAFEELOGFILE%"
IF NOT ERRORLEVEL 0 (
	SET ERRORS=Failed to Rename Old Log to New Name
	GOTO ERROR
) 
IF EXIST "C:\McAfee-Installs" RD /Q /S "C:\McAfee-Installs"
IF NOT ERRORLEVEL 0 (
	SET ERRORS=Failed to Remove Old McAfee Temp Directory
	GOTO ERROR
) 

:MENU
CLS
ECHO	HOSTNAME: %COMPUTERNAME%  OS: %OSVER% %OSARCH%
ECHO	EPO: %EPOVER%  VSE: %VSEVER%
ECHO.
ECHO	SELECT OPERATION:
ECHO.
ECHO	[1] Install McAfee Clients
ECHO	[2] Reinstall McAfee Clients
ECHO	[3] Uninstall McAfee Clients
ECHO	[4] Install EPO Agent
ECHO	[5] Reinstall EPO Agent
ECHO	[6] Uninstall EPO Agent
ECHO	[7] Install VSE Client
ECHO	[8] Reinstall VSE Client
ECHO	[9] Uninstall VSE Client
ECHO	[10] Update EPO
ECHO	[11] Update VSE
ECHO	[12] Show EPO Monitor
ECHO	[13] Show Access Protection Log
ECHO	[14] Show On-Access Log
ECHO	[15] Show On-Demand Log
ECHO	[R] Return to Splash Screen
ECHO	[X] Exit
ECHO.

SET CHOICE=
SET /p CHOICE=Select Operation to Perform: 
IF /i {%CHOICE%}=={1} (GOTO :INSTALL-CLIENTS)
IF /i {%CHOICE%}=={2} (GOTO :REINSTALL-CLIENTS)
IF /i {%CHOICE%}=={3} (GOTO :UNINSTALL-CLIENTS)
IF /i {%CHOICE%}=={4} (GOTO :INSTALL-EPOAGENT)
IF /i {%CHOICE%}=={5} (GOTO :REINSTALL-EPOAGENT)
IF /i {%CHOICE%}=={6} (GOTO :UNINSTALL-EPOAGENT)
IF /i {%CHOICE%}=={7} (GOTO :INSTALL-VSECLIENT)
IF /i {%CHOICE%}=={8} (GOTO :REINSTALL-VSECLIENT)
IF /i {%CHOICE%}=={9} (GOTO :UNINSTALL-VSECLIENT)
IF /i {%CHOICE%}=={10} (GOTO :UPDATE-EPO)
IF /i {%CHOICE%}=={11} (GOTO :UPDATE-VSE)
IF /i {%CHOICE%}=={12} (GOTO :SHOW-EPOMONITOR)
IF /i {%CHOICE%}=={13} (GOTO :SHOW-APLOG)
IF /i {%CHOICE%}=={14} (GOTO :SHOW-OALOG)
IF /i {%CHOICE%}=={15} (GOTO :SHOW-ODLOG)
IF /i {%CHOICE%}=={R} (GOTO :TOP)
IF /i {%CHOICE%}=={X} (GOTO :END)

ECHO.
ECHO "%CHOICE%" is not valid...please try again
PAUSE
GOTO MENU 

:INSTALL-CLIENTS
CALL "%SUBSCRIPTS%\WriteLog-Header.cmd" %MCAFEELOG%
ECHO.	>> %MCAFEELOG%
ECHO	MENU SELECTION: [INSTALL-CLIENTS] (%DATE% %TIME%) >> %MCAFEELOG%
CALL %SUBSCRIPTS%\Install-EPOAgent.cmd %EPOINST% %CUREPOVER% %McAfeeClientsTemp% %MCAFEELOG% %CHECKVERSIONS%
IF "%ERROR%"=="1" (GOTO ERROR)
CALL %SUBSCRIPTS%\Install-VSEClient.cmd %SUBSCRIPTS% %VSEINST% %CURVSEVER% %McAfeeClientsTemp% %MCAFEELOG% %CHECKVERSIONS%
IF "%ERROR%"=="1" (GOTO ERROR)
CALL %SUBSCRIPTS%\Update-VSEClient.cmd %SUBSCRIPTS% %OSARCH% %McAfeeClientsTemp% %MCAFEELOG% %CHECKVERSIONS%
IF "%ERROR%"=="1" (GOTO ERROR)
CALL %SUBSCRIPTS%\Update-EPOAgent.cmd %SUBSCRIPTS% %OSARCH% %McAfeeClientsTemp% %MCAFEELOG% %CHECKVERSIONS%
IF "%ERROR%"=="1" (GOTO ERROR)
GOTO COMPLETED

:REINSTALL-CLIENTS
CALL "%SUBSCRIPTS%\WriteLog-Header.cmd" %MCAFEELOG%
ECHO.	>> %MCAFEELOG%
ECHO	MENU SELECTION: [REINSTALL-CLIENTS] (%DATE% %TIME%) >> %MCAFEELOG%
CALL %SUBSCRIPTS%\Uninstall-EPOAgent.cmd %SUBSCRIPTS% %EPOPATH% %McAfeeClientsTemp% %MCAFEELOG% %CHECKVERSIONS%
IF "%ERROR%"=="1" (GOTO ERROR)
CALL %SUBSCRIPTS%\Uninstall-VSEClient.cmd %SUBSCRIPTS% %VSEPATH% %McAfeeClientsTemp% %MCAFEELOG% %CHECKVERSIONS%
IF "%ERROR%"=="1" (GOTO ERROR)
CALL %SUBSCRIPTS%\Install-EPOAgent.cmd %SUBSCRIPTS% %EPOINST% %CUREPOVER% %McAfeeClientsTemp% %MCAFEELOG% %CHECKVERSIONS%
IF "%ERROR%"=="1" (GOTO ERROR)
CALL %SUBSCRIPTS%\Install-VSEClient.cmd %SUBSCRIPTS% %VSEINST% %CURVSEVER% %McAfeeClientsTemp% %MCAFEELOG% %CHECKVERSIONS%
IF "%ERROR%"=="1" (GOTO ERROR)
CALL %SUBSCRIPTS%\Update-VSEClient.cmd %SUBSCRIPTS% %OSARCH% %McAfeeClientsTemp% %MCAFEELOG% %CHECKVERSIONS%
IF "%ERROR%"=="1" (GOTO ERROR)
CALL %SUBSCRIPTS%\Update-EPOAgent.cmd %SUBSCRIPTS% %OSARCH% %McAfeeClientsTemp% %MCAFEELOG% %CHECKVERSIONS%
IF "%ERROR%"=="1" (GOTO ERROR)
GOTO COMPLETED

:UNINSTALL-CLIENTS
CALL "%SUBSCRIPTS%\WriteLog-Header.cmd" %MCAFEELOG%
ECHO.	>> %MCAFEELOG%
ECHO	MENU SELECTION: [UNINSTALL-CLIENTS] (%DATE% %TIME%) >> %MCAFEELOG%
CALL %SUBSCRIPTS%\Uninstall-EPOAgent.cmd %SUBSCRIPTS% %EPOPATH% %McAfeeClientsTemp% %MCAFEELOG% %CHECKVERSIONS%
IF "%ERROR%"=="1" (GOTO ERROR)
CALL %SUBSCRIPTS%\Uninstall-VSEClient.cmd %SUBSCRIPTS% %VSEPATH% %McAfeeClientsTemp% %MCAFEELOG% %CHECKVERSIONS%
IF "%ERROR%"=="1" (GOTO ERROR)
GOTO COMPLETED

:INSTALL-EPOAGENT
CALL "%SUBSCRIPTS%\WriteLog-Header.cmd" %MCAFEELOG%
ECHO.	>> %MCAFEELOG%
ECHO	MENU SELECTION: [UNINSTALL-EPOAGENT] (%DATE% %TIME%) >> %MCAFEELOG%
CALL %SUBSCRIPTS%\Install-EPOAgent.cmd %EPOINST% %CUREPOVER% %McAfeeClientsTemp% %MCAFEELOG% %CHECKVERSIONS%
IF "%ERROR%"=="1" (GOTO ERROR)
CALL %SUBSCRIPTS%\Update-EPOAgent.cmd %SUBSCRIPTS% %OSARCH% %McAfeeClientsTemp% %MCAFEELOG% %CHECKVERSIONS%
IF "%ERROR%"=="1" (GOTO ERROR)
GOTO COMPLETED

:REINSTALL-EPOAGENT
CALL "%SUBSCRIPTS%\WriteLog-Header.cmd" %MCAFEELOG%
ECHO.	>> %MCAFEELOG%
ECHO	MENU SELECTION: [REINSTALL-EPOAGENT] (%DATE% %TIME%) >> %MCAFEELOG%
CALL %SUBSCRIPTS%\Uninstall-EPOAgent.cmd %SUBSCRIPTS% %EPOPATH% %McAfeeClientsTemp% %MCAFEELOG% %CHECKVERSIONS%
IF "%ERROR%"=="1" (GOTO ERROR)
CALL %SUBSCRIPTS%\Install-EPOAgent.cmd %EPOINST% %CUREPOVER% %McAfeeClientsTemp% %MCAFEELOG% %CHECKVERSIONS%
IF "%ERROR%"=="1" (GOTO ERROR)
CALL %SUBSCRIPTS%\Update-EPOAgent.cmd %SUBSCRIPTS% %OSARCH% %McAfeeClientsTemp% %MCAFEELOG% %CHECKVERSIONS%
IF "%ERROR%"=="1" (GOTO ERROR)
GOTO COMPLETED

:UNINSTALL-EPOAGENT
CALL "%SUBSCRIPTS%\WriteLog-Header.cmd" %MCAFEELOG%
ECHO.	>> %MCAFEELOG%
ECHO	MENU SELECTION: [UNINSTALL-EPOAGENT] (%DATE% %TIME%) >> %MCAFEELOG%
CALL %SUBSCRIPTS%\Uninstall-EPOAgent.cmd %SUBSCRIPTS% %EPOPATH% %McAfeeClientsTemp% %MCAFEELOG% %CHECKVERSIONS%
IF "%ERROR%"=="1" (GOTO ERROR)
GOTO COMPLETED

:INSTALL-VSECLIENT
CALL "%SUBSCRIPTS%\WriteLog-Header.cmd" %MCAFEELOG%
ECHO.	>> %MCAFEELOG%
ECHO	MENU SELECTION: [INSTALL-VSECLIENT] (%DATE% %TIME%) >> %MCAFEELOG%
CALL %SUBSCRIPTS%\Install-VSEClient.cmd %SUBSCRIPTS% %VSEINST% %CURVSEVER% %McAfeeClientsTemp% %MCAFEELOG% %CHECKVERSIONS%
IF "%ERROR%"=="1" (GOTO ERROR)
CALL %SUBSCRIPTS%\Update-VSEClient.cmd %SUBSCRIPTS% %OSARCH% %McAfeeClientsTemp% %MCAFEELOG% %CHECKVERSIONS%
IF "%ERROR%"=="1" (GOTO ERROR)
CALL %SUBSCRIPTS%\Update-EPOAgent.cmd %SUBSCRIPTS% %OSARCH% %McAfeeClientsTemp% %MCAFEELOG% %CHECKVERSIONS%
IF "%ERROR%"=="1" (GOTO ERROR)
GOTO COMPLETED

:REINSTALL-VSECLIENT
CALL "%SUBSCRIPTS%\WriteLog-Header.cmd" %MCAFEELOG%
ECHO.	>> %MCAFEELOG%
ECHO	MENU SELECTION: [REINSTALL-VSECLIENT] (%DATE% %TIME%) >> %MCAFEELOG%
CALL %SUBSCRIPTS%\Uninstall-VSEClient.cmd %SUBSCRIPTS% %VSEPATH% %McAfeeClientsTemp% %MCAFEELOG% %CHECKVERSIONS%
IF "%ERROR%"=="1" (GOTO ERROR)
CALL %SUBSCRIPTS%\Install-VSEClient.cmd %SUBSCRIPTS% %VSEINST% %McAfeeClientsTemp% %CURVSEVER% %MCAFEELOG% %CHECKVERSIONS%
IF "%ERROR%"=="1" (GOTO ERROR)
CALL %SUBSCRIPTS%\Update-VSEClient.cmd %SUBSCRIPTS% %OSARCH% %McAfeeClientsTemp% %MCAFEELOG% %CHECKVERSIONS%
IF "%ERROR%"=="1" (GOTO ERROR)
CALL %SUBSCRIPTS%\Update-EPOAgent.cmd %SUBSCRIPTS% %OSARCH% %McAfeeClientsTemp% %MCAFEELOG% %CHECKVERSIONS%
IF "%ERROR%"=="1" (GOTO ERROR)
GOTO COMPLETED

:UNINSTALL-VSECLIENT
CALL "%SUBSCRIPTS%\WriteLog-Header.cmd" %MCAFEELOG%
ECHO.	>> %MCAFEELOG%
ECHO	MENU SELECTION: [UNINSTALL-VSECLIENT] (%DATE% %TIME%) >> %MCAFEELOG%
CALL %SUBSCRIPTS%\Uninstall-VSEClient.cmd %SUBSCRIPTS% %VSEPATH% %McAfeeClientsTemp% %MCAFEELOG% %CHECKVERSIONS%
IF "%ERROR%"=="1" (GOTO ERROR)
GOTO COMPLETED

:UPDATE-EPO
CALL "%SUBSCRIPTS%\WriteLog-Header.cmd" %MCAFEELOG%
ECHO.	>> %MCAFEELOG%
ECHO	MENU SELECTION: [UPDATE-EPO] (%DATE% %TIME%) >> %MCAFEELOG%
CALL %SUBSCRIPTS%\Update-EPOAgent.cmd %SUBSCRIPTS% %OSARCH% %McAfeeClientsTemp% %MCAFEELOG% %CHECKVERSIONS%
IF "%ERROR%"=="1" (GOTO ERROR)
GOTO COMPLETED

:UPDATE-VSE
CALL "%SUBSCRIPTS%\WriteLog-Header.cmd" %MCAFEELOG%
ECHO.	>> %MCAFEELOG%
ECHO	MENU SELECTION: [UPDATE-VSE] (%DATE% %TIME%) >> %MCAFEELOG%
CALL %SUBSCRIPTS%\Update-VSEClient.cmd %SUBSCRIPTS% %OSARCH% %McAfeeClientsTemp% %MCAFEELOG% %CHECKVERSIONS%
IF "%ERROR%"=="1" (GOTO ERROR)
GOTO COMPLETED

:SHOW-EPOMONITOR
CALL "%SUBSCRIPTS%\WriteLog-Header.cmd" %MCAFEELOG%
ECHO.	>> %MCAFEELOG%
ECHO	MENU SELECTION: [SHOW-EPOMONITOR] (%DATE% %TIME%) >> %MCAFEELOG%
CALL %SUBSCRIPTS%\Show-EPOMONITOR.cmd %EPOUPDATEFILE%
IF "%ERROR%"=="1" (GOTO ERROR)
GOTO MENU

:SHOW-APLOG
ECHO.	>> %MCAFEELOG%
ECHO	MENU SELECTION: [SHOW-APLOG] (%DATE% %TIME%) >> %MCAFEELOG%
notepad %DEFLOGDIR%\AccessProtectionLog.txt
GOTO MENU

:SHOW-OALOG
CALL "%SUBSCRIPTS%\WriteLog-Header.cmd" %MCAFEELOG%
ECHO.	>> %MCAFEELOG%
ECHO	MENU SELECTION: [SHOW-OALOG] (%DATE% %TIME%) >> %MCAFEELOG%
notepad %DEFLOGDIR%\OnAccessScanLog.txt
GOTO MENU

:SHOW-ODLOG
CALL "%SUBSCRIPTS%\WriteLog-Header.cmd" %MCAFEELOG%
ECHO.	>> %MCAFEELOG%
ECHO	MENU SELECTION: [SHOW-ODLOG] (%DATE% %TIME%) >> %MCAFEELOG%
notepad %DEFLOGDIR%\OnDemandScanLog.txt
GOTO MENU

:COMPLETED
COLOR 1a
CLS
ECHO.
ECHO	PROCESS COMPLETED!
ECHO.
ECHO.	>> %MCAFEELOG%
ECHO	[PROCESS COMPLETED] (%DATE% %TIME%) >> %MCAFEELOG%
PAUSE
GOTO TOP


:ERROR
COLOR 1c
CLS
ECHO.
ECHO	ERROR: [GENERAL]
ECHO.
ECHO	NOTES: %ERRORS%
ECHO
PAUSE
GOTO TOP

:: :MENU2
:: CLS
:: SET /P ANSWER=Return to Selection Menu (Y/N)? 
:: IF /i {%ANSWER%}=={y} (GOTO :YES)
:: IF /i {%ANSWER%}=={yes} (GOTO :YES)
:: IF /i {%ANSWER%}=={n} (GOTO :NO)
:: IF /i {%ANSWER%}=={no} (GOTO :NO)

:: ECHO.
:: ECHO "%ANSWER%" is not valid...please try again
:: PAUSE
:: GOTO :MENU2

:: :YES
:: GOTO MENU

:: :NO
:: GOTO END

:END
ECHO.
ECHO	EXITING...
CALL %SUBSCRIPTS%\WAIT.cmd 1

Exit


:: -------------------------------------------------------------------------------
:: +CHANGE LOG
:: 11/23/2011
::		Created
:: 11/29/2011
::		Changed console output to make it cleaner
:: 12/06/2011
::		Added Log File Variable, Split check versions to subscripts to
::		be able to run again after install or uninstall.
::		Fixed log section names that were all APlog
:: 12/08/2011
::		Cleaned up some code and added more comments
:: 01/03/2012
::		Changed several subscripts working to fix Windows 2000 EPO Agent install issue.
:: 03/26/2012
::		Updated to McAfee Agent 4.6.0 Patch 1 (4.6.0.2292)
::		Added updatedate variable
:: 10/23/2012
::		Updated to McAfee Agent 4.6.0 Patch 2 (4.6.0.2935)
::		Updated to VSE 8.8.0 Patch 2 (4.6.0.975)
:: 10/24/2012
::		Added Supported OS varible and output
:: 11/28/2012
::		Moved EPU Update to end of installs
:: 12/04/2012
::		Changed MCTEMP Variable name to McAfeeClientsTemp
::		Added WindowsScriptTemp as root directory 
::		Added section to cleanup old temp directory, move log to new directory and rename log
::		Added Errors variable for Error section output
::		Added some error output
:: 02/22/2013
::		Changed McAfee Agent to 4.6.0.3122
::		Changed VSE Client to 8.8.0.1128
:: -------------------------------------------------------------------------------	

