# Config
My dotfiles and other configurations.

## How to use
The files are organized using the git bare repository method. For explanations, see this [DistroTube video](https://www.youtube.com/watch?v=tBoLDpTWVOM) on YouTube or the [Atlassian Guide](https://www.atlassian.com/git/tutorials/dotfiles).

### Setup
1. Clone into your home directory as a bare repository:
    ```bash
    git clone --bare <repo-url> $HOME/.config/.git
    ```
1. Add a `cfg` alias to your `.bashrc`:
    ```bash
    echo "alias cfg='/usr/bin/git --git-dir=$HOME/.config/ --work-tree=$HOME'" >> $HOME/.bashrc
    ```
1. Source the `.bashrc` to load the alias into the current shell session:
   ```bash
   source ~/.bashrc
   ```
1. Checkout the content of the bare repository to your home directory:
    ```bash
    cfg checkout
    ```
    - If the checkout fails because some files would be overwritten, delete those files (create a backup if you care about them) and then try the checkout again.
1. Hide untracked files:
    ```bash
    cfg config --local status.showUntrackedFiles no
    ```
1. Populate the `remote.origin.fetch` property
```bash
git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
```

## Installations
Install apt packages:
```
apt install arandr awesome bat fd-find flameshot fzf gawk gimp mpv ncal lxappearance lxsession lxpolkit ripgrep rofi tmux vlc xterm
```

Install manually:
- [alacritty](https://github.com/alacritty/alacritty/blob/master/INSTALL.md)
- [neovim](https://github.com/neovim/neovim/blob/master/INSTALL.md) and [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
- [starship](https://starship.rs/guide/#%F0%9F%9A%80-installation)
- [zoxide](https://github.com/ajeetdsouza/zoxide?tab=readme-ov-file#installation)
- [eza](https://github.com/eza-community/eza/blob/main/INSTALL.md)
- [nvm](https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-and-updating) (running the install script should be enough)
- [fd](https://github.com/sharkdp/fd?tab=readme-ov-file#installation): run `ln -s $(which fdfind) ~/.local/bin/fd`


## Manual Theming 
- Run `lxappearance` and select desired theme
- Rofi:
  1. install [theme](https://github.com/adi1090x/rofi)
  3. edit `~/.config/rofi/launchers/type-4/shared/colors.rasi` to `@import "~/.config/rofi/colors/black.rasi"`
  4. edit `~/.config/rofi/launchers/type-4/shared/fonts.rasi` and set font to 'Ubuntu Mono 13'
- Firefox
  1. install [Firefox Color Extension](https://addons.mozilla.org/en-US/firefox/addon/firefox-color/)
  2. visit link to [custom theme](https://color.firefox.com/?theme=XQAAAAJ_AQAAAAAAAABBKYhm849SCia73laEGccwS-xMDPrzPNSHTzD0uwJ62Fcgv-9XbzvlLvawvU1sH8Ueaqlp9DytwMBZzyYK2M9C3hOppcXq1RrbbxpUcOZOCBKak5x_JFP_HDnlGGuE5MS7l_sJoTckVnE7aNdfEfcAgvUq-hOpd-3cA27WleLRjFmmbmt_ViLkIGkpaN2PTV62w-hJVo_oGafUu6lFFT2o2TjIiE2oyu3yLQvDxn5q5_AFzv7r1TmIWidg_AwTCr_9No1R)
  3. install [Stylus Extension](https://addons.mozilla.org/en-US/firefox/addon/styl-us/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search)
  4. import `.config/stylus/styles.json` using Stylus plugin
