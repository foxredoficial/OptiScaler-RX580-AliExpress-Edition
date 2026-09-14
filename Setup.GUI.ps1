$ErrorActionPreference='Stop'
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[Windows.Forms.Application]::EnableVisualStyles()

$form = New-Object Windows.Forms.Form
$form.Text = 'Instalador DLSS Neural - RX 580 (AliExpress)'
$form.StartPosition = 'CenterScreen'
$form.ClientSize = New-Object Drawing.Size(530, 215)
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false

# Label e campo do executável
$label = New-Object Windows.Forms.Label
$label.Location = New-Object Drawing.Point(20, 18)
$label.Size = New-Object Drawing.Size(250, 20)
$label.Text = 'Executável do Jogo (.exe):'
$form.Controls.Add($label)

$path = New-Object Windows.Forms.TextBox
$path.Location = New-Object Drawing.Point(20, 42)
$path.Size = New-Object Drawing.Size(380, 25)
$path.ReadOnly = $true
$form.Controls.Add($path)

$browse = New-Object Windows.Forms.Button
$browse.Location = New-Object Drawing.Point(410, 40)
$browse.Size = New-Object Drawing.Size(95, 29)
$browse.Text = 'Procurar...'
$form.Controls.Add($browse)

# Tipo de Proxy DLL
$dllLabel = New-Object Windows.Forms.Label
$dllLabel.Location = New-Object Drawing.Point(20, 82)
$dllLabel.Size = New-Object Drawing.Size(300, 20)
$dllLabel.Text = 'Modo de Injeção (Mantenha dxgi.dll na maioria dos jogos):'
$form.Controls.Add($dllLabel)

$dll = New-Object Windows.Forms.ComboBox
$dll.Location = New-Object Drawing.Point(20, 106)
$dll.Size = New-Object Drawing.Size(250, 25)
$dll.DropDownStyle = 'DropDownList'
@('dxgi.dll','winmm.dll','version.dll','winhttp.dll','wininet.dll','dbghelp.dll') | ForEach-Object { [void]$dll.Items.Add($_) }
$dll.SelectedIndex = 0
$form.Controls.Add($dll)

# Botões de Ação
$install = New-Object Windows.Forms.Button
$install.Location = New-Object Drawing.Point(165, 155)
$install.Size = New-Object Drawing.Size(105, 34)
$install.Text = 'Instalar'
$install.Font = New-Object Drawing.Font($install.Font.FontFamily, 9, [Drawing.FontStyle]::Bold)
$form.Controls.Add($install)

$uninstall = New-Object Windows.Forms.Button
$uninstall.Location = New-Object Drawing.Point(280, 155)
$uninstall.Size = New-Object Drawing.Size(105, 34)
$uninstall.Text = 'Desinstalar'
$form.Controls.Add($uninstall)

$cancel = New-Object Windows.Forms.Button
$cancel.Location = New-Object Drawing.Point(395, 155)
$cancel.Size = New-Object Drawing.Size(105, 34)
$cancel.Text = 'Fechar'
$cancel.DialogResult = 'Cancel'
$form.CancelButton = $cancel
$form.Controls.Add($cancel)

$picker = New-Object Windows.Forms.OpenFileDialog
$picker.Title = 'Selecione o arquivo .exe do jogo'
$picker.Filter = 'Arquivos Executáveis (*.exe)|*.exe'
$picker.CheckFileExists = $true

$browse.Add_Click({
    if ($picker.ShowDialog() -eq 'OK') {
        $path.Text = $picker.FileName
    }
})

$install.Add_Click({
    if (!(Test-Path -LiteralPath $path.Text -PathType Leaf)) {
        [void][Windows.Forms.MessageBox]::Show('Clique em Procurar e selecione o executável (.exe) do jogo.', 'Atenção', 'OK', 'Warning')
        return
    }
    $install.Enabled = $false
    $uninstall.Enabled = $false
    $form.UseWaitCursor = $true
    try {
        & (Join-Path $PSScriptRoot 'Setup.Install.ps1') -GameDir ([IO.Path]::GetDirectoryName($path.Text)) -ProxyName ([string]$dll.SelectedItem) *> $null
        [void][Windows.Forms.MessageBox]::Show("Mod instalado com sucesso!`n`nAgora abra o jogo e ative o NVIDIA DLSS nas opções de vídeo.", 'Instalação Concluída', 'OK', 'Information')
        $form.Close()
    } catch {
        [void][Windows.Forms.MessageBox]::Show($_.Exception.Message, 'Erro na Instalação', 'OK', 'Error')
    } finally {
        $form.UseWaitCursor = $false
        $install.Enabled = $true
        $uninstall.Enabled = $true
    }
})

$uninstall.Add_Click({
    if (!(Test-Path -LiteralPath $path.Text -PathType Leaf)) {
        [void][Windows.Forms.MessageBox]::Show('Clique em Procurar e selecione o executável (.exe) do jogo que deseja desinstalar.', 'Atenção', 'OK', 'Warning')
        return
    }
    $install.Enabled = $false
    $uninstall.Enabled = $false
    $form.UseWaitCursor = $true
    try {
        & (Join-Path $PSScriptRoot 'Setup.Uninstall.ps1') -GameDir ([IO.Path]::GetDirectoryName($path.Text)) *> $null
        [void][Windows.Forms.MessageBox]::Show("Mod removido com sucesso!`n`nOs arquivos originais foram restaurados.", 'Desinstalação Concluída', 'OK', 'Information')
    } catch {
        [void][Windows.Forms.MessageBox]::Show($_.Exception.Message, 'Erro na Desinstalação', 'OK', 'Error')
    } finally {
        $form.UseWaitCursor = $false
        $install.Enabled = $true
        $uninstall.Enabled = $true
    }
})

[void]$form.ShowDialog()
