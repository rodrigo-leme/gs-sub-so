# ============================================================================
# Script 04: Configuração de GPOs (Group Policy Objects)
# Projeto: GS Operating Systems - Space Code LTDA
# ============================================================================
# GPO_Back:  Bloquear Painel de Controle, USB, Regedit
# GPO_Front: Bloquear Painel de Controle, USB, Regedit
# GPO_PM:    Bloquear Painel de Controle, USB, Regedit, CMD, Gerenciador de Tarefas
# GPO_Wallpaper: Wallpaper corporativo para todos
# ============================================================================

Import-Module GroupPolicy

$domain = "spacecode.local"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Configurando GPOs" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# --- Função auxiliar para setar registry-based policies ---
function Set-GPRegistryPolicy {
    param(
        [string]$GPOName,
        [string]$Key,
        [string]$ValueName,
        [string]$Type,
        $Value
    )
    Set-GPRegistryValue -Name $GPOName -Key $Key -ValueName $ValueName -Type $Type -Value $Value -Domain $domain
}

# ===================== GPO_Back =====================
Write-Host "`n[+] Criando GPO_Back..." -ForegroundColor Yellow
New-GPO -Name "GPO_Back" -Domain $domain | Out-Null

# Bloquear Painel de Controle
Set-GPRegistryPolicy -GPOName "GPO_Back" `
    -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" `
    -ValueName "NoControlPanel" -Type DWord -Value 1

# Bloquear USB (Deny Write + Deny Read para Removable Storage)
Set-GPRegistryPolicy -GPOName "GPO_Back" `
    -Key "HKCU\Software\Policies\Microsoft\Windows\RemovableStorageDevices\{53f5630d-b6bf-11d0-94f2-00a0c91efb8b}" `
    -ValueName "Deny_Read" -Type DWord -Value 1
Set-GPRegistryPolicy -GPOName "GPO_Back" `
    -Key "HKCU\Software\Policies\Microsoft\Windows\RemovableStorageDevices\{53f5630d-b6bf-11d0-94f2-00a0c91efb8b}" `
    -ValueName "Deny_Write" -Type DWord -Value 1

# Bloquear Regedit
Set-GPRegistryPolicy -GPOName "GPO_Back" `
    -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
    -ValueName "DisableRegistryTools" -Type DWord -Value 1

# Linkar na OU Back
New-GPLink -Name "GPO_Back" -Target "OU=Back,DC=spacecode,DC=local" -Domain $domain
Write-Host "    [OK] GPO_Back criada e linkada na OU Back" -ForegroundColor Green

# ===================== GPO_Front =====================
Write-Host "`n[+] Criando GPO_Front..." -ForegroundColor Yellow
New-GPO -Name "GPO_Front" -Domain $domain | Out-Null

# Bloquear Painel de Controle
Set-GPRegistryPolicy -GPOName "GPO_Front" `
    -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" `
    -ValueName "NoControlPanel" -Type DWord -Value 1

# Bloquear USB
Set-GPRegistryPolicy -GPOName "GPO_Front" `
    -Key "HKCU\Software\Policies\Microsoft\Windows\RemovableStorageDevices\{53f5630d-b6bf-11d0-94f2-00a0c91efb8b}" `
    -ValueName "Deny_Read" -Type DWord -Value 1
Set-GPRegistryPolicy -GPOName "GPO_Front" `
    -Key "HKCU\Software\Policies\Microsoft\Windows\RemovableStorageDevices\{53f5630d-b6bf-11d0-94f2-00a0c91efb8b}" `
    -ValueName "Deny_Write" -Type DWord -Value 1

# Bloquear Regedit
Set-GPRegistryPolicy -GPOName "GPO_Front" `
    -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
    -ValueName "DisableRegistryTools" -Type DWord -Value 1

# Linkar na OU Front
New-GPLink -Name "GPO_Front" -Target "OU=Front,DC=spacecode,DC=local" -Domain $domain
Write-Host "    [OK] GPO_Front criada e linkada na OU Front" -ForegroundColor Green

# ===================== GPO_PM =====================
Write-Host "`n[+] Criando GPO_PM..." -ForegroundColor Yellow
New-GPO -Name "GPO_PM" -Domain $domain | Out-Null

# Bloquear Painel de Controle
Set-GPRegistryPolicy -GPOName "GPO_PM" `
    -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" `
    -ValueName "NoControlPanel" -Type DWord -Value 1

# Bloquear USB
Set-GPRegistryPolicy -GPOName "GPO_PM" `
    -Key "HKCU\Software\Policies\Microsoft\Windows\RemovableStorageDevices\{53f5630d-b6bf-11d0-94f2-00a0c91efb8b}" `
    -ValueName "Deny_Read" -Type DWord -Value 1
Set-GPRegistryPolicy -GPOName "GPO_PM" `
    -Key "HKCU\Software\Policies\Microsoft\Windows\RemovableStorageDevices\{53f5630d-b6bf-11d0-94f2-00a0c91efb8b}" `
    -ValueName "Deny_Write" -Type DWord -Value 1

# Bloquear Regedit
Set-GPRegistryPolicy -GPOName "GPO_PM" `
    -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
    -ValueName "DisableRegistryTools" -Type DWord -Value 1

# Bloquear CMD
Set-GPRegistryPolicy -GPOName "GPO_PM" `
    -Key "HKCU\Software\Policies\Microsoft\Windows\System" `
    -ValueName "DisableCMD" -Type DWord -Value 1

# Bloquear Gerenciador de Tarefas
Set-GPRegistryPolicy -GPOName "GPO_PM" `
    -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
    -ValueName "DisableTaskMgr" -Type DWord -Value 1

# Linkar na OU PM
New-GPLink -Name "GPO_PM" -Target "OU=PM,DC=spacecode,DC=local" -Domain $domain
Write-Host "    [OK] GPO_PM criada e linkada na OU PM" -ForegroundColor Green

# ===================== GPO_Wallpaper =====================
Write-Host "`n[+] Criando GPO_Wallpaper..." -ForegroundColor Yellow
New-GPO -Name "GPO_Wallpaper" -Domain $domain | Out-Null

# Definir wallpaper (usa imagem do site)
$wallpaperPath = "C:\inetpub\spacecode\img\wallpaper-spacecode.jpg"

Set-GPRegistryPolicy -GPOName "GPO_Wallpaper" `
    -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
    -ValueName "Wallpaper" -Type String -Value $wallpaperPath

Set-GPRegistryPolicy -GPOName "GPO_Wallpaper" `
    -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
    -ValueName "WallpaperStyle" -Type String -Value "2"

# Linkar no domínio inteiro (para todos os usuários)
New-GPLink -Name "GPO_Wallpaper" -Target "DC=spacecode,DC=local" -Domain $domain
Write-Host "    [OK] GPO_Wallpaper criada e linkada no domínio" -ForegroundColor Green

# --- Resumo ---
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host " GPOs configuradas com sucesso!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Get-GPO -All -Domain $domain | Format-Table DisplayName, Id -AutoSize
