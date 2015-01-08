@ECHO OFF
COLOR 1f

::	-------------------------------------------------------------------------------
::		AUTHOR: Levon Becker 
::		TITLE: Get-OSVersion 
::		PURPOSE: CHECK OS VERSION
::		VERSION: 1.4
::	-------------------------------------------------------------------------------

:TESTFOREXES
:: Check if FINDSTR and WMIC are available
FINDSTR.EXE /? >NUL 2>&1
IF NOT %ERRORLEVEL%==0 (
	SET ERRORS=FINDSTR.EXE NOT FOUND
	GOTO VERQUERY
) 
WMIC.EXE /? >NUL 2>&1
IF NOT %ERRORLEVEL%==0 (
	SET ERRORS=WMIC.EXE NOT FOUND
	GOTO VERQUERY
)

:WMIQUERY
FOR /F "usebackq tokens=1,2 delims==" %%a IN (`wmic OS GET Caption /VALUE ^| findstr "Windows"`) DO SET OSVER=%%b
IF NOT %ERRORLEVEL%==0 (
	SET ERRORS=WMIC.EXE NOT FOUND
	GOTO VERQUERY
) Else (
	GOTO SORTOS
)

:SORTOS
ECHO %OSVER% | FINDSTR /C:"2012" >NUL 2>&1
IF %ERRORLEVEL%==0 (
GOTO WINLATEST)
::==================================
ECHO %OSVER% | FINDSTR /C:"Windows 8" >NUL 2>&1
IF %ERRORLEVEL%==0 (
GOTO WINLATEST)
::==================================
ECHO %OSVER% | FINDSTR /C:"Windows 7" >NUL 2>&1
IF %ERRORLEVEL%==0 (
GOTO WINLATEST)
::==================================
ECHO %OSVER% | FINDSTR /C:"2008" >NUL 2>&1
IF %ERRORLEVEL%==0 (
GOTO WINLATEST)
::==================================
ECHO %OSVER% | FINDSTR /C:"Vista" >NUL 2>&1
IF %ERRORLEVEL%==0 (
GOTO WINLATEST)
::==================================
ECHO %OSVER% | FINDSTR /C:"2003" >NUL 2>&1
IF %ERRORLEVEL%==0 (
GOTO WINLATEST)
::==================================
ECHO %OSVER% | FINDSTR /C:"Windows XP" >NUL 2>&1
IF %ERRORLEVEL%==0 (
GOTO WINXP)
::==================================
ECHO %OSVER% | FINDSTR /C:"2009" >NUL 2>&1
IF %ERRORLEVEL%==0 (
GOTO WINXP)
::==================================
ECHO %OSVER% | FINDSTR /C:"2000" >NUL 2>&1
IF %ERRORLEVEL%==0 (
GOTO WIN2K)
::==================================
ECHO %OSVER% | FINDSTR /C:"Windows ME" >NUL 2>&1
IF %ERRORLEVEL%==0 (
GOTO OSNOTSUPPORTED)
::==================================
ECHO %OSVER% | FINDSTR /C:"Windows 98" >NUL 2>&1
IF %ERRORLEVEL%==0 (
GOTO OSNOTSUPPORTED)
::==================================
ECHO %OSVER% | FINDSTR /C:"Windows 95" >NUL 2>&1
IF %ERRORLEVEL%==0 (
GOTO OSNOTSUPPORTED)
::==================================
ECHO %OSVER% | FINDSTR /C:"Windows NT" >NUL 2>&1
IF %ERRORLEVEL%==0 (
GOTO WINNT)
::==================================
:: If not found try VERQUERY lookup section
GOTO VERQUERY

:VERQUERY
ver | find "6.2.2900" > NUL
IF NOT %ERRORLEVEL%==1 (
SET OSVER=Windows 8/2012
GOTO WINLATEST)
::==================================
ver | find "6.1.760" > NUL
IF NOT %ERRORLEVEL%==1 (
SET OSVER=Windows 7/2008R2
GOTO WINLATEST)
::==================================
ver | find "6.0.6002" > NUL
IF NOT %ERRORLEVEL%==1 (
SET OSVER=Windows Vista/2008
GOTO WINLATEST)
::==================================
ver | find "5.2.4500" > NUL
IF NOT %ERRORLEVEL%==1 (
SET OSVER=Windows Home Server
GOTO WINLATEST)
::==================================
ver | find "5.2.3790" > NUL
IF NOT %ERRORLEVEL%==1 (
SET OSVER=Windows 2003
GOTO WINLATEST)
::==================================
ver | find "5.1.2600" > NUL
IF NOT %ERRORLEVEL%==1 (
SET OSVER=Windows XP
GOTO WINXP)
::==================================
ver | find "5.00.2195" > NUL
IF NOT %ERRORLEVEL%==1 (
SET OSVER=Windows 2000
GOTO WIN2K)
::==================================
ver | find "4.90.3000" > NUL
IF NOT %ERRORLEVEL%==1 (
SET OSVER=Windows ME
GOTO OSNOTSUPPORTED)
::==================================
ver | find "4.10.2222" > NUL
IF NOT %ERRORLEVEL%==1 (
SET OSVER=Windows 98 SE
GOTO OSNOTSUPPORTED)
::==================================
ver | find "4.10.1998" > NUL
IF NOT %ERRORLEVEL%==1 (
SET OSVER=Windows 98
GOTO OSNOTSUPPORTED)
::==================================
ver | find "4.0.950" > NUL
IF NOT %ERRORLEVEL%==1 (
SET OSVER=Windows 95
GOTO OSNOTSUPPORTED)
::==================================
ver | find "NT" > NUL
IF NOT %ERRORLEVEL%==1 (
SET OSVER=Windows NT
GOTO WINNT)
::==================================
SET OSVER=NOT DETERMINED
SET SUPPORTEDOS=NOT SUPPORTED
GOTO END

:OSNOTSUPPORTED
SET CUREPOVER=OS NOT SUPPORTED
SET CURVSEVER=OS NOT SUPPORTED
SET SUPPORTEDOS=NOT SUPPORTED
GOTO END

:WINNT
SET CUREPOVER=3.6.0.608
:: VSE 8.8.0 Patch 2 supports NT now
::SET CURVSEVER=8.5.0.781
SET EPOINST=\\10.179.192.45\McAfee\EPO\Windows\3.6.0.608
::SET VSEINST=\\10.179.192.45\Mcafee\VSE\Windows\8.5.0.781
SET SUPPORTEDOS=SUPPORTED
GOTO END

:WIN2K
SET CUREPOVER=4.0.0.1532
SET EPOINST=\\10.179.192.45\McAfee\EPO\Windows\4.0.0.1532
SET SUPPORTEDOS=SUPPORTED
GOTO END

:WINXP
SET SUPPORTEDOS=SUPPORTED
GOTO END

:WINLATEST
SET SUPPORTEDOS=SUPPORTED
GOTO END

:END

::	-------------------------------------------------------------------------------
::	+CHANGE LOG
::	11/28/2011: Created
:: 01/03/2012: Changed Windows 2000 EPO Agent current version to 4.0.0.1532
:: 			Plus added SET EPOINST variable for Windows NT and 2000
:: 10/23/2012: Added Windows 8 and 2012 check
::				Plus added WMI OS Lookup
:: 10/24/2012: Added SORTOS for WMI OS Lookup
::	-------------------------------------------------------------------------------	