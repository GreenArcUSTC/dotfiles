## Dotfiles

Use [chezmoi](https://www.chezmoi.io/) to manage the dotfiles.

## Contents

* zsh: oh-my-zsh based shell config, local proxy helpers, Homebrew setup, and uv-first Python defaults.
* vim: minimal Vim config without plugins.
* Hammerspoon: macOS automation, currently input method auto-switching.
* tmux: geohot-style prefix and TPM plugins.
* git: aliases, Git LFS filter config, global ignore, and `git lg`. User emails are intentionally kept out of this public repo.
* pip: pip mirror config.
* neovim: older Lua config kept for reference.
* ghostty: terminal emulator settings.
* karabiner: keyboard modifier mappings (Command/Option swap). Hardware identifiers (e.g., Bluetooth MAC addresses) are replaced with placeholders.
* gh: GitHub CLI config and aliases.
* podman/containers: engine proxy environment settings.

Emacs is managed in a separate repository.

## Python

Python is managed with [uv](https://docs.astral.sh/uv/).

Local conventions:

* uv is installed by Homebrew.
* `dot_zprofile` disables the old pyenv shell hooks.
* `dot_zprofile` exports `UV_MANAGED_PYTHON=1`, so uv prefers Python versions it manages.
* `dot_config/uv/dot_python-version` sets the default uv Python version to `3.11`.

Daily usage:

```bash
# Run a one-off command without creating project state.
uv run python -V
uv run --with requests python script.py

# Create and use a virtualenv in a project.
uv venv
source .venv/bin/activate

# Install requirements into the active/project environment.
uv pip install -r requirements.txt
uv pip install black ruff pytest

# For pyproject.toml projects.
uv sync
uv run pytest

# Manage Python versions.
uv python install 3.11
uv python pin 3.11
```

Avoid re-enabling pyenv shims in shell startup files unless there is a project-specific reason.

Reference:
* [Bastian's Dotfiles](https://github.com/venthur/dotfiles)
* [dotfiles](https://github.com/chaneyzorn/dotfiles)
* [chezmoi](https://www.chezmoi.io/)
