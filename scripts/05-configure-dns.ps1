# ============================================================================
# Script 05: Configuração do DNS
# Projeto: GS Operating Systems - Space Code LTDA
# ============================================================================
# Zona direta: spacecode.local
# Registros A: www, site → IP do servidor
# ============================================================================

Import-Module DnsServer

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Configurando DNS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Obter IP do servidor
$serverIP = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -ne "127.0.0.1" } | Select-Object -First 1).IPAddress
Write-Host "[*] IP do servidor: $serverIP" -ForegroundColor Yellow

# A zona spacecode.local já deve existir após a promoção do DC
# Verificar e criar se necessário
$zone = Get-DnsServerZone -Name "spacecode.local" -ErrorAction SilentlyContinue
if (-not $zone) {
    Write-Host "[+] Criando zona direta spacecode.local..." -ForegroundColor Yellow
    Add-DnsServerPrimaryZone -Name "spacecode.local" -ReplicationScope Domain
    Write-Host "    [OK] Zona criada" -ForegroundColor Green
} else {
    Write-Host "[*] Zona spacecode.local já existe" -ForegroundColor Green
}

# Criar registro A para 'www'
Write-Host "`n[+] Criando registro A: www → $serverIP" -ForegroundColor Yellow
Add-DnsServerResourceRecordA -ZoneName "spacecode.local" -Name "www" -IPv4Address $serverIP -ErrorAction SilentlyContinue
Write-Host "    [OK] Registro www criado" -ForegroundColor Green

# Criar registro A para 'site'
Write-Host "`n[+] Criando registro A: site → $serverIP" -ForegroundColor Yellow
Add-DnsServerResourceRecordA -ZoneName "spacecode.local" -Name "site" -IPv4Address $serverIP -ErrorAction SilentlyContinue
Write-Host "    [OK] Registro site criado" -ForegroundColor Green

# Configurar o servidor DNS para apontar para si mesmo
Set-DnsClientServerAddress -InterfaceAlias (Get-NetAdapter | Select-Object -First 1).Name -ServerAddresses $serverIP

# --- Verificação ---
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host " Registros DNS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Get-DnsServerResourceRecord -ZoneName "spacecode.local" | Format-Table HostName, RecordType, RecordData -AutoSize
