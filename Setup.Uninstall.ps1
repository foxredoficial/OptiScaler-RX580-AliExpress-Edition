param(
    [Parameter(Mandatory=$true)][string]$GameDir
)
$ErrorActionPreference='Stop'

$game = (Resolve-Path -LiteralPath $GameDir).Path
if (!(Test-Path -LiteralPath $game -PathType Container)) {
    throw 'Pasta do jogo não encontrada.'
}

$running = Get-Process -ErrorAction SilentlyContinue | Where-Object {
    try { $_.Path -and ([IO.Path]::GetDirectoryName($_.Path) -eq $game) } catch { $false }
}
if ($running) {
    throw 'Feche o jogo antes de desinstalar.'
}

# 1. Remover proxies do OptiScaler
$proxies = @('dxgi.dll','winmm.dll','version.dll','winhttp.dll','wininet.dll','dbghelp.dll')
foreach ($p in $proxies) {
    $candidate = Join-Path $game $p
    if (Test-Path -LiteralPath $candidate -PathType Leaf) {
        $item = Get-Item -LiteralPath $candidate
        if ($item.VersionInfo.ProductName -match 'OptiScaler|DLSS 5 Neural' -or $item.VersionInfo.FileDescription -match 'OptiScaler|DLSS 5 Neural') {
            Remove-Item -LiteralPath $candidate -Force -ErrorAction SilentlyContinue
        }
    }
}

# 2. Remover arquivos e pastas do mod
$filesToRemove = @(
    'OptiScaler.ini',
    'OptiScaler.log',
    'dlssnr_amd_pass1.dll',
    'dlssnr_amd_pass2.dll',
    'dlssnr_amd_pass3.dll',
    'dlssnr_on_amd_weights.bin'
)
foreach ($f in $filesToRemove) {
    $target = Join-Path $game $f
    if (Test-Path -LiteralPath $target) {
        Remove-Item -LiteralPath $target -Force -ErrorAction SilentlyContinue
    }
}

$dirsToRemove = @('OptiScaler', 'experimental_lighting')
foreach ($d in $dirsToRemove) {
    $target = Join-Path $game $d
    if (Test-Path -LiteralPath $target) {
        Remove-Item -LiteralPath $target -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# 3. Restaurar arquivos originais se houver backup
$latestBackup = Get-ChildItem -LiteralPath $game -Directory -Filter 'backup-amd-presr-*' -ErrorAction SilentlyContinue | Sort-Object CreationTime -Descending | Select-Object -First 1
if ($latestBackup) {
    Get-ChildItem -LiteralPath $latestBackup.FullName -Recurse -File | Where-Object { $_.Name -ne 'manifest.json' } | ForEach-Object {
        $rel = $_.FullName.Substring($latestBackup.FullName.Length).TrimStart('\')
        $dest = Join-Path $game $rel
        New-Item -ItemType Directory -Path (Split-Path -Parent $dest) -Force -ErrorAction SilentlyContinue | Out-Null
        Copy-Item -LiteralPath $_.FullName -Destination $dest -Force
    }
}

Write-Host "Mod desinstalado com sucesso de: $game"
