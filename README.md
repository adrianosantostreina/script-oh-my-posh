# Scripts-oh-my-posh
# 🚀 Scripts e Configurações para Personalizar Git Bash, PowerShell e WSL no Windows Terminal

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

## 🔤 Instalação Geral — Fontes Nerd

Para todos os terminais é necessário instalar uma **Nerd Font**.

Fonte utilizada no exemplo: **3270 Nerd Font**  
🔗 Download das fontes: https://www.nerdfonts.com/font-downloads

**Configuração no Windows Terminal:**
- **Configurações → Padrões → Aparência → Fonte:**  
Escolha a fonte **3270 Nerd Font** e salve.

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

### 🔄 Testar tema rapidamente (sem alterar o perfil)

```powershell
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\jandedobbeleer.omp.json" | Invoke-Expression
```

---

# ⚡ Instalação no Git Bash (Windows Terminal)

### 🚀 Instalação do Oh My Posh (mesmo do PowerShell)

```bash
winget install JanDeDobbeleer.OhMyPosh
```

### 🔍 Localizar o executável
Use o software **Everything** para encontrar rapidamente:  
`oh-my-posh.exe`

### 📜 Editar o arquivo `.bashrc`

```bash
nano ~/.bashrc
```

### ✍️ Adicionar no final (exemplo com tema personalizado)

```bash
eval "$(/c/Users/adrianosantosnote/AppData/Local/Programs/oh-my-posh/bin/oh-my-posh.exe init bash --config ~/.myposh.omp.json)"
```

> 🔥 **Atenção:**  
Ajuste corretamente:
- Caminho do executável `oh-my-posh.exe`
- Caminho do tema `.omp.json`

### 🔄 Aplicar as alterações

```bash
source ~/.bashrc
```

---

# 🐧 Instalação no WSL (Ubuntu, Debian, Kali, etc.)

### 🚀 Instalação do Oh My Posh

```bash
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh
```

### 🎨 Baixar e configurar os temas

```bash
mkdir -p ~/.poshthemes
wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip
unzip ~/.poshthemes/themes.zip -d ~/.poshthemes
chmod u+rw ~/.poshthemes/*.omp.json
rm ~/.poshthemes/themes.zip
```

### 📜 Editar o arquivo `.bashrc`

```bash
nano ~/.bashrc
```

### ✍️ Adicionar no final

```bash
eval "$(oh-my-posh init bash --config ~/.poshthemes/paradox.omp.json)"
```

> ✔️ Troque `paradox.omp.json` pelo tema desejado.

### 🔄 Aplicar imediatamente

```bash
source ~/.bashrc
```

---

## 🔧 Ferramentas adicionais para turbinar o terminal (opcional, mas recomendado)

### 🚀 Instalação:

```bash
sudo apt update
sudo apt install -y fzf bat ripgrep htop ncdu
```

---

## 📑 Tabela de Ferramentas

| Ferramenta | O que faz                                      |
|-------------|------------------------------------------------|
| `fzf`       | Busca fuzzy pra tudo (arquivos, comandos, etc) |
| `bat`       | Alternativa ao `cat` com sintaxe colorida      |
| `ripgrep (rg)` | Busca texto extremamente rápida             |
| `htop`      | Monitor de processos interativo                |
| `ncdu`      | Análise de uso de disco no terminal            |

---

# 🐧 Instalando no Ubuntu em máquina física ou virtual

### 🚩 Importante: Instalar a fonte Nerd no sistema (não é como no Windows Terminal)

### ✔️ Baixar e instalar a fonte (exemplo com 3270 Nerd Font):

```bash
sudo mkdir -p /usr/share/fonts/nerd-fonts
cd /usr/share/fonts/nerd-fonts
sudo wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/3270.zip
sudo unzip 3270.zip
sudo rm 3270.zip
sudo fc-cache -fv
```

### ✔️ Feche o terminal ou faça logout/login no sistema.

### ✔️ Configure a fonte no terminal:

- **Menu → Preferências → [Seu perfil] → Texto → Fonte personalizada**  
→ Escolha **3270 Nerd Font Mono** (ou Complete, Regular, etc.).

> 🔥 Agora todos os caracteres especiais (como branch, status, separadores e ícones) vão aparecer corretamente no terminal.

---

## 🔧 Ferramentas adicionais para turbinar o terminal (opcional, mas recomendado)

### 🚀 Instalação:

```bash
sudo apt update
sudo apt install -y fzf bat ripgrep htop ncdu
```

---

## 📑 Tabela de Ferramentas

| Ferramenta | O que faz                                      |
|-------------|------------------------------------------------|
| `fzf`       | Busca fuzzy pra tudo (arquivos, comandos, etc) |
| `bat`       | Alternativa ao `cat` com sintaxe colorida      |
| `ripgrep (rg)` | Busca texto extremamente rápida             |
| `htop`      | Monitor de processos interativo                |
| `ncdu`      | Análise de uso de disco no terminal            |

---

# 🧠 Instalando e Configurando o ZSH no Linux

## ✔️ Instalar ZSH

```bash
sudo apt update
sudo apt install -y zsh
```

Verificar:

```bash
zsh --version
```

## ✔️ Executar ZSH sem alterar o shell padrão

```bash
zsh
```

Se aparecer o menu `zsh-newuser-install`, selecione:

```plaintext
(0) Exit, creating the file ~/.zshrc containing just a comment.
```

## ✔️ Instalar Oh My Zsh

```bash
sudo apt install -y curl
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## ✔️ Ativar Oh My Posh no ZSH

Editar `.zshrc`:

```bash
nano ~/.zshrc
```

Adicionar no final:

```bash
eval "$(oh-my-posh init zsh --config ~/.poshthemes/night-owl.omp.json)"
```

Aplicar:

```bash
source ~/.zshrc
```

## ✔️ Usar ZSH como shell padrão (opcional)

```bash
chsh -s $(which zsh)
```

Voltar para bash, se quiser:

```bash
chsh -s $(which bash)
```

## ✔️ Criar um perfil separado no GNOME Terminal (sem alterar o default)

1. **Menu → Preferências → Adicionar novo perfil**
2. Nome: **ZSH Power**
3. Aba **Comando → Executar comando personalizado:**

```bash
zsh
```

4. Aba **Texto → Fonte personalizada:**  
Selecione sua Nerd Font.

5. Salvar. Agora você escolhe na aba do terminal se quer Bash (default) ou ZSH Power.

---

## 🔧 Ferramentas adicionais para turbinar o terminal

```bash
sudo apt update
sudo apt install -y fzf bat ripgrep htop ncdu
```

Criar alias para `bat`:

```bash
echo "alias bat='batcat'" >> ~/.bashrc
source ~/.bashrc
```

---

## 📑 Tabela de Ferramentas

| Ferramenta | O que faz                                      |
|-------------|------------------------------------------------|
| `fzf`       | Busca fuzzy pra tudo (arquivos, comandos, etc) |
| `bat`       | Alternativa ao `cat` com sintaxe colorida      |
| `ripgrep (rg)` | Busca texto extremamente rápida             |
| `htop`      | Monitor de processos interativo                |
| `ncdu`      | Análise de uso de disco no terminal            |

---

## 🔧 Instalando o Tmux no Linux

O **Tmux** é um multiplexador de terminais. Permite ter várias sessões, splits e painéis dentro de uma única janela de terminal.

### ✔️ Instalação:

```bash
sudo apt update
sudo apt install -y tmux
```

### ✔️ Comandos básicos do Tmux:

| Atalho                         | O que faz                               |
|---------------------------------|-----------------------------------------|
| `tmux`                         | Inicia uma nova sessão                  |
| `Ctrl + b`, depois `%`          | Split vertical                          |
| `Ctrl + b`, depois `"`          | Split horizontal                        |
| `Ctrl + b`, depois seta         | Navegar entre painéis                   |
| `Ctrl + b`, depois `d`          | Detach (sair da sessão mas mantê-la ativa) |
| `tmux attach`                   | Reentrar na sessão atual                |

✔️ Ideal para quem trabalha com múltiplas janelas SSH, projetos, logs, etc.

## 🏁 **Missão concluída.**  
Terminal de guerreiro, visual de CEO, produtividade de hacker. 😎🚀
