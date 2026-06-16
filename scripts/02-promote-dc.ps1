# ============================================================================
# Script 02: Promoção a Domain Controller
# Projeto: GS Operating Systems - Space Code LTDA
# Domínio: spacecode.local | NetBIOS: SPACECODE
# ============================================================================
# IMPORTANTE: Usa -NoRebootOnCompletion:$true para NÃO reiniciar a VM
# ============================================================================

Import-Module ADDSDeployment

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Promovendo a Domain Controller" -ForegroundColor Cyan
Write-Host " Domínio: spacecode.local" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$dsrmPassword = ConvertTo-SecureString "P@ssw0rd!2026" -AsPlainText -Force

Install-ADDSForest `
    -DomainName "spacecode.local" `
    -DomainNetbiosName "SPACECODE" `
    -SafeModeAdministratorPassword $dsrmPassword `
    -InstallDns:$true `
    -NoRebootOnCompletion:$true `
    -Force:$true

Write-Host "`n[!] Promoção concluída (sem reboot)." -ForegroundColor Yellow
Write-Host "[*] Iniciando serviços AD manualmente..." -ForegroundColor Yellow

Start-Service NTDS -ErrorAction SilentlyContinue
Start-Service DNS -ErrorAction SilentlyContinue

Write-Host "[OK] Serviços AD e DNS iniciados!" -ForegroundColor Green
