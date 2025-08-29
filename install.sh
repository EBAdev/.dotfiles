#!/usr/bin/env bash
set -euo pipefail

OS="$(uname -s)"
DISTRO=""

if [[ "$OS" == "Darwin" ]]; then
  DISTRO="macos"
elif [[ -f /etc/os-release ]]; then
  . /etc/os-release
  DISTRO="$ID"
else
  echo "Unsupported OS: $OS"
  exit 1
fi

echo "Detected distribution: $DISTRO"

# ------------------------------------------------------------------------------
# Install Homebrew (works on macOS and Linux)
# ------------------------------------------------------------------------------
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  
  if [[ "$OS" == "Linux" ]]; then
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "$HOME/.bashrc"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  else
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
else
  echo "Homebrew already installed."
fi

# ------------------------------------------------------------------------------
# Install packages from Brewfile
# ------------------------------------------------------------------------------
if [[ -f "$PWD/Brewfile" ]]; then
  echo "Installing packages from Brewfile..."
  brew bundle --file="$PWD/Brewfile"
else
  echo "No Brewfile found. Skipping brew bundle."
fi

# ------------------------------------------------------------------------------
# Set Zsh as default shell
# ------------------------------------------------------------------------------
if command -v zsh &>/dev/null; then
  echo "Setting Zsh as default shell..."
  if ! grep -q "$(command -v zsh)" /etc/shells; then
    echo "$(command -v zsh)" | sudo tee -a /etc/shells
  fi
  chsh -s "$(command -v zsh)" "$USER" || echo "Run manually: chsh -s $(which zsh)"
else
  echo "Zsh not installed (something went wrong with brew bundle)."
fi

# ------------------------------------------------------------------------------
# Install Zsh plugins (via Oh My Zsh)
# ------------------------------------------------------------------------------
if [[ ! -d "${ZSH:-$HOME/.oh-my-zsh}" ]]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

for plugin in zsh-autosuggestions zsh-syntax-highlighting zsh-completions; do
  if [[ ! -d "$ZSH_CUSTOM/plugins/$plugin" ]]; then
    git clone "https://github.com/zsh-users/$plugin" "$ZSH_CUSTOM/plugins/$plugin"
  else
    echo "$plugin already installed."
  fi
done

if ! grep -q "zsh-autosuggestions" "$HOME/.zshrc"; then
  echo 'plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions)' >> "$HOME/.zshrc"
fi

# ------------------------------------------------------------------------------
# Neovim config
# ------------------------------------------------------------------------------
echo "Linking Neovim configuration..."
mkdir -p "$HOME/.config"
ln -snf "$PWD/nvim" "$HOME/.config/nvim"

echo "Neovim setup complete. Run nvim to trigger plugin sync."

echo "✅ Installation complete!"
ually configure Powerlevel10k by running 'p10k configure' in your new Zsh session, as well as running :Lazy inside of NeoVim"
