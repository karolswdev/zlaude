#!/usr/bin/env bash

# zlaude installer for Mac and Linux

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="${INSTALL_DIR:-/usr/local/bin}"

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║       zlaude Installer v1.0            ║${NC}"
echo -e "${BLUE}║  Claude Code wrapper for z.ai          ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# Check if running on Mac or Linux
OS="$(uname -s)"
if [[ "$OS" != "Darwin" && "$OS" != "Linux" ]]; then
    echo -e "${RED}Error: This installer only supports Mac and Linux${NC}"
    echo "Detected OS: $OS"
    exit 1
fi

echo -e "${GREEN}✓${NC} Detected OS: $OS"

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo -e "${YELLOW}⚠${NC}  Node.js is not installed"
    echo ""
    echo "Claude Code requires Node.js 18 or newer."
    echo "Please install Node.js from: https://nodejs.org/"
    echo ""
    read -p "Do you want to continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    NODE_VERSION=$(node --version)
    echo -e "${GREEN}✓${NC} Node.js is installed: $NODE_VERSION"
fi

# Check if claude is installed
if ! command -v claude &> /dev/null; then
    echo -e "${YELLOW}⚠${NC}  Claude Code is not installed"
    echo ""
    echo "Would you like to install Claude Code now?"
    read -p "(y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo ""
        echo "Installing Claude Code..."
        npm install -g @anthropic-ai/claude-code
        echo -e "${GREEN}✓${NC} Claude Code installed successfully"
    else
        echo ""
        echo "Please install Claude Code manually:"
        echo "  npm install -g @anthropic-ai/claude-code"
        echo ""
        echo "You can complete the zlaude installation after installing Claude Code."
        exit 1
    fi
else
    echo -e "${GREEN}✓${NC} Claude Code is installed"
fi

# Check if zlaude script exists
if [ ! -f "$SCRIPT_DIR/zlaude" ]; then
    echo -e "${RED}Error: zlaude script not found in $SCRIPT_DIR${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}Installation${NC}"
echo "────────────────────────────────────────"

# Determine installation directory
echo ""
echo "Where would you like to install zlaude?"
echo "  1) /usr/local/bin (recommended, requires sudo)"
echo "  2) ~/.local/bin (user only, no sudo required)"
echo "  3) Custom path"
echo ""
read -p "Choice (1-3) [1]: " install_choice
install_choice=${install_choice:-1}

case $install_choice in
    1)
        INSTALL_DIR="/usr/local/bin"
        NEEDS_SUDO=true
        ;;
    2)
        INSTALL_DIR="$HOME/.local/bin"
        NEEDS_SUDO=false
        mkdir -p "$INSTALL_DIR"
        ;;
    3)
        read -p "Enter custom path: " INSTALL_DIR
        INSTALL_DIR=$(eval echo "$INSTALL_DIR")
        NEEDS_SUDO=false
        mkdir -p "$INSTALL_DIR"
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac

# Install the script
echo ""
echo "Installing zlaude to $INSTALL_DIR..."

if [ "$NEEDS_SUDO" = true ]; then
    if ! sudo cp "$SCRIPT_DIR/zlaude" "$INSTALL_DIR/zlaude"; then
        echo -e "${RED}Error: Failed to install zlaude${NC}"
        echo "You might need to run this script with sudo or choose a different installation directory."
        exit 1
    fi
    sudo chmod +x "$INSTALL_DIR/zlaude"
else
    cp "$SCRIPT_DIR/zlaude" "$INSTALL_DIR/zlaude"
    chmod +x "$INSTALL_DIR/zlaude"
fi

echo -e "${GREEN}✓${NC} zlaude installed to $INSTALL_DIR/zlaude"

# Check if installation directory is in PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo -e "${YELLOW}⚠${NC}  Warning: $INSTALL_DIR is not in your PATH"
    echo ""
    echo "Add the following line to your ~/.bashrc or ~/.zshrc:"
    echo "  export PATH=\"$INSTALL_DIR:\$PATH\""
    echo ""
fi

# Offer to configure API key
echo ""
echo -e "${BLUE}Configuration${NC}"
echo "────────────────────────────────────────"
echo ""
echo "Would you like to configure your z.ai API key now?"
read -p "(y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    "$INSTALL_DIR/zlaude" --configure
fi

# Installation complete
echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║     Installation Complete! 🎉          ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""
echo "You can now run 'zlaude' to start Claude Code with z.ai!"
echo ""
echo "Quick start:"
echo "  zlaude --configure     # Set up your z.ai API key"
echo "  zlaude                 # Launch Claude Code with z.ai"
echo "  zlaude --help          # Show help"
echo ""
echo "Your regular 'claude' command will continue to work normally"
echo "with your existing Anthropic configuration."
echo ""
