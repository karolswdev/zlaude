#!/usr/bin/env bash

# zlaude uninstaller for Mac and Linux

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║      zlaude Uninstaller v1.0           ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# Find zlaude installation
ZLAUDE_PATH=""
if command -v zlaude &> /dev/null; then
    ZLAUDE_PATH="$(command -v zlaude)"
    echo -e "${GREEN}✓${NC} Found zlaude at: $ZLAUDE_PATH"
else
    echo -e "${YELLOW}⚠${NC}  zlaude is not installed or not in PATH"
fi

# Check for config
ZLAUDE_CONFIG_DIR="${HOME}/.zlaude"
if [ -d "$ZLAUDE_CONFIG_DIR" ]; then
    echo -e "${GREEN}✓${NC} Found config directory: $ZLAUDE_CONFIG_DIR"
else
    echo -e "${YELLOW}⚠${NC}  Config directory not found"
fi

# Ask for confirmation
echo ""
echo -e "${YELLOW}WARNING: This will remove:${NC}"
[ -n "$ZLAUDE_PATH" ] && echo "  • zlaude command: $ZLAUDE_PATH"
[ -d "$ZLAUDE_CONFIG_DIR" ] && echo "  • Config directory: $ZLAUDE_CONFIG_DIR (contains API keys)"
echo ""

read -p "Are you sure you want to continue? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Uninstall cancelled."
    exit 0
fi

echo ""
echo -e "${BLUE}Uninstalling...${NC}"
echo ""

# Remove zlaude command
if [ -n "$ZLAUDE_PATH" ]; then
    echo -n "Removing zlaude command... "

    # Check if we need sudo
    if [ -w "$ZLAUDE_PATH" ]; then
        rm "$ZLAUDE_PATH"
        echo -e "${GREEN}✓${NC}"
    else
        if sudo rm "$ZLAUDE_PATH"; then
            echo -e "${GREEN}✓${NC}"
        else
            echo -e "${RED}✗${NC}"
            echo -e "${RED}Failed to remove $ZLAUDE_PATH${NC}"
        fi
    fi
fi

# Ask about config directory
if [ -d "$ZLAUDE_CONFIG_DIR" ]; then
    echo ""
    echo -e "${YELLOW}Config directory contains your API key and settings.${NC}"
    read -p "Remove config directory? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -n "Removing config directory... "
        rm -rf "$ZLAUDE_CONFIG_DIR"
        echo -e "${GREEN}✓${NC}"
    else
        echo "Keeping config directory."
    fi
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║     Uninstall Complete!                ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""

# Check if anything remains
REMAINS=false
if command -v zlaude &> /dev/null; then
    echo -e "${YELLOW}⚠${NC}  zlaude is still in PATH (may be in another location)"
    REMAINS=true
fi

if [ -d "$ZLAUDE_CONFIG_DIR" ]; then
    echo -e "${YELLOW}⚠${NC}  Config directory still exists: $ZLAUDE_CONFIG_DIR"
    REMAINS=true
fi

if [ "$REMAINS" = false ]; then
    echo "All zlaude files have been removed."
    echo ""
    echo "Note: Claude Code is still installed."
    echo "To remove Claude Code: npm uninstall -g @anthropic-ai/claude-code"
fi

echo ""
echo "Thank you for using zlaude! 👋"
echo ""
