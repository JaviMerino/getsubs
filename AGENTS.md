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

## Pre-commit Checks

Before committing, run all checks:

```bash
# Format Python code
black .

# Lint Python code
ruff check .

# Type check Python code
mypy .

# Format Nix files
nixfmt flake.nix
```
