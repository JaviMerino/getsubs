# Development Guide

## Building the Project

Build the project using Nix:

```bash
nix build
```

Run the application:

```bash
nix run
```

## Development Environment

Enter the development shell (or use direnv):

```bash
nix develop
```

With direnv configured (`.envrc` with `use flake`):

```bash
direnv allow
```

## Code Quality & Formatting

### Python

**Formatting:**
- Use [Black](https://black.readthedocs.io/) for code formatting
  ```bash
  black getsubs.py
  ```

**Linting:**
- Use [Ruff](https://docs.astral.sh/ruff/) for fast Python linting
  ```bash
  ruff check getsubs.py
  ```

**Type Checking:**
- Use [mypy](https://mypy.readthedocs.io/) for static type checking
  ```bash
  mypy getsubs.py
  ```

### Nix

**Formatting:**
- Use `nixfmt` for Nix file formatting
  ```bash
  nixfmt flake.nix
  ```

### Bash

**Linting:**
- Use `shellcheck` for bash script linting
  ```bash
  shellcheck .githooks/pre-commit
  ```

### Markdown

**Linting:**
- Use [mdl](https://github.com/markdownlint/markdownlint) for Markdown linting
  ```bash
  mdl README.md
  ```

## Pre-commit Checks

### Automatic Git Hooks

Enable automatic pre-commit checks:

```bash
git config --local core.hooksPath $PWD/.githooks
```

The pre-commit hook will automatically verify:
- Black formatting (check mode - will fail if files need formatting)
- Ruff linting
- mypy type checking
- nixfmt formatting (check mode - will fail if files need formatting)
- Markdown linting with mdl

### Manual Checks

To run checks manually before committing:

```bash
# Check Python formatting (without modifying files)
black --check .

# Lint Python code
ruff check .

# Type check Python code
mypy .

# Check Nix formatting (without modifying files)
nixfmt --check flake.nix

# Lint Markdown files
mdl README.md
```
