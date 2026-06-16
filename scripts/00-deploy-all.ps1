# ============================================================================
# Script Master: Deploy Completo - Space Code LTDA
# Projeto: GS Operating Systems
# Windows Server 2022
# ============================================================================
# Executa todos os scripts na ordem correta
# IMPORTANTE: NÃO reinicia a VM em nenhum momento
# ============================================================================

$ErrorActionPreference = "Stop"
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "================================================================" -ForegroundColor Magenta
Write-Host "  SPACE CODE LTDA - Deploy Completo" -ForegroundColor Magenta
Write-Host "  GS Operating Systems - Windows Server 2022" -ForegroundColor Magenta
Write-Host "================================================================" -ForegroundColor Magenta
Write-Host ""

$scripts = @(
    @{ File = "01-install-roles.ps1";        Desc = "Instalação de Roles" },
    @{ File = "02-promote-dc.ps1";           Desc = "Promoção a Domain Controller" },
    @{ File = "03-create-ad-structure.ps1";   Desc = "Estrutura do Active Directory" },
    @{ File = "04-configure-gpos.ps1";        Desc = "Configuração de GPOs" },
    @{ File = "05-configure-dns.ps1";         Desc = "Configuração do DNS" },
    @{ File = "06-configure-iis.ps1";         Desc = "Configuração do IIS" }
)

$step = 1
foreach ($s in $scripts) {
    Write-Host "`n[$step/6] $($s.Desc)..." -ForegroundColor Cyan
    Write-Host "Executando: $($s.File)" -ForegroundColor Gray
    Write-Host "---" -ForegroundColor Gray

    try {
        & "$scriptPath\$($s.File)"
        Write-Host "`n[OK] $($s.Desc) concluído!" -ForegroundColor Green
    }
    catch {
        Write-Host "`n[ERRO] Falha em: $($s.Desc)" -ForegroundColor Red
        Write-Host "  $_" -ForegroundColor Red
        Write-Host "  Continuando com o próximo script..." -ForegroundColor Yellow
    }

    $step++
}

Write-Host "`n================================================================" -ForegroundColor Magenta
Write-Host "  Deploy concluído!" -ForegroundColor Magenta
Write-Host "================================================================" -ForegroundColor Magenta
Write-Host ""
Write-Host "Acesse o site: http://spacecode.local" -ForegroundColor Green
Write-Host "Ou: http://localhost" -ForegroundColor Green
