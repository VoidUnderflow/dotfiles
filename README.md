# dotfiles
/uj 🥀: Trying to make switching between my Windows, Ubuntu, and MacOS laptops less painful.

I'm still split on whether this repo should only cover setting up the terminal, or also cover tools. Anyway, currently opting for a mixed approach:
- setting up the terminal should work on any machine without messing up any pre-existing configs;
- optionally, on personal machines configure things like node, uv, rust;

## Terminal

- Managed by [chezmoi](https://chezmoi.io); Should work on Windows (WSL), Mac and Linux. 
- Current stack: zsh + oh-my-zsh, Starship, tmux, LazyVim, Windows Terminal / Ghostty, Tokyo Night, JetBrains Mono.

## Initial setup

The process is fairly manual, because I don't set up new machines too often.

First, install:

- **WSL:** `sudo apt install zsh build-essential procps curl file git`, [Homebrew](https://brew.sh), `brew install chezmoi`, `chsh -s /usr/bin/zsh`. 
- Desktop Linux: all of the above + [Ghostty](https://ghostty.org/docs/install).
- **Mac:** `xcode-select --install`, [Homebrew](https://brew.sh), `brew install chezmoi`.
- **Windows:** [Scoop](https://scoop.sh), `scoop install git chezmoi`, WSL with Ubuntu (`wsl --set-default Ubuntu`).

Then:

```sh
chezmoi init --apply VoidUnderflow
git config --global user.name "..."
git config --global user.email "..."
```

- **"Personal machine?"**: `y` also installs node, pnpm and Rust. Answer `n` on work machines.
- **Existing `~/.zshrc`:** the first apply stops and backs it up to `~/.zshrc.pre-chezmoi`. Move what you need into `~/.zshrc.local`, then `chezmoi apply`.
- **No git access:** unzip the repo into `~/.local/share/chezmoi`, then `chezmoi init --apply`.

Machine-specific settings live in `~/.zshrc.local` and `~/.gitconfig` and should never be committed here.

## Updating

Pull the latest dotfiles and apply them:

```sh
chezmoi update
```

This also does whatever the changes need: it installs packages newly added to the list, moves Neovim plugins to the committed versions, and installs new language runtimes on personal machines. oh-my-zsh updates itself weekly.

To upgrade the installed tools themselves:

```sh
brew upgrade
```

This upgrades every Homebrew package on the machine, not just the ones from this repo. Where other software depends on Homebrew packages, upgrade only this repo's packages by name instead. The list is in `home/.chezmoidata/packages.yaml`.

On personal machines, also update the language runtimes:

```sh
mise upgrade
rustup update
```

On Windows, in PowerShell:

```powershell
chezmoi update
scoop update *
```

The first updates Windows Terminal's settings and `.ideavimrc`. The second upgrades every Scoop app (fonts included; do fonts get updates though? >.>)

Without git access, replace `~/.local/share/chezmoi` with a fresh copy of the repo and run `chezmoi apply` instead of `chezmoi update`.

Neovim plugins are pinned in `lazy-lock.json`, so every machine runs the same versions. To move to newer ones, run `:Lazy update` in Neovim on one machine and check that everything still works. Then run `chezmoi re-add` to copy the new lockfile into the repo, commit and push. The other machines pick it up on their next `chezmoi update`.

If a pulled change touches `home/.chezmoi.toml.tmpl`, run `chezmoi init` before anything else. It regenerates the machine's config without asking the setup questions again.

If any of these steps get annoying, just automate them.
