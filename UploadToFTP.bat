@ECHO OFF
SETLOCAL EnableExtensions

REM Connection information:
SET Server=50.1.2.90
SET usrname=anonymous
SET pssword=

REM ---- Do not modify anything below this line ----

SET Commands="%TEMP%SendToFTP_commands.txt"

REM FTP user name and password. No spaces after either.
ECHO %usrname%> %Commands%
ECHO %password%>> %Commands%

REM FTP transfer settings.
ECHO binary >> %Commands%

IF /I {%1}=={/L} (
	REM Add file(s) to the list to be FTP'ed.
	FOR /F "usebackq tokens=*" %%I IN ("%~dpnx2") DO ECHO put %%I >> %Commands%
) ELSE (
	ECHO put "%~dpnx1" >> %Commands%
)

REM Close the FTP connection.
ECHO close >> %Commands%
ECHO bye   >> %Commands%

REM Perform the FTP.
FTP -d -i -s:%Commands% %Server%

ECHO.
ECHO.

REM Clean up.
IF EXIST %Commands% DEL %Commands%

ENDLOCAL