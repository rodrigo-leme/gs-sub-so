# ============================================================================
# Script 03: Criação da Estrutura do Active Directory
# Projeto: GS Operating Systems - Space Code LTDA
# ============================================================================
# Cria: OUs, Sub-OUs, Usuários, Grupos de Segurança
# ============================================================================

Import-Module ActiveDirectory

$domain = "DC=spacecode,DC=local"
$defaultPassword = ConvertTo-SecureString "SpaceCode@2026" -AsPlainText -Force

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Criando Estrutura do Active Directory" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# --- Criar OUs principais ---
Write-Host "`n[+] Criando OUs principais..." -ForegroundColor Yellow

$ous = @("Back", "Front", "PM")
foreach ($ou in $ous) {
    New-ADOrganizationalUnit -Name $ou -Path $domain -ProtectedFromAccidentalDeletion $false
    Write-Host "    OU criada: $ou" -ForegroundColor Green
}

# --- Criar Sub-OUs ---
Write-Host "`n[+] Criando Sub-OUs..." -ForegroundColor Yellow

$subOUs = @{
    "Back_Devs"  = "OU=Back,$domain"
    "Front_Devs" = "OU=Front,$domain"
    "PM_Users"   = "OU=PM,$domain"
}

foreach ($subOU in $subOUs.GetEnumerator()) {
    New-ADOrganizationalUnit -Name $subOU.Key -Path $subOU.Value -ProtectedFromAccidentalDeletion $false
    Write-Host "    Sub-OU criada: $($subOU.Key) em $($subOU.Value)" -ForegroundColor Green
}

# --- Criar Grupos de Segurança ---
Write-Host "`n[+] Criando Grupos de Segurança..." -ForegroundColor Yellow

$groups = @{
    "GRP_Back"  = "OU=Back,$domain"
    "GRP_Front" = "OU=Front,$domain"
    "GRP_PM"    = "OU=PM,$domain"
}

foreach ($grp in $groups.GetEnumerator()) {
    New-ADGroup -Name $grp.Key -GroupScope Global -GroupCategory Security -Path $grp.Value
    Write-Host "    Grupo criado: $($grp.Key)" -ForegroundColor Green
}

# --- Criar Usuários ---
Write-Host "`n[+] Criando Usuários..." -ForegroundColor Yellow

# Back (5 usuários) - na Sub-OU Back_Devs
$backUsers = @(
    @{ First = "Carlos";  Last = "Silva";    SAM = "carlos.silva"    },
    @{ First = "Ana";     Last = "Santos";   SAM = "ana.santos"      },
    @{ First = "Pedro";   Last = "Lima";     SAM = "pedro.lima"      },
    @{ First = "Julia";   Last = "Costa";    SAM = "julia.costa"     },
    @{ First = "Lucas";   Last = "Oliveira"; SAM = "lucas.oliveira"  }
)

foreach ($u in $backUsers) {
    New-ADUser `
        -Name "$($u.First) $($u.Last)" `
        -GivenName $u.First `
        -Surname $u.Last `
        -SamAccountName $u.SAM `
        -UserPrincipalName "$($u.SAM)@spacecode.local" `
        -Path "OU=Back_Devs,OU=Back,$domain" `
        -AccountPassword $defaultPassword `
        -Enabled $true `
        -PasswordNeverExpires $true
    Add-ADGroupMember -Identity "GRP_Back" -Members $u.SAM
    Write-Host "    Usuário criado: $($u.First) $($u.Last) [Back]" -ForegroundColor Green
}

# Front (3 usuários) - na Sub-OU Front_Devs
$frontUsers = @(
    @{ First = "Mariana";  Last = "Alves";    SAM = "mariana.alves"    },
    @{ First = "Rafael";   Last = "Souza";    SAM = "rafael.souza"    },
    @{ First = "Beatriz";  Last = "Ferreira"; SAM = "beatriz.ferreira" }
)

foreach ($u in $frontUsers) {
    New-ADUser `
        -Name "$($u.First) $($u.Last)" `
        -GivenName $u.First `
        -Surname $u.Last `
        -SamAccountName $u.SAM `
        -UserPrincipalName "$($u.SAM)@spacecode.local" `
        -Path "OU=Front_Devs,OU=Front,$domain" `
        -AccountPassword $defaultPassword `
        -Enabled $true `
        -PasswordNeverExpires $true
    Add-ADGroupMember -Identity "GRP_Front" -Members $u.SAM
    Write-Host "    Usuário criado: $($u.First) $($u.Last) [Front]" -ForegroundColor Green
}

# PM (2 usuários) - na Sub-OU PM_Users
$pmUsers = @(
    @{ First = "Rodrigo"; Last = "Leme";   SAM = "rodrigo.leme"  },
    @{ First = "Cezar";   Last = "Mendes"; SAM = "cezar.mendes"  }
)

foreach ($u in $pmUsers) {
    New-ADUser `
        -Name "$($u.First) $($u.Last)" `
        -GivenName $u.First `
        -Surname $u.Last `
        -SamAccountName $u.SAM `
        -UserPrincipalName "$($u.SAM)@spacecode.local" `
        -Path "OU=PM_Users,OU=PM,$domain" `
        -AccountPassword $defaultPassword `
        -Enabled $true `
        -PasswordNeverExpires $true
    Add-ADGroupMember -Identity "GRP_PM" -Members $u.SAM
    Write-Host "    Usuário criado: $($u.First) $($u.Last) [PM]" -ForegroundColor Green
}

# --- Configurar 'Change Password at Logon' para rodrigo.leme ---
Write-Host "`n[+] Configurando 'Change Password at Logon' para rodrigo.leme..." -ForegroundColor Yellow
Set-ADUser -Identity "rodrigo.leme" -ChangePasswordAtLogon $true -PasswordNeverExpires $false
Write-Host "    [OK] rodrigo.leme deve trocar senha no próximo logon" -ForegroundColor Green

# --- Resumo ---
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host " Estrutura AD criada com sucesso!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " OUs: Back, Front, PM"
Write-Host " Sub-OUs: Back_Devs, Front_Devs, PM_Users"
Write-Host " Usuários: 10 (5 Back + 3 Front + 2 PM)"
Write-Host " Grupos: GRP_Back, GRP_Front, GRP_PM"
Write-Host " Change Password at Logon: rodrigo.leme"
