# zlaude

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform: macOS | Linux](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey.svg)](https://github.com/karolswdev/zlaude)
[![Shell: Bash](https://img.shields.io/badge/shell-bash-green.svg)](https://www.gnu.org/software/bash/)

A wrapper for Claude Code that uses z.ai API servers without polluting your global Claude Code settings.

> **⚡ Quick Install**: `curl -fsSL https://raw.githubusercontent.com/karolswdev/zlaude/main/install.sh | bash`

## Problem

When you want to use Claude Code with both the official Anthropic API and z.ai's API, you face a dilemma: the configuration is global in `~/.claude/settings.json`. Switching between providers means constantly editing this file, which is tedious and error-prone.

## Solution

`zlaude` is a simple wrapper script that:
- ✅ Sets z.ai-specific environment variables before launching Claude Code
- ✅ Keeps your global Claude Code settings untouched
- ✅ Allows you to use `claude` for Anthropic and `zlaude` for z.ai simultaneously
- ✅ Works on Mac and Linux (Windows users... sorry!)
- ✅ Zero dependencies beyond bash and Node.js
- ✅ Interactive installer handles everything

## Features

- **🔄 Parallel Usage**: Run both Anthropic and z.ai Claude instances without conflicts
- **🔐 Secure Config**: API keys stored in `~/.zlaude/config` (not in global settings)
- **⚙️ Flexible**: Override API keys via CLI args or environment variables
- **📦 Simple**: Just a bash script - no Docker, no complex setup
- **🚀 Fast**: Instant startup, zero overhead
- **🔧 Interactive Setup**: `zlaude --configure` walks you through configuration

## How It Works

Instead of modifying `~/.claude/settings.json`, zlaude sets environment variables that Claude Code reads:
- `ANTHROPIC_AUTH_TOKEN` - Your z.ai API key
- `ANTHROPIC_BASE_URL` - Points to `https://api.z.ai/api/anthropic`
- `API_TIMEOUT_MS` - Extended timeout for z.ai
- Model mappings for GLM models

These environment variables are process-specific, so they only affect the Claude Code instance launched by zlaude.

## Installation

### Quick Install (Recommended)

**One-liner install from GitHub:**
```bash
curl -fsSL https://raw.githubusercontent.com/karolswdev/zlaude/main/install.sh | bash
```

**Or clone and install:**
```bash
git clone https://github.com/karolswdev/zlaude.git
cd zlaude
./install.sh
```

The installer will:
1. ✓ Check for prerequisites (Node.js and Claude Code)
2. ✓ Offer to install Claude Code if not present
3. ✓ Install the `zlaude` command to your system
4. ✓ Optionally configure your z.ai API key

### Manual Install

```bash
# Make the script executable
chmod +x zlaude

# Copy to a directory in your PATH
sudo cp zlaude /usr/local/bin/
# OR for user-only install:
cp zlaude ~/.local/bin/
```

## Configuration

### Interactive Configuration

```bash
zlaude --configure
```

This will prompt you for your z.ai API key and save it to `~/.zlaude/config`.

### Manual Configuration

Create `~/.zlaude/config` with:

```bash
ZLAUDE_API_KEY=your_api_key_here
```

### Getting a z.ai API Key

1. Visit [z.ai Open Platform](https://z.ai/model-api)
2. Register or login
3. Go to [API Keys](https://z.ai/manage-apikey/apikey-list)
4. Create and copy your API key

## Usage

### Basic Usage

```bash
# Launch Claude Code with z.ai
zlaude

# Use in any directory
cd ~/my-project
zlaude
```

### Command Line Options

```bash
# Configure or update API key
zlaude --configure

# Use a specific API key (overrides config)
zlaude --api-key YOUR_API_KEY

# Show help
zlaude --help
```

### Passing Arguments to Claude

All arguments after zlaude options are passed directly to Claude Code:

```bash
# These work just like with 'claude'
zlaude --help                    # zlaude's help
zlaude -- --help                 # Claude Code's help
zlaude /status                   # Check status in Claude Code
```

## Environment Variables

You can customize zlaude's behavior with environment variables:

- `ZLAUDE_API_KEY` - Override the API key from config file
- `ZLAUDE_CONFIG_DIR` - Config directory (default: `~/.zlaude`)
- `ZLAUDE_CONFIG_FILE` - Config file path (default: `~/.zlaude/config`)

Example:

```bash
# Use a different API key for one session
ZLAUDE_API_KEY=other_key zlaude

# Use a different config directory
ZLAUDE_CONFIG_DIR=~/my-configs zlaude
```

## Model Mappings

zlaude automatically maps Claude models to z.ai's GLM models:

- `claude-opus-*` → `GLM-4.6`
- `claude-sonnet-*` → `GLM-4.6`
- `claude-haiku-*` → `glm-4.5-air`

You can check the current model configuration in Claude Code with:

```bash
zlaude
> /status
```

## Architecture Decision: Why Not Docker?

We considered using Docker to isolate the configuration, but opted for the simpler environment variable approach because:

1. **Simplicity** - No Docker daemon required, works everywhere
2. **Performance** - No container overhead, instant startup
3. **Integration** - Seamless access to your filesystem and tools
4. **Portability** - Just a shell script, easy to understand and modify

The environment variable approach gives us clean isolation without the complexity of containerization.

## Examples

### Typical Workflow

```bash
# Morning: Work with Anthropic's Claude
claude
> help me refactor this code...

# Afternoon: Switch to z.ai for cost savings
zlaude
> continue the refactoring...

# Both work simultaneously, no conflicts!
```

### Multiple API Keys

```bash
# Use your personal key
zlaude
> ...

# Use your work key
zlaude --api-key work_api_key
> ...

# Use a project-specific key
ZLAUDE_API_KEY=project_key zlaude
> ...
```

## Troubleshooting

### "claude: command not found"

Claude Code is not installed. Install it with:

```bash
npm install -g @anthropic-ai/claude-code
```

### "zlaude: command not found"

The installation directory is not in your PATH. Either:

1. Add it to PATH in `~/.bashrc` or `~/.zshrc`:
   ```bash
   export PATH="/usr/local/bin:$PATH"
   ```

2. Or use the full path:
   ```bash
   /usr/local/bin/zlaude
   ```

### "No z.ai API key configured"

Run `zlaude --configure` to set up your API key.

### Connection Issues

If you're having trouble connecting to z.ai:

1. Verify your API key is correct
2. Check your internet connection
3. Try increasing the timeout (zlaude already sets it to 3000000ms)

## Development

### Project Structure

```
zlaude/
├── zlaude           # Main wrapper script (sets env vars, launches claude)
├── install.sh       # Interactive installer for Mac/Linux
├── uninstall.sh     # Interactive uninstaller
├── verify.sh        # Installation verification script
├── config.example   # Example configuration file
├── .gitignore       # Prevents committing sensitive data
├── LICENSE          # MIT License
├── README.md        # This file
└── CONTRIBUTING.md  # Contribution guidelines
```

### Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

**Ideas for contributors:**

- [ ] Add support for additional z.ai configuration options
- [x] Create an uninstaller script ✓
- [ ] Add shell completion (bash/zsh)
- [ ] Support for multiple provider profiles (not just z.ai)
- [ ] Auto-update mechanism
- [ ] Homebrew formula for easier installation

## License

MIT License - See [LICENSE](LICENSE) file for details.

## Credits

- **Claude Code** by [Anthropic](https://www.anthropic.com/)
- **z.ai API** by BigModel/GLM team
- Created by [@karolswdev](https://github.com/karolswdev) as a practical solution to a real problem

## Support

If you find this tool useful:
- ⭐ Star this repository
- 🐛 Report issues on [GitHub Issues](https://github.com/karolswdev/zlaude/issues)
- 💡 Suggest features or improvements
- 🤝 Contribute via pull requests

## FAQ

### Does this work with the official Anthropic API?

No, zlaude is specifically for z.ai. For Anthropic's API, use the regular `claude` command.

### Can I use both at the same time?

Yes! That's the whole point. Use `claude` for Anthropic and `zlaude` for z.ai without any conflicts.

### Will this affect my existing Claude Code setup?

No, zlaude doesn't modify any global settings. Your `~/.claude/settings.json` remains untouched.

### What about Windows?

The creator explicitly stated "No one cares about Windows" in the requirements. But if you do care, you could port this to a PowerShell script or use WSL.

### Is Docker support planned?

No, the environment variable approach is simpler and works perfectly. Docker would add unnecessary complexity.

### How do I uninstall?

**Easy way (recommended):**
```bash
./uninstall.sh
```

**Manual removal:**
```bash
# Remove the command
sudo rm /usr/local/bin/zlaude
# OR for user install:
rm ~/.local/bin/zlaude

# Optionally remove config
rm -rf ~/.zlaude
```

---

**Happy coding with z.ai!** 🚀
