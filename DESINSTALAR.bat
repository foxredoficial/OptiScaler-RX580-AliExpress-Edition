@echo off
setlocal
title Desinstalador OptiScaler RX 580
powershell.exe -NoProfile -ExecutionPolicy Bypass -STA -File "%~dp0Setup.GUI.ps1"
if errorlevel 1 pause
endlocal
