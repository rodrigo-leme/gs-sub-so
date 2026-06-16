# 🚀 GS Operating Systems - Space Code LTDA

## Global Solution | Sistemas Operacionais — FIAP 2025

### Integrantes
| Nome | RM | Função |
|------|-----|--------|
| **Rodrigo Leme** | 550266 | Full-Stack, Back-End & Cloud |
| **Fabrini** | 557813 | Front-End, UI/UX |
| **Cezar Mendes** | 557724 | DevOps, Cybersecurity |

---

## 📋 Sobre o Projeto

Projeto de configuração completa de um ambiente **Windows Server 2022** para a empresa fictícia **Space Code LTDA**, incluindo:

- **Active Directory Domain Services (AD DS)** — Domínio `spacecode.local`
- **Organizational Units (OUs)** — Back, Front, PM com Sub-OUs
- **Usuários e Grupos** — 10 usuários em 3 grupos de segurança
- **Group Policy Objects (GPOs)** — Restrições de segurança por departamento
- **DNS Server** — Zona direta com registros A
- **IIS (Internet Information Services)** — Hospedagem do site institucional
- **Website institucional** — HTML5/CSS3/JS + Backend Python (CGI)
- **Formulário de contato** — Dados salvos em JSON

---

## 🏗️ Estrutura do Projeto

```
gs-sub-so/
├── scripts/
│   ├── 00-deploy-all.ps1           # Script master (executa tudo)
│   ├── 01-install-roles.ps1        # Instalação de roles
│   ├── 02-promote-dc.ps1           # Promoção a Domain Controller
│   ├── 03-create-ad-structure.ps1  # OUs, Usuários, Grupos
│   ├── 04-configure-gpos.ps1       # GPOs de segurança
│   ├── 05-configure-dns.ps1        # Zona DNS e registros
│   └── 06-configure-iis.ps1        # Configuração do IIS + CGI
├── website/
│   ├── index.html                  # Página principal
│   ├── css/
│   │   └── style.css               # Estilos (dark theme)
│   ├── js/
│   │   └── main.js                 # JavaScript interativo
│   ├── img/                        # Imagens do site
│   └── backend/
│       ├── contato.py              # Backend CGI (Python)
│       └── contatos.json           # Dados dos contatos
├── evidence/                       # Screenshots de evidência
└── README.md
```

---

## 🖥️ Configurações Implementadas

### 1. Roles Instaladas
- `AD-Domain-Services` — Active Directory
- `DNS` — Servidor DNS
- `Web-Server` — IIS
- `Web-CGI` — Suporte CGI para Python

### 2. Domain Controller
- **Domínio:** spacecode.local
- **NetBIOS:** SPACECODE
- **Senha DSRM:** P@ssw0rd!2026
- **Modo:** Sem reinicialização (`-NoRebootOnCompletion`)

### 3. Active Directory

#### OUs e Sub-OUs
| OU Principal | Sub-OU |
|-------------|--------|
| Back | Back_Devs |
| Front | Front_Devs |
| PM | PM_Users |

#### Usuários (10 total)
| Nome | Login | Departamento |
|------|-------|-------------|
| Carlos Silva | carlos.silva | Back |
| Ana Santos | ana.santos | Back |
| Pedro Lima | pedro.lima | Back |
| Julia Costa | julia.costa | Back |
| Lucas Oliveira | lucas.oliveira | Back |
| Mariana Alves | mariana.alves | Front |
| Rafael Souza | rafael.souza | Front |
| Beatriz Ferreira | beatriz.ferreira | Front |
| Rodrigo Leme* | rodrigo.leme | PM |
| Cezar Mendes | cezar.mendes | PM |

\* *Change Password at Logon* habilitado

#### Grupos de Segurança
- `GRP_Back` — Desenvolvedores Back-End
- `GRP_Front` — Desenvolvedores Front-End
- `GRP_PM` — Project Managers

### 4. GPOs

| GPO | Bloqueios | OU Vinculada |
|-----|-----------|-------------|
| GPO_Back | Painel de Controle, USB, Regedit | Back |
| GPO_Front | Painel de Controle, USB, Regedit | Front |
| GPO_PM | Painel de Controle, USB, Regedit, CMD, Gerenciador de Tarefas | PM |
| GPO_Wallpaper | Wallpaper corporativo Space Code | Domínio (todos) |

### 5. DNS
- **Zona direta:** spacecode.local
- **Registro A:** `www` → IP do servidor
- **Registro A:** `site` → IP do servidor

### 6. Website
- Site institucional com design moderno (dark theme, azul/laranja)
- Seções: Home, Quem Somos, Equipe, Serviços, Contato
- Formulário de contato com backend Python (CGI)
- Dados salvos em `contatos.json`

### 7. IIS
- Site: **SpaceCode** em `C:\inetpub\spacecode`
- Binding: `spacecode.local`
- CGI Handler para Python (`.py`)

---

## 🚀 Como Executar

### Deploy Completo (recomendado)
```powershell
# Executar como Administrador no Windows Server 2022
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
.\scripts\00-deploy-all.ps1
```

### Scripts Individuais
```powershell
# 1. Instalar roles
.\scripts\01-install-roles.ps1

# 2. Promover a Domain Controller
.\scripts\02-promote-dc.ps1

# 3. Criar estrutura AD (OUs, Usuários, Grupos)
.\scripts\03-create-ad-structure.ps1

# 4. Configurar GPOs
.\scripts\04-configure-gpos.ps1

# 5. Configurar DNS
.\scripts\05-configure-dns.ps1

# 6. Configurar IIS e deploy do site
.\scripts\06-configure-iis.ps1
```

---

## ⚠️ Observações Importantes

- **NÃO reiniciar a VM** durante o deploy — todos os scripts usam `-NoRebootOnCompletion`
- Executar **como Administrador** no PowerShell
- O Python deve estar instalado no servidor para o backend CGI funcionar
- Senha padrão dos usuários AD: `SpaceCode@2026`

---

## 📸 Evidências

As capturas de tela das configurações estão disponíveis na pasta `evidence/`:
- Active Directory Users & Computers (OUs, Usuários, Grupos)
- Group Policy Management (GPOs)
- DNS Manager (Zonas e Registros)
- IIS Manager (Sites)
- Website funcionando no navegador
- Formulário de contato com dados salvos em JSON
- Serviços Windows instalados

---

**Space Code LTDA** — *Explorando o futuro da tecnologia* ⭐
