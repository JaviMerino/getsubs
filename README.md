# getsubs

Download subtitles of videos.

## Installation

Add the flake to your `flake.nix` inputs and install the default package.

```nix
{
  inputs = {
    [...]
    getsubs.url = "github:javimerino/getsubs";
  };
```

Or run without installing:

```bash
nix run github:javimerino/getsubs -- "https://www.youtube.com/watch?v=6t-BFe-frT8"
```

## Usage

Download and extract subtitles from a video URL:

```bash
getsubs "https://www.youtube.com/watch?v=6t-BFe-frT8"
```

The script will try to download manual subtitles first and fall back to auto-generated subtitles if manual ones aren't available.

Example output:
```
[Music]
hey so my name is [...]
```

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

### Building

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

## Acknowledgements

Inspired by [getsubs](https://codeberg.org/EvanHahn/dotfiles/src/branch/main/home/bin/bin/getsubs) by [Evan Hahn](https://evanhahn.com). 
