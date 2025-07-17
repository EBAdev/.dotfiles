#!/bin/bash

# install.sh - A simple script to set up dotfiles and essential tools.

# --- Configuration ---
DOTFILES_REPO="https://github.com/EBAdev/.dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles" # Directory where dotfiles will be cloned
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d%H%M%S)" # Backup existing dotfiles

# List of dotfiles/directories to symlink from the cloned repo to $HOME
# Add more as needed based on your .dotfiles structure
DOTFILES=(
    ".zshrc"
    ".p10k.zsh"
    ".gitconfig"
    ".gitignore"
    "nvim" # This assumes 'nvim' is a directory in your dotfiles repo
#    "tmux" # Assuming you have a tmux config directory
)

# --- Helper Functions ---

# Function to print messages
log() {
    echo "--> $1"
}

# Function to print errors
error() {
    echo "!!! ERROR: $1" >&2
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# --- Pre-installation Checks ---

log "Starting dotfiles installation..."

# Check if Git is installed
if ! command_exists git; then
    error "Git is not installed. Please install Git first to clone the dotfiles repository."
    log "On Debian/Ubuntu: sudo apt update && sudo apt install git"
    log "On macOS: brew install git (or install Xcode Command Line Tools)"
    exit 1
fi

# --- Backup Existing Dotfiles ---
log "Backing up existing dotfiles to $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR"
for file in "${DOTFILES[@]}"; do
    if [ -e "$HOME/$file" ]; then
        log "Moving existing $HOME/$file to $BACKUP_DIR"
        mv "$HOME/$file" "$BACKUP_DIR/"
    fi
done

# --- Clone Dotfiles Repository ---
if [ -d "$DOTFILES_DIR" ]; then
    log "Dotfiles directory $DOTFILES_DIR already exists. Pulling latest changes..."
    (cd "$DOTFILES_DIR" && git pull) || error "Failed to pull latest dotfiles."
else
    log "Cloning dotfiles repository from $DOTFILES_REPO to $DOTFILES_DIR..."
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR" || { error "Failed to clone dotfiles repository."; exit 1; }
fi

# --- OS-specific Setup ---
OS="$(uname -s)"

if [ "$OS" == "Darwin" ]; then
    log "Detected macOS. Installing Homebrew and packages..."
    # Install Homebrew if not already installed
    if ! command_exists brew; then
        log "Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || { error "Failed to install Homebrew."; exit 1; }
        eval "$(/opt/homebrew/bin/brew shellenv)" # Ensure brew is in PATH for current session
    fi

    # Run Brewfile
    if [ -f "$DOTFILES_DIR/Brewfile" ]; then
        log "Running 'brew bundle' from Brewfile..."
        brew bundle --file="$DOTFILES_DIR/Brewfile" || error "Failed to run brew bundle. Some packages might not be installed."
    else
        log "No Brewfile found in $DOTFILES_DIR. Skipping 'brew bundle'."
    fi

    # Install common macOS tools not necessarily in Brewfile
    # log "Installing common macOS tools..."
    # brew install zsh neovim tmux git-delta ripgrep fd bat tree # Add more as needed
else
    error "Currently unsupported operating system: $OS. Please install dependencies manually."
fi

# --- Symlink Dotfiles ---
log "Creating symbolic links for dotfiles..."
for file in "${DOTFILES[@]}"; do
    SOURCE="$DOTFILES_DIR/$file"
    DEST="$HOME/$file"
    if [ -e "$SOURCE" ]; then
        log "Symlinking $SOURCE to $DEST"
        ln -sf "$SOURCE" "$DEST"
    else
        error "Source file/directory not found: $SOURCE. Skipping symlink for $file."
    fi
done

# --- Zsh Setup ---
log "Setting up Zsh..."
if ! command_exists zsh; then
    error "Zsh is not installed. Please install it manually, along with its dependencies: Oh-My-Zsh, autosuggestions and highlighting"
else
    # Change default shell to zsh if not already
    if [ "$(basename "$SHELL")" != "zsh" ]; then
        log "Changing default shell to zsh. You may be prompted for your password."
        chsh -s "$(command -v zsh)" || error "Failed to change default shell to zsh. Please do it manually."
    else
        log "Zsh is already your default shell."
    fi

    # Install Oh My Zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || error "Failed to install Oh My Zsh."
    else
        log "Oh My Zsh already installed."
    fi

    # Install zsh-autosuggestions
    if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
        log "Installing zsh-autosuggestions plugin..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" || error "Failed to install zsh-autosuggestions."
    else
        log "zsh-autosuggestions already installed."
    fi

    # Install zsh-syntax-highlighting
    if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
        log "Installing zsh-syntax-highlighting plugin..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" || error "Failed to install zsh-syntax-highlighting."
    else
        log "zsh-syntax-highlighting already installed."
    fi
fi

# --- Neovim Setup ---
log "Setting up Neovim..."
if command_exists nvim; then
	log "Neovim should work"
else
    error "Neovim is not installed. Please install it manually."
fi

# --- Final Steps ---
log "Cleaning up..."
# Remove the backup directory if everything went well (optional, uncomment to enable)
# rm -rf "$BACKUP_DIR"

log "Installation complete! Please restart your terminal or run 'source ~/.zshrc'."
log "You might need to manually configure Powerlevel10k by running 'p10k configure' in your new Zsh session, as well as running :Lazy inside of NeoVim"
