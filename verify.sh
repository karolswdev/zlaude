#!/usr/bin/env bash

# Verification script for zlaude installation

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}zlaude Installation Verification${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check Node.js
echo -n "Checking Node.js... "
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo -e "${GREEN}✓${NC} Found: $NODE_VERSION"
else
    echo -e "${RED}✗${NC} Not found"
    echo "  Install from: https://nodejs.org/"
fi

# Check npm
echo -n "Checking npm... "
if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm --version)
    echo -e "${GREEN}✓${NC} Found: v$NPM_VERSION"
else
    echo -e "${RED}✗${NC} Not found"
fi

# Check Claude Code
echo -n "Checking Claude Code... "
if command -v claude &> /dev/null; then
    echo -e "${GREEN}✓${NC} Installed"
else
    echo -e "${RED}✗${NC} Not installed"
    echo "  Run: npm install -g @anthropic-ai/claude-code"
fi

# Check zlaude
echo -n "Checking zlaude... "
if command -v zlaude &> /dev/null; then
    ZLAUDE_PATH=$(which zlaude)
    echo -e "${GREEN}✓${NC} Installed at $ZLAUDE_PATH"
else
    echo -e "${YELLOW}⚠${NC}  Not in PATH"
    if [ -f "./zlaude" ]; then
        echo "  Found in current directory. Run ./install.sh to install."
    else
        echo "  Not found. Run ./install.sh to install."
    fi
fi

# Check zlaude config
echo -n "Checking zlaude config... "
ZLAUDE_CONFIG="${HOME}/.zlaude/config"
if [ -f "$ZLAUDE_CONFIG" ]; then
    echo -e "${GREEN}✓${NC} Found at $ZLAUDE_CONFIG"

    # Check if API key is set (without revealing it)
    if grep -q "ZLAUDE_API_KEY=" "$ZLAUDE_CONFIG" && ! grep -q "ZLAUDE_API_KEY=your_zai_api_key_here" "$ZLAUDE_CONFIG"; then
        echo -e "  API key: ${GREEN}Configured${NC}"
    else
        echo -e "  API key: ${YELLOW}Not configured or using example value${NC}"
        echo "  Run: zlaude --configure"
    fi
else
    echo -e "${YELLOW}⚠${NC}  Not found"
    echo "  Run: zlaude --configure"
fi

# Check PATH
echo ""
echo "PATH directories containing 'claude' or 'zlaude':"
IFS=':' read -ra PATH_DIRS <<< "$PATH"
for dir in "${PATH_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        if [ -f "$dir/claude" ] || [ -f "$dir/zlaude" ]; then
            echo "  • $dir"
            [ -f "$dir/claude" ] && echo "    - claude ✓"
            [ -f "$dir/zlaude" ] && echo "    - zlaude ✓"
        fi
    fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Summary
if command -v node &> /dev/null && command -v claude &> /dev/null && command -v zlaude &> /dev/null && [ -f "$ZLAUDE_CONFIG" ]; then
    echo -e "${GREEN}✓ Everything looks good! You're ready to use zlaude.${NC}"
    echo ""
    echo "Try it out:"
    echo "  zlaude"
else
    echo -e "${YELLOW}⚠ Some components are missing. Follow the instructions above.${NC}"
    echo ""
    echo "Quick setup:"
    echo "  1. Install Node.js: https://nodejs.org/"
    echo "  2. Install Claude Code: npm install -g @anthropic-ai/claude-code"
    echo "  3. Install zlaude: ./install.sh"
    echo "  4. Configure API key: zlaude --configure"
fi
echo ""
