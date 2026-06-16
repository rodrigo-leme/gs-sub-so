# ============================================================================
# Script 06: Configuração do IIS
# Projeto: GS Operating Systems - Space Code LTDA
# ============================================================================
# Site: SpaceCode em C:\inetpub\spacecode
# Binding: spacecode.local (port 80)
# CGI: Python backend para formulário de contato
# ============================================================================

Import-Module WebAdministration

$sitePath = "C:\inetpub\spacecode"
$pythonPath = (Get-Command python -ErrorAction SilentlyContinue).Source
if (-not $pythonPath) { $pythonPath = "C:\Python312\python.exe" }
$repoPath = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$websitePath = "$repoPath\website"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Configurando IIS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "[*] Python: $pythonPath" -ForegroundColor Yellow

# --- Criar diretórios ---
Write-Host "`n[+] Criando diretórios..." -ForegroundColor Yellow
New-Item -Path $sitePath -ItemType Directory -Force | Out-Null
New-Item -Path "$sitePath\img" -ItemType Directory -Force | Out-Null
New-Item -Path "$sitePath\css" -ItemType Directory -Force | Out-Null
New-Item -Path "$sitePath\js" -ItemType Directory -Force | Out-Null
New-Item -Path "$sitePath\backend" -ItemType Directory -Force | Out-Null
Write-Host "    [OK] Diretórios criados" -ForegroundColor Green

# --- Copiar arquivos do website ---
Write-Host "[+] Copiando arquivos do website..." -ForegroundColor Yellow
if (Test-Path $websitePath) {
    Copy-Item -Path "$websitePath\*" -Destination $sitePath -Recurse -Force
    Write-Host "    [OK] Arquivos copiados de $websitePath" -ForegroundColor Green
} else {
    Write-Host "    [WARN] Pasta website não encontrada em $websitePath" -ForegroundColor Yellow
}

# --- Parar Default Web Site ---
Write-Host "[+] Parando Default Web Site..." -ForegroundColor Yellow
Stop-Website -Name "Default Web Site" -ErrorAction SilentlyContinue

# --- Remover site existente ---
$existingSite = Get-Website -Name "SpaceCode" -ErrorAction SilentlyContinue
if ($existingSite) { Remove-Website -Name "SpaceCode" }

# --- Criar site ---
Write-Host "[+] Criando site SpaceCode..." -ForegroundColor Yellow
New-Website -Name "SpaceCode" -PhysicalPath $sitePath -Port 80 -Force | Out-Null
Write-Host "    [OK] Site SpaceCode criado" -ForegroundColor Green

# --- Desbloquear seções de configuração ---
Write-Host "[+] Desbloqueando seções do IIS..." -ForegroundColor Yellow
& "$env:SystemRoot\system32\inetsrv\appcmd.exe" unlock config /section:handlers 2>&1 | Out-Null
& "$env:SystemRoot\system32\inetsrv\appcmd.exe" unlock config /section:system.webServer/security/isapiCgiRestriction 2>&1 | Out-Null

# --- Configurar CGI Handler ---
Write-Host "[+] Configurando CGI Handler para Python..." -ForegroundColor Yellow
& "$env:SystemRoot\system32\inetsrv\appcmd.exe" set config "SpaceCode" /section:handlers "/+[name='Python-CGI',path='*.py',verb='GET,POST',modules='CgiModule',scriptProcessor='$pythonPath %s %s',resourceType='File']" 2>&1 | Out-Null
& "$env:SystemRoot\system32\inetsrv\appcmd.exe" set config "SpaceCode" /section:handlers /accessPolicy:"Read,Script,Execute" 2>&1 | Out-Null
Write-Host "    [OK] CGI Handler configurado" -ForegroundColor Green

# --- ISAPI/CGI Restrictions ---
Write-Host "[+] Configurando ISAPI/CGI Restrictions..." -ForegroundColor Yellow
& "$env:SystemRoot\system32\inetsrv\appcmd.exe" set config /section:isapiCgiRestriction "/+[path='$pythonPath',allowed='True',description='Python CGI']" 2>&1 | Out-Null
& "$env:SystemRoot\system32\inetsrv\appcmd.exe" set config /section:isapiCgiRestriction /notListedCgisAllowed:true 2>&1 | Out-Null
Write-Host "    [OK] CGI Restrictions configuradas" -ForegroundColor Green

# --- Permissões ---
Write-Host "[+] Configurando permissões..." -ForegroundColor Yellow
icacls $sitePath /grant "IUSR:(OI)(CI)F" /T /Q
icacls $sitePath /grant "IIS_IUSRS:(OI)(CI)F" /T /Q
Write-Host "    [OK] Permissões aplicadas" -ForegroundColor Green

# --- Hosts file ---
Write-Host "[+] Atualizando arquivo hosts..." -ForegroundColor Yellow
$hostsFile = "C:\Windows\System32\drivers\etc\hosts"
$hostsContent = Get-Content $hostsFile -Raw
if ($hostsContent -notmatch "spacecode\.local") {
    Add-Content -Path $hostsFile -Value "`n127.0.0.1 spacecode.local`n127.0.0.1 www.spacecode.local`n127.0.0.1 site.spacecode.local"
    Write-Host "    [OK] Entradas adicionadas ao hosts" -ForegroundColor Green
} else {
    Write-Host "    [*] Entradas já existem" -ForegroundColor Green
}

# --- Reiniciar IIS ---
Write-Host "[+] Reiniciando IIS..." -ForegroundColor Yellow
iisreset /restart
Start-Sleep -Seconds 2
Stop-Website -Name "Default Web Site" -ErrorAction SilentlyContinue
Start-Website -Name "SpaceCode" -ErrorAction SilentlyContinue
Write-Host "    [OK] IIS reiniciado" -ForegroundColor Green

# --- Verificação ---
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host " IIS configurado com sucesso!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Get-Website | Select-Object Name, State, PhysicalPath | Format-Table -AutoSize
Write-Host "Acesse: http://spacecode.local" -ForegroundColor Green
