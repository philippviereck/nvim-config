![Screenshot 2024-01-10 at 15 31 04](https://github.com/philippviereck/nvim-config/assets/105976309/53534b77-3192-471d-a813-0e8149dc610e)


# ⚡️ Requirements

- Neovim >= **0.9.0** (`brew install --HEAD neovim`)
- a [Nerd Font](https://www.nerdfonts.com/)(v3.0 or greater) **_(optional, but needed to display some icons)_**
- a **C** compiler for `nvim-treesitter`. See [here](https://github.com/nvim-treesitter/nvim-treesitter#requirements)
- for [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) **_(optional)_**
  - **live grep**: [ripgrep](https://github.com/BurntSushi/ripgrep)
  - **find files**: [fd](https://github.com/sharkdp/fd)
- a terminal that support true color and _undercurl_:
  - [kitty](https://github.com/kovidgoyal/kitty) **_(Linux & Macos)_**
  - [wezterm](https://github.com/wez/wezterm) **_(Linux, Macos & Windows)_**
  - [alacritty](https://github.com/alacritty/alacritty) **_(Linux, Macos & Windows)_**
  - [iterm2](https://iterm2.com/) **_(Macos)_**

# 🔨 Installation
> [!IMPORTANT]
> I've only tested this on my Mac, I haven't had the chance to verify its compatibility on a fresh machine. Consequently, there might be missing prerequisites such as Node.js, npm, and others.

- Make a backup of your current Neovim files:
```sh
# required
mv ~/.config/nvim{,.bak}

# optional but recommended
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}
[ -d ~/.config/coc ] && mv ~/.config/coc{,.bak}
```
- Clone the config
```sh
git clone https://github.com/philippviereck/nvim-config ~/.config/nvim --depth 1
```
- Remove the `.git` folder, so you can add it to your own repo later
```sh
# optional
rm -rf ~/.config/nvim/.git
```

# 🗑️ Uninstall
```sh
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.config/coc
```

# 🔥 Extras
### Install Nerd Font with brew
```sh
brew tap homebrew/cask-fonts &&
brew install --cask font-<FONT NAME>-nerd-font
```
### iTerm2 Github Theme
[Link](https://raw.githubusercontent.com/projekt0n/github-theme-contrib/main/themes/iterm/github_dark_dimmed.itermcolors)
