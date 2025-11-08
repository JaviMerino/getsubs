# getsubs

Download subtitles of videos.

## Development Environment

This project uses Nix for reproducible development environments.

```bash
nix develop
```

Alternatively, use [direnv](https://direnv.net/) for automatic environment loading:
```bash
direnv allow
```

### Git Hooks

To enable pre-commit hooks that check code quality before each commit:

```bash
git config --local core.hooksPath $PWD/.githooks
```

This will run the following checks automatically:
- Black formatting (check mode)
- Ruff linting
- mypy type checking
- nixfmt formatting (check mode)

## Building

Build the project:
```bash
nix build
```

Run the built application:
```bash
./result/bin/getsubs
```

Or run directly:
```bash
nix run
```
