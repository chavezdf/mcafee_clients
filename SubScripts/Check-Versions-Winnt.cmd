@ECHO OFF
COLOR 1f

REM	-------------------------------------------------------------------------------
REM		AUTHOR: Levon Becker 
REM		TITLE: Check-Versions-Winnt 
REM		PURPOSE: Check the installed versions of McAfee Clients on Windows NT system.
REM		VERSION: 1.0
REM	-------------------------------------------------------------------------------

SET CUREPOANS=NO
SET CURVSEANS=NO

REM COPY REG.EXE LOCAL IF MISSING
IF NOT EXIST %windir%\System32\reg.exe (
	COPY %EXTRAS%\reg.exe %windir%\System32 > NUL
)

:GETEPOINFONT
REM CHECK THAT EPO IS INSTALLED
REG.exe QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Network Associates\TVD\Shared Components\Framework" /v Version > NUL: 2>&1 || GOTO NOEPONT
REM GET EPO VERSION
SET EPOVERQUERY=REG.exe QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Network Associates\TVD\Shared Components\Framework" /v Version
REM PARSE REG QUERY
FOR /F "tokens=1,2,3 delims=Z" %%a IN ('%EPOVERQUERY% ^| findstr "Version"') DO SET EPOVER=%%b
SET EPOVER=%EPOVER:~1%

REM GET EPO INSTALL DIRECTORY
SET EPOPATHQUERY=REG.exe QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Network Associates\TVD\Shared Components\Framework" /v "Installed Path"
REM PARSE REG QUERY
FOR /F "tokens=1,2 delims=Z" %%a IN ('%EPOPATHQUERY% ^| findstr "Installed Path"') DO SET EPOPATH=%%b
SET EPOPATH=%EPOPATH:~1%
GOTO GETVSEINFONT

:NOEPONT
SET EPOVER=Not Installed
SET EPOPATH=
GOTO GETVSEINFONT

:GETVSEINFONT
REM CHECK THAT VSE IS INSTALLED
REG.exe QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\McAfee\DesktopProtection" /v szProductVer > NUL: 2>&1 || GOTO NOVSENT
REM GET VSE VERSION
SET VSEVERQUERY=REG.exe QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\McAfee\DesktopProtection" /v szProductVer
REM PARSE REG QUERY
FOR /F "tokens=1,2 delims=Z" %%a IN ('%VSEVERQUERY% ^| findstr "szProductVer"') DO SET VSEVER=%%b
SET VSEVER=%VSEVER:~1%

REM GET VSE INSTALL DIRECTORY
SET VSEPATHQUERY=REG.exe QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\McAfee\DesktopProtection" /v szInstallDir
REM PARSE REG QUERY
FOR /F "tokens=1,2 delims=Z" %%a IN ('%VSEPATHQUERY% ^| findstr "szInstallDir"') DO SET VSEPATH=%%b
SET VSEPATH=%VSEPATH:~1%

REM REMOVE TRAILING BACKSLASH IN PATH
SET VSEPATH=%VSEPATH:Enterprise\=Enterprise%
GOTO END

:NOVSENT
SET VSEVER=Not Installed
SET VSEPATH=
GOTO END

:END
IF "%EPOVER%"=="%CUREPOVER%" SET CUREPOANS=YES
IF "%VSEVER%"=="%CURVSEVER%" SET CURVSEANS=YES
REM Set EPO Agent Update File Path (Need for Show-EPOMonitor)
SET EPOUPDATEFILE=%EPOPATH%\CmdAgent.exe
REM Set VSE Client Update File Path
REM SET VSEUPDATEFILE=%VSEPATH%\Mcupdate.exe


REM PARSE EXAMPLES
REM -------------------------------------------------------------------------------------------------------------------------------
REM Parse Registry query response.  Skip first two lines. Default Delimiter is a space. Set EPOVER Variable with token 3.
REM EXAMPLE:
REM (delims=<a space>)
REM Line 1 (blank)
REM Line 2 HKEY_LOCAL_MACHINE\SOFTWARE\Network Associates\TVD\Shared Components\Framework
REM Line 3    Version    REG_SZ    4.5.0.1499
REM Tokens      1(%a)     2(%%b)     3(%%c)
REM FOR /F "usebackq tokens=1,2,3" %%a IN (`%EPOVERQUERY% ^| findstr "Version"`) DO SET EPOVER=%%c 
REM -------------------------------------------------------------------------------------------------------------------------------
REM Parse Registry query response.  Skip first two lines. Default Delimiter is a space. Set EPOPATH Variable with tokens 4 and on.
REM EXAMPLE:
REM (delims=<a space>)
REM Line 1 (blank)
REM Line 2 HKEY_LOCAL_MACHINE\SOFTWARE\Network Associates\TVD\Shared Components\Framework
REM Line 3    Installed Path    REG_SZ    C:\Program Files\McAfee\Common Framework
REM Tokens      1(%a)   2(%%b)  3(%%c)       4(%%d)         5(%%e)         6(%%f)
REM FOR /F "usebackq tokens=1-3*" %%a IN (`%EPOPATHQUERY% ^| findstr "Installed Path"`) DO SET EPOPATH=%%d
REM -------------------------------------------------------------------------------------------------------------------------------
REM EXAMPLE:
REM (delims=<a space>)
REM Line 1 (blank)
REM Line 2 HKEY_LOCAL_MACHINE\SOFTWARE\McAfee\DesktopProtection
REM Line 3    szProductVer    REG_SZ    8.8.0.849
REM Tokens      1(%a)     2(%%b)     3(%%c)
REM FOR /F "usebackq tokens=1,2,3" %%a IN (`%VSEVERQUERY% ^| findstr "szProductVer"`) DO SET VSEVER=%%c
REM -------------------------------------------------------------------------------------------------------------------------------
REM EXAMPLE:
REM (delims=<a space>)
REM Line 1 (blank)
REM Line 2 HKEY_LOCAL_MACHINE\SOFTWARE\McAfee\DesktopProtection
REM Line 3    szInstallDir    REG_SZ    C:\Program Files\McAfee\VirusScan Enterprise\
REM Tokens        1(%a)       2(%%b)      3(%%c)          4(%%d)             5(%%e)
REM FOR /F "usebackq tokens=1-2*" %%a IN (`%VSEPATHQUERY% ^| findstr "szInstallDir"`) DO SET VSEPATH=%%c
REM -------------------------------------------------------------------------------------------------------------------------------

REM	-------------------------------------------------------------------------------
REM	+CHANGE LOG
REM 12/06/2011: Created
REM	-------------------------------------------------------------------------------	