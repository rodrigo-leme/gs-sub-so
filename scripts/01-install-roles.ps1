# ============================================================================
# Script 01: Instalação de Roles do Windows Server 2022
# Projeto: GS Operating Systems - Space Code LTDA
# ============================================================================
# Roles: AD-Domain-Services, DNS, Web-Server (IIS), Web-CGI
# ============================================================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Instalando Roles do Windows Server" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$roles = @(
    "AD-Domain-Services",
    "DNS",
    "Web-Server",
    "Web-CGI"
)

foreach ($role in $roles) {
    Write-Host "`n[+] Instalando: $role" -ForegroundColor Yellow
    Install-WindowsFeature -Name $role -IncludeManagementTools -ErrorAction Stop
    Write-Host "[OK] $role instalado com sucesso!" -ForegroundColor Green
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host " Todas as roles foram instaladas!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Verificação
Get-WindowsFeature | Where-Object { $_.Name -in $roles } | Format-Table Name, InstallState -AutoSize
