$gpu = Get-CimInstance Win32_VideoController | Where-Object { $_.Name -match 'Radeon|AMD|RX' } | Select-Object -First 1
if ($gpu) {
    Write-Host ("[OK] Placa detectada: " + $gpu.Name) -ForegroundColor Green
    Write-Host ("     Driver: " + $gpu.DriverVersion) -ForegroundColor Gray
} else {
    Write-Host "[AVISO] Nenhuma placa AMD detectada pelo Windows." -ForegroundColor Yellow
}

$path = 'HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers'
$tdr = (Get-ItemProperty -Path $path -Name 'TdrDelay' -ErrorAction SilentlyContinue).TdrDelay
$tdrDdi = (Get-ItemProperty -Path $path -Name 'TdrDdiDelay' -ErrorAction SilentlyContinue).TdrDdiDelay

if ($tdr -ge 8 -and $tdrDdi -ge 8) {
    Write-Host ("[OK] Vacina Anti-Crash (TDR Delay) ATIVA no Windows (Delay: " + $tdr + "s)!") -ForegroundColor Green
    Write-Host "     Seu sistema está protegido contra congelamento no Frame Generation." -ForegroundColor Gray
} else {
    Write-Host "[ATENCAO] A Vacina Anti-Crash AINDA NAO foi aplicada!" -ForegroundColor Red
    Write-Host "          Execute o arquivo: EXECUTAR_PRIMEIRO-1_Ativar_TDR_Delay_Anti_Crash.reg" -ForegroundColor Yellow
    Write-Host "          e reinicie o computador antes de jogar." -ForegroundColor Yellow
}
