# Scripts-oh-my-posh
# 🚀 Scripts e Configurações para Personalizar Git Bash, PowerShell, WSL e macOS

Guia rápido e definitivo para deixar seus terminais com visual moderno, produtivo e estiloso usando **Oh My Posh**.

---

## 🎨 Temas Favoritos

- `clean-detailed`
- `kushal`
- `marcduiker`
- `night-owl`
- `paradox`
- `atomic`
- `blue-owl`
- `quick-term.omp`

🔗 **Lista de temas e previews:**  
https://ohmyposh.dev/docs/themes

---

## 🎯 Meu Tema (`adriano`) — como usar o tema deste repositório

Dois temas próprios em `themes/`, só com letras coloridas (sem blocos de fundo) e a paleta do `night-owl`:

| Tema | Arquivo | Como fica |
|------|---------|-----------|
| **Completo** | `themes/adriano.omp.json` | `usuario@host  D:\caminho\completo  branch status` e, à direita, tempo do último comando, shell e hora |
| **Compacto** | `themes/adriano-compact.omp.json` | `usuario\..\pasta_atual\ branch *` (o `*` aparece se há alterações) |

Nos dois, o `❯` da segunda linha fica verde e vira **vermelho** quando o último comando falha.

Em **sessão SSH** o tema compacto passa a mostrar o host em amarelo (`root@asa\..\pasta\ main`), para você não rodar um comando na máquina errada. No PC local ele continua só com o usuário (`adriano\..\pasta\ main`).

### 🧠 Escolha automática do tema

O mesmo bloco de configuração escolhe o tema conforme o programa onde o terminal abriu:

| Onde o terminal abriu | Como detecta | Tema |
|-----------------------|--------------|------|
| Windows Terminal (inclusive WSL dentro dele) | `WT_SESSION` definido | **completo** |
| VS Code (e derivados: Cursor, Trae...) | `TERM_PROGRAM=vscode` | **compacto** |
| Orca IDE | `TERM_PROGRAM=Orca` | **compacto** |
| JetBrains (PyCharm, etc.) | `TERMINAL_EMULATOR` definido | **compacto** |
| Qualquer outro | nenhuma das anteriores | **compacto** |

### 1️⃣ Clonar o repositório

```bash
git clone https://github.com/adrianosantostreina/script-oh-my-posh.git ~/script-oh-my-posh
```

### 2️⃣ Ativar no shell

**PowerShell** — abrir o perfil e colar o conteúdo de [`snippets/oh-my-posh.ps1`](snippets/oh-my-posh.ps1):

```powershell
notepad $PROFILE
```

**Git Bash, WSL (bash) e zsh** — editar o arquivo do shell e colar o conteúdo de [`snippets/oh-my-posh.sh`](snippets/oh-my-posh.sh):

```bash
nano ~/.bashrc      # no zsh: nano ~/.zshrc
```

Ajuste só as variáveis do topo do bloco:

| Variável | O que é | Exemplo |
|----------|---------|---------|
| `_posh_shell` | shell | `bash` ou `zsh` |
| `_posh_bin` | executável do Oh My Posh | `oh-my-posh` (no Git Bash: `/c/Users/SEU_USUARIO/AppData/Local/Programs/oh-my-posh/bin/oh-my-posh.exe`) |
| `_posh_temas` | pasta `themes` deste repositório | `$HOME/script-oh-my-posh/themes` (WSL usando o clone do Windows: `/mnt/d/.../script-oh-my-posh/themes`) |
| `_posh_completo` / `_posh_compacto` | nomes dos temas | `adriano` / `adriano-compact` |

Aplicar sem fechar o terminal:

```bash
source ~/.bashrc     # PowerShell: . $PROFILE
```

> Se a pasta de temas não for encontrada, o shell sobe com o tema padrão do Oh My Posh em vez de ficar sem prompt.

**Servidores (VPS via SSH)** — pelo SSH as variáveis do terminal local (`WT_SESSION`, `TERM_PROGRAM`) não chegam ao servidor, então a escolha do tema é pela **largura do terminal**: 130 colunas ou mais usa o completo, menos que isso usa o compacto. Use [`snippets/oh-my-posh-servidor.sh`](snippets/oh-my-posh-servidor.sh) no fim do `~/.bashrc` do servidor (já traz a guarda para shell não interativo, para não atrapalhar `ssh host comando`). Para mudar o limite, edite `_posh_largura_min`. Atualizar os temas no servidor: `git -C ~/script-oh-my-posh pull`.

### 3️⃣ Testar e ajustar

Experimentar um tema só na sessão atual (fechar o terminal desfaz):

```bash
eval "$(oh-my-posh init bash --config ~/script-oh-my-posh/themes/adriano-compact.omp.json)"
```

```powershell
oh-my-posh init pwsh --config "$HOME\script-oh-my-posh\themes\adriano-compact.omp.json" | Invoke-Expression
```

Simular o prompt de outro ambiente (sem abrir o programa):

```bash
TERM_PROGRAM=vscode bash -i        # compacto
env -u TERM_PROGRAM WT_SESSION=x bash -i   # completo
```

**Trocar cores:** as cores ficam no bloco `palette` no topo de cada `.omp.json` (`user`, `sep`, `folder`, `branch`, `dirty`, `ok`, `err`). Basta editar o hexadecimal; vale para todos os segmentos.

### ⚠️ Requisitos

- **Nerd Font** no terminal. No VS Code, defina `terminal.integrated.fontFamily` com a mesma fonte (ex.: `3270 Nerd Font`), senão os ícones viram quadradinhos.
- Oh My Posh 25 ou superior (testado com 25.3, 26.8 e 26.25).

---

## 📋 Banner de entrada (`scripts/info.sh`)

Resumo do ambiente que aparece ao abrir o terminal (WSL, VPS ou Windows/Git Bash): usuário@máquina, data, uptime, sistema, disco, RAM, CPU e tráfego, com barras coloridas e tudo alinhado.

```
WSL - Adriano Santos Treinamentos
────────────────────────────────────────────────────────
Usuário       ubuntu22@adrianosantospro
Data          24/10/2026  01:27:50 (-03)
Disco (/)     ░░░░░░░░░░ 3%  22G de 1007G, 935G livres
RAM           ░░░░░░░░░░ 4%  740M de 15G, 14G disponíveis
CPU           ░░░░░░░░░░ 0%  (média de 2s)
Rede          eth0    ↓    212 B/s   ↑      0 B/s
```

- Título mostra **WSL** ou **VPS** automaticamente.
- Só usa `/proc`, `df`, `free`, `uptime` e `awk` (não precisa do `sysstat`/`sar`).
- Fica em **silêncio** fora de terminal interativo (`bash -lc`, tarefas do VS Code, `ssh host comando`). Para forçar: `info.sh -f`.
- Leva ~2 s, que é a janela de medição de CPU e rede.

**Instalar** (Ubuntu/WSL ou VPS):

```bash
mkdir -p ~/scripts
cp ~/script-oh-my-posh/scripts/info.sh ~/scripts/info.sh
chmod +x ~/scripts/info.sh
echo '[ -x "$HOME/scripts/info.sh" ] && "$HOME/scripts/info.sh"' >> ~/.profile
```

**No Windows (Git Bash)** o mesmo script reconhece o ambiente e mostra: discos C: e D: (com aviso ⚠ acima de 90%), RAM, CPU, GPU NVIDIA (se houver), rede (todas as interfaces) e versões de bash, git, node e python.

```
Windows - Adriano Santos Treinamentos
────────────────────────────────────────────────────────
Disco C:      █████████░ 93%  1.7T de 1.9T, 136G livres  ⚠
Disco D:      ███████░░░ 67%  617G de 932G, 315G livres
RAM           ████████░░ 81%  26G de 32G, 6.1G livres
CPU           ██░░░░░░░░ 16%  (média de 1s)
GPU           ████░░░░░░ 41%  33°C  RTX 3050, 2.4G de 8.0G de VRAM
Rede          todas   ↓ 735.1 kB/s   ↑ 120.5 kB/s
Ferramentas   bash 5.2.37  ·  git 2.51.1  ·  node 24.18.0  ·  python 3.14.3
```

- **Windows Terminal:** banner completo. **VS Code, Orca e JetBrains:** só uma linha (`Windows  RAM 6.0G livres de 32G  ·  C: 93%  ·  D: 67%`), para não quebrar em janelas pequenas.
- Roda direto do repositório (um `git pull` atualiza) e uma vez por terminal. Adicione ao fim do `~/.bashrc`:

```bash
_info_sh="$HOME/script-oh-my-posh/scripts/info.sh"
if [ -z "$INFO_BANNER_FEITO" ] && [ -x "$_info_sh" ]; then
  export INFO_BANNER_FEITO=1
  "$_info_sh"
fi
unset _info_sh
```

**PowerShell e CMD** usam o **mesmo** `info.sh`, chamado pelo `bash.exe` do Git (um arquivo só para manter, banner idêntico).

PowerShell: adicionar ao fim do `$PROFILE` (`notepad $PROFILE`):

```powershell
$InfoBash = 'C:\Program Files\Git\bin\bash.exe'
$InfoScript = "$HOME\script-oh-my-posh\scripts\info.sh"
if ((Test-Path $InfoBash) -and (Test-Path $InfoScript) -and ($Host.Name -eq 'ConsoleHost') -and (-not [Console]::IsOutputRedirected)) {
    & $InfoBash $InfoScript
}
```

CMD: o CMD não tem profile. Para o banner aparecer só no perfil do Windows Terminal, troque a `commandline` do perfil "Prompt de comando" no `settings.json` do Windows Terminal (não use `AutoRun` do registro: ele roda em todo `cmd /c` e quebra scripts):

```json
"commandline": "%SystemRoot%\\System32\\cmd.exe /k \"\"C:\\Program Files\\Git\\bin\\bash.exe\" \"C:\\caminho\\script-oh-my-posh\\scripts\\info.sh\" 2>nul\""
```

- Se o Git ou o repositório não estiverem no caminho, nada é mostrado (o CMD abre normalmente).
- Fora de um console real (saída redirecionada, ferramentas, `powershell -Command`), o PowerShell fica em silêncio.

---

## 🪟 Windows Terminal (cores, menu e ícones)

Backup da configuração em [`windows-terminal/settings.json`](windows-terminal/settings.json):

| Perfil | Fundo | Observação |
|--------|-------|------------|
| Ubuntu 22 e Ubuntu ZSH Quick Term | rosa-escuro `#2A0A20` | mesma distro, mesma cor |
| Ubuntu-24.04 | azul-noite `#011627` | |
| Windows PowerShell | azul `#153369` | |
| Prompt de comando (CMD) | carvão `#0C0C0C` | roda o banner `info.sh` ao abrir |
| VPS Hostinger | vermelho-escuro `#2E0B0B` | `ssh vps`; vermelho para lembrar que é produção |

- Opacidade **93** em todos os perfis, fonte **3270 Nerd Font Mono** 16.
- Menu da seta para baixo: Git Bash, Ubuntu 22, Ubuntu-24.04, Ubuntu ZSH, Hermes-Ensaio, separador, **VPS Hostinger**, separador, PowerShell, CMD e o restante.
- Paleta Night Owl em todos os esquemas (`schemes` no arquivo).

**Aplicar** (faça backup do atual antes):

```powershell
$ls = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
Copy-Item "$ls\settings.json" "$ls\settings.json.bak" -Force
Copy-Item .\windows-terminal\settings.json "$ls\settings.json" -Force
```

Ajuste no arquivo os caminhos do `info.sh` (perfil CMD) para onde você clonou o repositório e confira os `guid` dos perfis do WSL, que mudam de máquina para máquina.

**Ícones do Ubuntu** (o Windows Terminal só lê arquivos dentro da pasta dele; copiados dos pacotes instalados):

```powershell
$ic = "$ls\icons"; New-Item -ItemType Directory -Force $ic | Out-Null
Copy-Item "$((Get-AppxPackage -Name CanonicalGroupLimited.Ubuntu).InstallLocation)\Assets\Square44x44Logo.targetsize-256.png" "$ic\ubuntu.png"
Copy-Item "$((Get-AppxPackage -Name CanonicalGroupLimited.Ubuntu24.04LTS).InstallLocation)\Assets\Square44x44Logo.targetsize-256.png" "$ic\ubuntu-24.04.png"
```

**Atalho para a VPS** (`ssh vps`): crie `~/.ssh/config` com o seu servidor (o arquivo real não vai para o repositório):

```
Host vps
    HostName SEU_IP
    User root
    IdentityFile ~/.ssh/SUA_CHAVE_SEM_PASSPHRASE
    IdentitiesOnly yes
    ServerAliveInterval 30
    ServerAliveCountMax 4
```

**Painel lateral para o Git Bash** (`scripts/painel.sh`): o Windows Terminal não tem barra de status nem painel fixo, então a ação **Git Bash + Painel** abre uma aba do Git Bash com um painel estreito à direita (30% da largura) que se atualiza sozinho a cada ~3 s: discos (⚠ acima de 90%), RAM, CPU, GPU NVIDIA, rede e os 5 processos que mais usam memória.

```
Painel · Windows   01:57:22
──────────────────────────────────
Disco
 C: █████████░ 93% ⚠
    136G livres de 1.9T
 RAM ████████░░ 83%
 CPU ██░░░░░░░░ 21%
 GPU █░░░░░░░░░ 11%  32°C
 ↓ 16.2 kB/s
 ↑ 10.6 kB/s
Mais memória
 claude.exe             5.1G
```

- **Abrir:** `Ctrl+Alt+G`, ou menu da seta para baixo → "Git Bash + Painel". Um Git Bash normal continua abrindo sem painel.
- **Como é feito** (já está no `windows-terminal/settings.json`): um perfil escondido "Painel Git Bash" que roda o `painel.sh`, uma ação `User.gitBashComPainel` (`multipleActions`: `newTab` → `splitPane` à direita com `size` 0.3 → `moveFocus` à esquerda), o atalho e a entrada no menu.
- **Largura do painel:** mude o `size` da ação (0.3 = 30%). **Atualização:** mude `JANELA` no `painel.sh`.
- Testar sem abrir o Windows Terminal: `scripts/painel.sh -1` (desenha uma vez e sai).

---

## 🔤 Instalação Geral — Fontes Nerd

Para todos os terminais é necessário instalar uma **Nerd Font**.

Fonte utilizada no exemplo: **3270 Nerd Font**  
🔗 Download das fontes: https://www.nerdfonts.com/font-downloads

**Configuração no Windows Terminal:**
- **Configurações → Padrões → Aparência → Fonte**
- Escolha a fonte **3270 Nerd Font** e salve.

---

# ⚡ Instalação no PowerShell

### 🚀 Instalação do Oh My Posh

```powershell
winget install JanDeDobbeleer.OhMyPosh
```

### 🔐 Permitir execução de scripts

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### 📜 Criar e editar o perfil

```powershell
New-Item -Path $PROFILE -ItemType File -Force
notepad $PROFILE
```

### ✍️ Adicionar no perfil (exemplo com tema `atomic`)

```powershell
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\atomic.omp.json" | Invoke-Expression
```

### 🎨 Ver temas disponíveis

```powershell
Get-ChildItem "$env:POSH_THEMES_PATH" -Filter *.omp.json
```

---

# ⚡ Instalação no Git Bash (Windows Terminal)

### 🚀 Instalação do Oh My Posh

```bash
winget install JanDeDobbeleer.OhMyPosh
```

### 📜 Editar o arquivo `.bashrc`

```bash
nano ~/.bashrc
```

### ✍️ Adicionar no final

```bash
eval "$(/c/Users/SEU_USUARIO/AppData/Local/Programs/oh-my-posh/bin/oh-my-posh.exe init bash --config ~/.myposh.omp.json)"
```

> 🔥 Ajuste corretamente o caminho do executável e do tema.

```bash
source ~/.bashrc
```

---

# 🐧 Instalação no WSL (Ubuntu, Debian, Kali, etc.)

### 🚀 Instalar Oh My Posh

```bash
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh
```

### 🎨 Baixar temas

```bash
mkdir -p ~/.poshthemes
wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip
unzip ~/.poshthemes/themes.zip -d ~/.poshthemes
chmod u+rw ~/.poshthemes/*.omp.json
rm ~/.poshthemes/themes.zip
```

### ✍️ Editar `.bashrc`

```bash
nano ~/.bashrc
```

Adicionar:

```bash
eval "$(oh-my-posh init bash --config ~/.poshthemes/paradox.omp.json)"
```

```bash
source ~/.bashrc
```

---

# 🍎 Instalação no macOS (Terminal ZSH)

O macOS já utiliza **ZSH como shell padrão**, então a configuração é direta.

---

## 🍺 1️⃣ Instalar Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Adicionar ao PATH (Apple Silicon):

```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

Testar:

```bash
brew --version
```

---

## 🎨 2️⃣ Instalar Nerd Font

```bash
brew install --cask font-3270-nerd-font
```

Aplicar no Terminal:

- Terminal → Settings (⌘ ,)
- Profiles → Text → Font
- Escolha **3270 Nerd Font**

---

## 🚀 3️⃣ Instalar Oh My Posh

```bash
brew install jandedobbeleer/oh-my-posh/oh-my-posh
```

Testar:

```bash
oh-my-posh --version
```

---

## ⚡ 4️⃣ Ativar no ZSH

Editar:

```bash
nano ~/.zshrc
```

Adicionar:

```bash
eval "$(oh-my-posh init zsh --config $(brew --prefix oh-my-posh)/themes/paradox.omp.json)"
```

Aplicar:

```bash
source ~/.zshrc
```

---

# 🧠 Instalando e Configurando o ZSH no Linux

```bash
sudo apt update
sudo apt install -y zsh
```

Executar:

```bash
zsh
```

Se aparecer o menu inicial:

```
(0) Exit, creating the file ~/.zshrc containing just a comment.
```

Instalar Oh My Zsh:

```bash
sudo apt install -y curl
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Adicionar Oh My Posh no `.zshrc`:

```bash
eval "$(oh-my-posh init zsh --config ~/.poshthemes/night-owl.omp.json)"
```

---

# 🔧 Ferramentas adicionais (Linux / macOS)

```bash
sudo apt update
sudo apt install -y fzf bat ripgrep htop ncdu tmux
```

No macOS:

```bash
brew install fzf bat ripgrep htop ncdu tmux
```

---

## 🚀 Instalando o Fastfetch (Linux)

```bash
sudo apt install -y build-essential cmake pkg-config git
git clone https://github.com/fastfetch-cli/fastfetch.git
cd fastfetch
mkdir -p build && cd build
cmake ..
make -j$(nproc)
sudo make install
```

Usar:

```bash
fastfetch
```

---

## 🖥️ Git Bash
![Git Bash](https://github.com/adrianosantostreina/script-oh-my-posh/blob/master/img/GitBash.png)

## 🐧 Ubuntu WSL
![Ubuntu WSL](https://github.com/adrianosantostreina/script-oh-my-posh/blob/master/img/Ubuntu.png)

## 💻 ZSH Turbo
![ZSH](https://github.com/adrianosantostreina/script-oh-my-posh/blob/master/img/ZSH.png)

## 💻 PowerShell
![PowerShell](https://github.com/adrianosantostreina/script-oh-my-posh/blob/master/img/PowerShell.png)

---

## 🏁 Missão concluída.

Terminal de guerreiro, visual de CEO, produtividade de hacker. 😎🚀
