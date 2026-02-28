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
