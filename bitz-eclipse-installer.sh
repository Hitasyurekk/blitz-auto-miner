#!/bin/bash
# Bitz Miner Installer for Eclipse Network
# --------------------------------------------
# This script automates the installation of Bitz ePOW miner on Eclipse Network
# It handles all dependencies, wallet setup, and configuration for mining
# Author: Hitasyurek
# Twitter: https://x.com/hitasyurek
# Date: April 13, 2025

# Text formatting
BOLD="\033[1m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
RED="\033[0;31m"
NC="\033[0m" # No Color

# Function to print section headers
print_header() {
    echo -e "\n${BOLD}${BLUE}=== $1 ===${NC}\n"
}

# Function to print success messages
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Function to print info messages
print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

# Function to print error messages
print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Function to check for errors
check_error() {
    if [ $? -ne 0 ]; then
        print_error "$1"
        exit 1
    else
        print_success "$2"
    fi
}

# Ask for number of cores to use
ask_cores() {
    echo -e "${YELLOW}How many CPU cores would you like to dedicate to mining?${NC}"
    echo -e "${YELLOW}Recommended: Leave at least 1 core free for system operations${NC}"
    echo -e "${YELLOW}Your system has $(nproc) cores available${NC}"
    read -p "Number of cores (default: 1): " CORES
    CORES=${CORES:-1}
    
    # Validate input is a number
    if ! [[ "$CORES" =~ ^[0-9]+$ ]]; then
        print_error "Invalid input. Using default: 1 core"
        CORES=1
    fi
    
    # Check if user is trying to use more cores than available
    if [ "$CORES" -gt "$(nproc)" ]; then
        print_info "You've selected more cores than available. Setting to maximum: $(nproc)"
        CORES=$(nproc)
    fi
    
    print_info "Will configure mining with $CORES core(s)"
}

# Begin installation
clear
echo -e "${BOLD}${GREEN}"
echo "  ____  _ _          __  __ _                 "
echo " | __ )(_) |_ __    |  \/  (_)_ __   ___ _ __ "
echo " |  _ \| | __/ __|  | |\/| | | '_ \ / _ \ '__|"
echo " | |_) | | |_\__ \  | |  | | | | | |  __/ |   "
echo " |____/|_|\__|___/  |_|  |_|_|_| |_|\___|_|   "
echo -e "${NC}"
echo -e "${BOLD}Eclipse Network Installer - Automated Setup${NC}"
echo -e "${YELLOW}This script will install everything needed to mine Bitz on Eclipse Network${NC}"
echo -e "${BOLD}${BLUE}Created by:${NC} Hitasyurek"
echo -e "${BOLD}${BLUE}Twitter:${NC} https://x.com/hitasyurek"
echo -e "\n"

# Confirm installation
read -p "Continue with installation? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_info "Installation cancelled"
    exit 0
fi

# System update and install essential packages
print_header "Updating System and Installing Prerequisites"
sudo apt update && sudo apt upgrade -y
check_error "Failed to update system packages" "System packages updated"

sudo apt install curl nano build-essential -y
check_error "Failed to install essential packages" "Essential packages installed"

# Install and build Screen from source
print_header "Building Screen from Source"
sudo apt install autoconf make gcc libutempter-dev libpam0g-dev libncurses5-dev -y
check_error "Failed to install screen dependencies" "Screen dependencies installed"

curl -O https://ftp.gnu.org/gnu/screen/screen-4.9.1.tar.gz
check_error "Failed to download screen source" "Screen source downloaded"

tar -xzf screen-4.9.1.tar.gz
cd screen-4.9.1
./configure
check_error "Screen configuration failed" "Screen configured successfully"

make
check_error "Screen compilation failed" "Screen compiled successfully"

sudo make install
check_error "Screen installation failed" "Screen installed successfully"

cd ..
screen --version
check_error "Screen not installed correctly" "Screen installation verified"

# Install Rust
print_header "Installing Rust"
print_info "When prompted, select option 1 (default) to proceed with installation"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
check_error "Rust installation failed" "Rust installed successfully"

source $HOME/.cargo/env
check_error "Failed to source Rust environment" "Rust environment configured"

# Install Solana CLI
print_header "Installing Solana CLI"
print_info "Checking system compatibility..."

# Check GLIBC version
GLIBC_VERSION=$(ldd --version | head -n1 | grep -oP '\d+\.\d+

# Configure Solana for Eclipse Network
print_header "Configuring Solana for Eclipse Network"
solana config set --url https://mainnetbeta-rpc.eclipse.xyz/
check_error "Failed to set Eclipse RPC endpoint" "Eclipse RPC endpoint configured"

# Wallet setup
print_header "Creating Solana Wallet for Eclipse"
print_info "This will create a new wallet keypair for mining on Eclipse"
print_info "IMPORTANT: Save your mnemonic phrase/private key in a secure location!"

read -p "Generate new wallet? (y/n, default: y): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    solana-keygen new
    check_error "Failed to generate new wallet" "New wallet generated successfully"
    
    # Display wallet info
    print_info "Your wallet info:"
    solana address
    
    print_header "Wallet Private Key"
    print_info "Below is your private key. Import this into Backpack or another Eclipse-compatible wallet:"
    cat ~/.config/solana/id.json
    
    print_info "⚠️ IMPORTANT: Fund this wallet with at least 0.005 ETH on Eclipse network before mining"
    print_info "You can copy this private key to import into Backpack wallet"
    
    # Pause to let user copy the key
    read -p "Press Enter once you've saved your private key..." -s
    echo
else
    print_info "Skipping wallet generation. Make sure you have a configured wallet at ~/.config/solana/id.json"
fi

# Install Bitz miner
print_header "Installing Bitz Miner"
print_info "Checking if Rust is properly installed..."

# Check if cargo is available after Rust installation
if ! command -v cargo &> /dev/null; then
    print_info "Cargo not found. Re-sourcing Rust environment..."
    source "$HOME/.cargo/env"
    
    if ! command -v cargo &> /dev/null; then
        print_error "Cargo still not found. Trying to fix Rust installation..."
        
        # Check if Rust was installed
        if [ -f "$HOME/.cargo/env" ]; then
            print_info "Rust seems to be installed but not in PATH. Adding to PATH..."
            export PATH="$HOME/.cargo/bin:$PATH"
            echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
        else
            print_info "Trying alternative Rust installation..."
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
            source "$HOME/.cargo/env"
        fi
    fi
fi

# Verify cargo is available
if ! command -v cargo &> /dev/null; then
    print_error "Failed to install or configure Rust/Cargo. Please install manually."
    exit 1
fi

print_info "Installing Bitz miner..."
cargo install bitz
check_error "Failed to install Bitz miner" "Bitz miner installed successfully"

# Verify installation
if ! command -v bitz &> /dev/null; then
    print_error "Bitz command not found after installation."
    print_info "Adding Cargo bin directory to PATH..."
    export PATH="$HOME/.cargo/bin:$PATH"
    echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
    
    if ! command -v bitz &> /dev/null; then
        print_error "Bitz installation verification failed. Please check manually."
    else
        print_success "Bitz miner found after PATH update"
    fi
else
    print_success "Bitz miner installation verified"
fi

# Prompt for core count
ask_cores

# Create startup script
print_header "Creating Convenience Scripts"

# Create mining script
cat > ~/start-bitz-mining.sh << EOF
#!/bin/bash
# Bitz mining starter script
echo "Starting Bitz mining with $CORES core(s)..."
screen -S bitzminer bitz collect --cores $CORES
EOF

chmod +x ~/start-bitz-mining.sh
check_error "Failed to create mining script" "Mining starter script created"

# Create utility script with common commands
cat > ~/bitz-commands.sh << EOF
#!/bin/bash
# Bitz commands utility script

case "\$1" in
  "start")
    ~/start-bitz-mining.sh
    ;;
  "attach")
    screen -r bitzminer
    ;;
  "stop")
    screen -XS bitzminer quit
    echo "Mining stopped"
    ;;
  "status")
    echo "Checking miner status..."
    screen -ls | grep bitzminer
    ;;
  "claim")
    echo "Claiming mined tokens..."
    bitz claim
    ;;
  "account")
    echo "Checking account status..."
    bitz account
    ;;
  *)
    echo "Bitz Miner Utility Commands:"
    echo "  start   - Start mining in a screen session"
    echo "  attach  - Reattach to mining screen"
    echo "  stop    - Stop mining"
    echo "  status  - Check if miner is running"
    echo "  claim   - Claim mined tokens"
    echo "  account - Check wallet status"
    ;;
esac
EOF

chmod +x ~/bitz-commands.sh
check_error "Failed to create utility script" "Utility command script created"

# Installation complete
print_header "Installation Complete"
print_info "Bitz miner has been successfully installed!"
print_info "IMPORTANT REMINDERS:"
print_info "1. Fund your wallet with at least 0.005 ETH on Eclipse Network before mining"
print_info "2. Keep your private key/mnemonic phrase backed up securely"
print_info "3. To start mining: ~/start-bitz-mining.sh"
print_info "4. To use utility commands: ~/bitz-commands.sh [command]"
print_info "   Available commands: start, attach, stop, status, claim, account"
print_info "5. To detach from screen session (keep mining): CTRL+A+D"
print_info ""
print_info "Happy mining! 🎉"
)
print_info "Detected GLIBC version: $GLIBC_VERSION"

# Choose installation method based on GLIBC version
GLIBC_MAJOR=$(echo $GLIBC_VERSION | cut -d. -f1)
GLIBC_MINOR=$(echo $GLIBC_VERSION | cut -d. -f2)

if (( GLIBC_MAJOR < 2 || (GLIBC_MAJOR == 2 && GLIBC_MINOR < 31) )); then
    print_info "Using compatible Solana CLI installation for older systems"
    
    # Create directory for Solana
    mkdir -p $HOME/.local/share/solana/install
    
    # Download a compatible version (adjust URL if needed)
    print_info "Downloading compatible Solana CLI version..."
    curl -L https://github.com/solana-labs/solana/releases/download/v1.14.18/solana-release-x86_64-unknown-linux-gnu.tar.bz2 -o $HOME/.local/share/solana/solana-release.tar.bz2
    check_error "Failed to download Solana CLI" "Solana CLI downloaded successfully"
    
    # Extract
    print_info "Extracting Solana CLI..."
    tar -xjf $HOME/.local/share/solana/solana-release.tar.bz2 -C $HOME/.local/share/solana/install
    check_error "Failed to extract Solana CLI" "Solana CLI extracted successfully"
    
    # Add to PATH
    SOLANA_INSTALL_PATH=$(find $HOME/.local/share/solana/install -name "solana-release" -type d)
    print_info "Adding $SOLANA_INSTALL_PATH to PATH..."
    
    # Update PATH in current session
    export PATH="$SOLANA_INSTALL_PATH/bin:$PATH"
    
    # Add to shell profile
    echo "export PATH=\"$SOLANA_INSTALL_PATH/bin:\$PATH\"" >> $HOME/.bashrc
else
    print_info "Using standard Solana CLI installation"
    curl --proto '=https' --tlsv1.2 -sSfL https://solana-install.solana.workers.dev | bash
    check_error "Solana CLI installation failed" "Solana CLI installed successfully"
    source $HOME/.bashrc
fi

# Verify Solana installation
if ! command -v solana &> /dev/null; then
    export PATH="$HOME/.local/share/solana/install/solana-release/bin:$PATH"
    if ! command -v solana &> /dev/null; then
        print_error "Solana CLI could not be found in PATH. Installation may have failed."
        print_info "You might need to manually add Solana to your PATH or restart your terminal."
        print_info "If issues persist, try 'source ~/.bashrc' or reboot your system."
    fi
else
    solana --version
    print_success "Solana CLI verified"
fi

# Configure Solana for Eclipse Network
print_header "Configuring Solana for Eclipse Network"
solana config set --url https://mainnetbeta-rpc.eclipse.xyz/
check_error "Failed to set Eclipse RPC endpoint" "Eclipse RPC endpoint configured"

# Wallet setup
print_header "Creating Solana Wallet for Eclipse"
print_info "This will create a new wallet keypair for mining on Eclipse"
print_info "IMPORTANT: Save your mnemonic phrase/private key in a secure location!"

read -p "Generate new wallet? (y/n, default: y): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    solana-keygen new
    check_error "Failed to generate new wallet" "New wallet generated successfully"
    
    # Display wallet info
    print_info "Your wallet info:"
    solana address
    
    print_header "Wallet Private Key"
    print_info "Below is your private key. Import this into Backpack or another Eclipse-compatible wallet:"
    cat ~/.config/solana/id.json
    
    print_info "⚠️ IMPORTANT: Fund this wallet with at least 0.005 ETH on Eclipse network before mining"
    print_info "You can copy this private key to import into Backpack wallet"
    
    # Pause to let user copy the key
    read -p "Press Enter once you've saved your private key..." -s
    echo
else
    print_info "Skipping wallet generation. Make sure you have a configured wallet at ~/.config/solana/id.json"
fi

# Install Bitz miner
print_header "Installing Bitz Miner"
cargo install bitz
check_error "Failed to install Bitz miner" "Bitz miner installed successfully"

# Prompt for core count
ask_cores

# Create startup script
print_header "Creating Convenience Scripts"

# Create mining script
cat > ~/start-bitz-mining.sh << EOF
#!/bin/bash
# Bitz mining starter script
echo "Starting Bitz mining with $CORES core(s)..."
screen -S bitzminer bitz collect --cores $CORES
EOF

chmod +x ~/start-bitz-mining.sh
check_error "Failed to create mining script" "Mining starter script created"

# Create utility script with common commands
cat > ~/bitz-commands.sh << EOF
#!/bin/bash
# Bitz commands utility script

case "\$1" in
  "start")
    ~/start-bitz-mining.sh
    ;;
  "attach")
    screen -r bitzminer
    ;;
  "stop")
    screen -XS bitzminer quit
    echo "Mining stopped"
    ;;
  "status")
    echo "Checking miner status..."
    screen -ls | grep bitzminer
    ;;
  "claim")
    echo "Claiming mined tokens..."
    bitz claim
    ;;
  "account")
    echo "Checking account status..."
    bitz account
    ;;
  *)
    echo "Bitz Miner Utility Commands:"
    echo "  start   - Start mining in a screen session"
    echo "  attach  - Reattach to mining screen"
    echo "  stop    - Stop mining"
    echo "  status  - Check if miner is running"
    echo "  claim   - Claim mined tokens"
    echo "  account - Check wallet status"
    ;;
esac
EOF

chmod +x ~/bitz-commands.sh
check_error "Failed to create utility script" "Utility command script created"

# Installation complete
print_header "Installation Complete"
print_info "Bitz miner has been successfully installed!"
print_info "IMPORTANT REMINDERS:"
print_info "1. Fund your wallet with at least 0.005 ETH on Eclipse Network before mining"
print_info "2. Keep your private key/mnemonic phrase backed up securely"
print_info "3. To start mining: ~/start-bitz-mining.sh"
print_info "4. To use utility commands: ~/bitz-commands.sh [command]"
print_info "   Available commands: start, attach, stop, status, claim, account"
print_info "5. To detach from screen session (keep mining): CTRL+A+D"
print_info ""
print_info "Happy mining! 🎉"
