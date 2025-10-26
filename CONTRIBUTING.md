# Contributing to zlaude

Thank you for considering contributing to zlaude! This document provides guidelines and instructions for contributing.

## Code of Conduct

- Be respectful and inclusive
- Welcome newcomers and help them get started
- Focus on constructive feedback
- Remember: we're all here to make a useful tool better

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the [existing issues](https://github.com/karolswdev/zlaude/issues) to avoid duplicates.

**When submitting a bug report, include:**

- A clear, descriptive title
- Steps to reproduce the issue
- Expected behavior vs actual behavior
- Your environment:
  - OS (macOS version or Linux distribution)
  - Shell (bash version)
  - Node.js version
  - Claude Code version
- Relevant logs or error messages

**Example:**

```markdown
## Bug: zlaude fails to launch with "command not found"

**Environment:**
- macOS 14.1
- bash 5.2
- Node.js v20.10.0
- Installed via curl | bash method

**Steps to reproduce:**
1. Run `./install.sh`
2. Installation completes successfully
3. Run `zlaude`
4. Error: "command not found"

**Expected:** zlaude should launch Claude Code
**Actual:** Command not found error

**Additional context:**
$PATH does not include /usr/local/bin
```

### Suggesting Features

Feature suggestions are welcome! Please:

1. Check if the feature has already been suggested
2. Explain the use case and why it would be valuable
3. Provide examples of how it would work
4. Consider implementation complexity

### Pull Requests

We love pull requests! Here's the process:

1. **Fork the repo** and create your branch from `main`
   ```bash
   git checkout -b feature/my-awesome-feature
   ```

2. **Make your changes**
   - Follow the existing code style (bash best practices)
   - Keep changes focused and atomic
   - Test your changes thoroughly

3. **Test your changes**
   ```bash
   # Test the main script
   ./zlaude --help
   ./zlaude --configure

   # Test installation
   ./install.sh

   # Verify everything works
   ./verify.sh
   ```

4. **Update documentation**
   - Update README.md if you're adding features
   - Add comments to complex bash code
   - Update help text if changing CLI options

5. **Commit your changes**
   - Use clear, descriptive commit messages
   - Follow conventional commits format:
     ```
     feat: add support for custom config directory
     fix: handle spaces in installation paths
     docs: improve installation instructions
     refactor: simplify API key validation
     test: add verification for PATH setup
     ```

6. **Push and create a PR**
   ```bash
   git push origin feature/my-awesome-feature
   ```
   - Provide a clear description of what changed and why
   - Reference any related issues

## Development Guidelines

### Bash Style Guide

- Use `#!/usr/bin/env bash` shebang
- Use `set -e` to fail on errors
- Quote variables: `"$variable"` not `$variable`
- Use `[[` instead of `[` for tests
- Prefer `command -v` over `which`
- Use functions for repeated code
- Add comments for complex logic

**Good:**
```bash
if [[ -z "$API_KEY" ]]; then
    echo "Error: API key not set"
    exit 1
fi
```

**Bad:**
```bash
if [ -z $API_KEY ]
then
  echo Error: API key not set
  exit 1
fi
```

### Error Handling

- Always check command exit codes
- Provide helpful error messages
- Clean up on failure when appropriate
- Use colored output for visibility:
  - `${GREEN}` for success
  - `${RED}` for errors
  - `${YELLOW}` for warnings
  - `${BLUE}` for informational

### Testing

Before submitting:

1. **Test on clean system (if possible)**
   - Fresh install
   - Without existing configuration

2. **Test different scenarios**
   - First-time install
   - Update existing installation
   - With and without Claude Code installed
   - With and without config file
   - Manual vs automatic installation

3. **Test edge cases**
   - Spaces in paths
   - Missing dependencies
   - Invalid API keys
   - Permission issues

4. **Verify cleanup**
   - Uninstall works properly
   - No leftover files
   - Config removal is safe

## Project Structure

```
zlaude/
├── zlaude              # Main wrapper script
│   ├── Command parsing
│   ├── Configuration loading
│   ├── Environment setup
│   └── Claude Code launch
│
├── install.sh          # Interactive installer
│   ├── Prerequisite checks
│   ├── Claude Code installation
│   ├── zlaude installation
│   └── Configuration setup
│
├── verify.sh           # Verification script
│   └── System checks
│
└── config.example      # Example configuration
```

## Ideas for Contribution

Here are some areas where contributions would be especially valuable:

### High Priority
- [ ] **Shell completion** (bash/zsh) for better UX
- [ ] **Uninstaller script** for clean removal
- [ ] **Homebrew formula** for easier installation on macOS
- [ ] **Better error messages** with suggestions for fixes

### Medium Priority
- [ ] **Multiple profiles** - support for different z.ai accounts or providers
- [ ] **Config validation** - check API key format, test connection
- [ ] **Update mechanism** - notify users of new versions
- [ ] **Docker support** - for users who prefer containerization

### Nice to Have
- [ ] **Fish shell support**
- [ ] **Custom model mappings** via config file
- [ ] **Logging** - optional verbose mode for debugging
- [ ] **Integration tests** - automated testing framework

## Questions?

- Open an issue with the `question` label
- Reach out to [@karolswdev](https://github.com/karolswdev)

## Recognition

Contributors will be:
- Listed in the project README
- Mentioned in release notes
- Credited in commit history

Thank you for making zlaude better! 🚀
