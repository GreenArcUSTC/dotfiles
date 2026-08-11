## Dotfiles

Use [chezmoi](https://www.chezmoi.io/) to manage the dotfiles.

## Contents

* zsh: oh-my-zsh based shell config, local proxy helpers, Homebrew setup, and uv-first Python defaults.
* vim: minimal Vim config without plugins.
* Hammerspoon: macOS automation, currently input method auto-switching with an on-screen hint.
* tmux: default `C-b` prefix, RGB/extended-keys terminal setup, mouse on, 1-based indexing. No plugin manager.
* git: aliases, Git LFS filter config, global ignore, and `git lg`. Email and per-directory identity overrides come from local template data, not this repo.
* pip: pip mirror config.
* neovim: older Lua config kept for reference.
* ghostty: terminal emulator settings (JetBrains Mono with MiSans CJK fallback).
* karabiner: keyboard modifier mappings (Command/Option swap). Bluetooth MAC addresses come from local template data.
* gh: GitHub CLI config and aliases.
* herdr: terminal multiplexer/agent workspace config, kept as the annotated upstream default with only `onboarding` and `pane_history` set.
* podman/containers: engine proxy environment settings.

Emacs is managed in a separate repository.

## Secrets and machine-local data

This repo is public, so personal identifiers never live in it. The files that
need them are chezmoi templates (`*.tmpl`) that read from a `[data]` section in
`~/.config/chezmoi/chezmoi.toml`, which is outside the repo and never committed:

```toml
sourceDir = "/Users/liwei/Code/dotfiles"

[data]
  email = "you@example.com"
  keyboardAddress = "aa-bb-cc-dd-ee-ff"   # Karabiner Bluetooth keyboard

  [[data.gitIncludes]]                     # optional, repeatable
    gitdir = "/path/to/work/repos/"
    path = ".gitconfig-work"
```

Templated files: `dot_gitconfig.tmpl`, `dot_config/private_karabiner/private_karabiner.json.tmpl`,
`dot_config/nvim/lua/user/alpha.lua.tmpl`.

Every key is optional. Without local data the templates fall back to
placeholders and `chezmoi apply` still succeeds, so a fresh clone works before
the private data is set up.

Because these are templates, `chezmoi re-add` skips them — real values cannot
leak back into the repo by accident. To change them, edit
`~/.config/chezmoi/chezmoi.toml` and run `chezmoi apply`.

## Routine maintenance

```bash
chezmoi status                # files that differ between repo and $HOME
chezmoi diff                  # what `apply` would change in $HOME
chezmoi re-add <file>...      # pull edits made directly in $HOME back into the repo
chezmoi apply                 # push the repo state out to $HOME
```

Keep `chezmoi status` empty before committing.

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
