## Dotfiles

Use [chezmoi](https://www.chezmoi.io/) to manage the dotfiles.

## Contents

* zsh: minimal native shell config with a two-line ys-style prompt, aj-rs, `proxy_on`/`proxy_off` helpers, and uv-first Python defaults. No oh-my-zsh, prompt plugins, or completion setup. Proxy ports come from local template data; the proxy auto-enables only when the port is actually listening.
* vim: minimal Vim config without plugins.
* Hammerspoon: macOS automation, currently input method auto-switching with an on-screen hint. The app allowlist comes from local template data.
* tmux: default `C-b` prefix, RGB/extended-keys terminal setup, mouse on, 1-based indexing. No plugin manager.
* git: aliases, Git LFS filter config, global ignore, and `git lg`. Email and per-directory identity overrides come from local template data, not this repo.
* pip: pip mirror config.
* ghostty: Solarized Light (custom palette matching iTerm2), JetBrains Mono with MiSans CJK fallback, and iTerm2-aligned cursor/scrollback/Option-as-Alt settings.
* karabiner: keyboard modifier mappings (Command/Option swap). Bluetooth MAC addresses come from local template data.
* gh: GitHub CLI config and aliases.
* herdr: minimal terminal multiplexer/agent workspace config. Unspecified values follow Herdr defaults; explicit settings cover onboarding, theme, pane history, and toast delivery.

Emacs is managed in a separate repository.

## Secrets and machine-local data

This repo is public, so personal identifiers, network details, and the list of
installed apps never live in it. The files that need them are chezmoi templates
(`*.tmpl`) reading a `[data]` section from `~/.config/chezmoi/chezmoi.toml`,
which sits outside the repo and is never committed:

```toml
sourceDir = "/path/to/this/repo"

[data]
  email = "you@example.com"
  keyboardAddress = "aa-bb-cc-dd-ee-ff"    # Karabiner Bluetooth keyboard

  proxyHttpPort = 7890                     # shell proxy_on/proxy_off
  proxySocksPort = 7891

  [[data.gitIncludes]]                     # optional, repeatable
    gitdir = "/path/to/work/repos/"
    path = ".gitconfig-work"

  [[data.chineseApps]]                     # Hammerspoon input-method allowlist
    id = "com.apple.Notes"
    comment = "Notes"
```

| Template | Reads |
| --- | --- |
| `dot_gitconfig.tmpl` | `email`, `gitIncludes` |
| `dot_zshrc.tmpl` | `proxyHttpPort`, `proxySocksPort` |
| `dot_hammerspoon/init.lua.tmpl` | `chineseApps` |
| `dot_config/private_karabiner/private_karabiner.json.tmpl` | `keyboardAddress` |

Every key is optional. Without local data the templates fall back to neutral
defaults and `chezmoi apply` still succeeds, so a fresh clone works before the
private data exists.

Because these are templates, `chezmoi re-add` skips them — real values cannot
leak back into the repo by accident. To change them, edit
`~/.config/chezmoi/chezmoi.toml` and run `chezmoi apply`.

That file now carries real configuration, not just secrets, so **back it up
separately** (a private repo or a password-manager attachment both work). It is
the one piece of this setup the public repo cannot restore.

## Portability

Nothing here hardcodes a username or a machine path. Specifically:

* Every `PATH` entry is added only if the directory exists, so missing tools do
  not pollute `PATH`.
* Homebrew is located at `/opt/homebrew` or `/usr/local`, whichever exists.
* The node and ffmpeg paths use Homebrew's version-independent
  `/opt/homebrew/opt` symlinks.
* aj-rs initializes in `.zshrc` instead of sourcing `autojump.sh` in `.zprofile`.
* The proxy turns on only when something is listening on the configured port.
  Enabling it unconditionally breaks `git`, `curl`, and `brew` on machines with
  no proxy running.
macOS-specific pieces (Hammerspoon, Karabiner, Ghostty, the `/Applications`
aliases) are inert or simply unused elsewhere.

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
