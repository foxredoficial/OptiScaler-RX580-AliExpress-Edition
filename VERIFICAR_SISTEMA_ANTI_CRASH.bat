@echo off
chcp 65001 >nul
title Verificador do Sistema - RX 580
echo ========================================================
echo   VERIFICADOR DE COMPATIBILIDADE - RX 580 (ALIEXPRESS)
echo ========================================================
echo.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Verificar.ps1"
echo.
echo ========================================================
pause
