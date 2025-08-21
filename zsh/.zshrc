
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

DOTFILESHOME="$HOME/dotfiles"

# adding brew
if [[ $OSTYPE == darwin* ]]; then
    # initialize brew
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# cargo installation
if ! command -v cargo >/dev/null 2>&1; then
    echo "⚠️ Cargo is not installed. Installing Rust (includes Cargo)..."

    # Detect OS
    OS=$(uname -s)
    
    case "$OS" in
        Darwin|Linux)
            # Install Rust using rustup (official installer)
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
            # Add cargo to PATH for current session
            export PATH="$HOME/.cargo/bin:$PATH"
            echo "✅ Rust and Cargo installed successfully."
            ;;
        *)
            echo "❌ Unsupported OS: $OS"
            exit 1
            ;;
    esac
    if [ "$OS" == "Linux" ]; then
        sudo apt install -y build-essential
    fi

if [[ -f "$HOME/.cargo/env" ]]; then
    . "$HOME/.cargo/env"
fi

# eza for printing tree folder
if ! command -v eza >/dev/null 2>&1; then
    echo "⚠️ eza is not installed. Installing eza..."
    cargo install --locked eza
    if [ $? -eq 0 ]; then
        echo "✅ eza installed successfully."
    else
        echo "❌ Failed to install eza."
    fi
fi

# zoxide for cd replacement 
if ! command -v zoxide >/dev/null 2>&1; then
    echo "⚠️ zoxide is not installed. Installing zoxide..."
    cargo install zoxide --locked
    if [ $? -eq 0 ]; then
        echo "✅ zoxide installed successfully."
    else
        echo "❌ Failed to install zoxide."
    fi
fi
# ====================================================================================================================================
# conda initialization, uncomment if you want conda initialization
# if [ -d "$DOTFILESHOME/conda" ]; then
#     . "$DOTFILESHOME/conda/conda.sh"
# fi
# ====================================================================================================================================
if [ ! -d "$HOME/.fzf" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    yes | ~/.fzf/install
fi
fi
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# ====================================================================================================================================
# uv installation for python
if [ ! -f "$HOME/.local/bin/uv" ]; then
    eval "curl -LsSf https://astral.sh/uv/install.sh | sh"
fi
# ====================================================================================================================================
# all zinit config and plugins
ZINIT_HOME="${XDG_DATA_HOME:-$HOME}/.local/share/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
    echo "Cloning Zinit..."
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "$ZINIT_HOME/zinit.zsh"

# Plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

# uncomment if you want conda zsh completion
# zinit light conda-incubator/conda-zsh-completion

# ====================================================================================================================================

# Key binding
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# Load environment variables
export __BIRTHDAY__="11042004"
. "$HOME/.local/bin/env"

HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt share_history            # Share History Between All Sessions.
setopt hist_ignore_dups         # Do Not Record An Event That Was Just Recorded Again.
setopt hist_ignore_all_dups     # Delete An Old Recorded Event If A New Event Is A Duplicate.
setopt hist_find_no_dups        # Do Not Display A Previously Found Event.
setopt hist_ignore_space        # Do Not Record An Event Starting With A Space.
setopt hist_save_no_dups        # Do Not Write A Duplicate Event To The History File.

chmod -R +x "$DOTFILESHOME/bin/"
export PATH="$PATH:$DOTFILESHOME/bin/"

# ====================================================================================================================================
# FiraCode Nerd Font Installation

# Check if the font is already installed
if ! fc-list | grep -i "FiraCode Nerd Font" > /dev/null; then
    __fontname="FiraCode Nerd Font"
    __fontdir="$HOME/.local/share/fonts"
    __font_file="$__fontdir/FiraCode-Regular.ttf"
    __download_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip"
    __temp_dir="/tmp/fira_code_nerd_font_install"

    # Create necessary directories
    mkdir -p "$__fontdir"
    mkdir -p "$__temp_dir"
    # Download and unzip the font
    echo "Downloading $__fontname..."
    curl -L -o "$__temp_dir/FiraCode.zip" "$__download_url"
    echo "Extracting font files..."
    unzip -o "$__temp_dir/FiraCode.zip" -d "$__temp_dir"
    # Move TTF files to font directory
    find "$__temp_dir" -iname "*FiraCode*.ttf" -exec cp {} "$__fontdir/" \;
    # Clean up

    rm -rf "$__temp_dir"
    # Refresh font cache
    echo "Updating font cache..."
    fc-cache -f "$__fontdir"
    echo "$__fontname installed successfully."

    unset __fontname
    unset __fontdir
    unset __font_file
    unset __download_url
    unset __temp_dir
fi

# ====================================================================================================================================
# Pure prompt
PURE_GIT_PULL=0
if [[ $OSTYPE == darwin* ]]; then
    puredir="$(brew --prefix)/share/zsh/site-functions"
    if [ ! -f "$puredir/prompt_pure_setup" ]; then
        brew install pure
    fi
    fpath+=("$puredir")
else
    mkdir -p "$HOME/.zsh"
    puredir="$HOME/.zsh/pure"
    if [ ! -d "$puredir" ]; then
        git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"
    fi
    fpath+=("$puredir")
fi

cp "$DOTFILESHOME/scripts/prompt_pure_setup" "$puredir/prompt_pure_setup"
unset puredir

autoload -Uz promptinit; promptinit
prompt pure

zstyle :prompt:pure:git:stash show yes
zstyle :prompt:pure:git:fetch only_upstream yes
# ====================================================================================================================================

# alias
if [ -f "$HOME/.alias.sh" ]; then
    . "$HOME/.alias.sh"
fi



zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select

eval "$(zoxide init --cmd cd zsh)"



# Load zsh autocompletions
autoload -Uz compinit && compinit
zinit cdreplay -q
