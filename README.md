# dotfiles
The configuration files for my operating system, currently Ubuntu 22.04. Managed using a bare git repository, for explanations see the [Atlassian Guide](https://www.atlassian.com/git/tutorials/dotfiles) or this [DistroTube video](https://www.youtube.com/watch?v=tBoLDpTWVOM).

## Setting up the Repository
1. Clone into your home directory as a bare repository:
    ```bash
   git clone --bare <repo-url> $HOME/.config/.git
    ```

1. Create `con` alias:
    ```bash
   alias con="/usr/bin/git --git-dir=$HOME/.config/ --work-tree=$HOME"
    ```
    - There's no need to put this in your `.bashrc` since that's going to be overwritten in the next step anyways. Just paste the command into your terminal.

1. Checkout the content of the bare repository to your home directory:
    ```bash
   con checkout
    ```
    - If the checkout fails because some files would be overwritten, create backups, delete the files and then try again.

1. Hide untracked files:
    ```bash
   con config --local status.showUntrackedFiles no
    ```

1. Create `~/.config/git/local.ini` and add your user name and email:
    ```ini
   [user]
       name = <git-user-name>
       email = <git-user-email>
    ```

1. Restart your terminal.

## Installations
Install apt packages:
```bash
sudo apt install \
    awesome rofi xterm \
    arandr lxappearance lxsession lxpolkit \
    bat fd-find ripgrep tmux xclip jq \
    gimp flameshot mpv vlc
```
> [!IMPORTANT]
> If all else fails, awesome defaults to xterm.
> So better make sure it's always there, even if you intend to use a different terminal.

Install manually:
- [alacritty](https://github.com/alacritty/alacritty/blob/master/INSTALL.md)
- [neovim](https://github.com/neovim/neovim/blob/master/INSTALL.md) and [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
- [eza](https://github.com/eza-community/eza/blob/main/INSTALL.md)
- [nvm](https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-and-updating) (running the install script should be enough)
- [fzf](https://github.com/junegunn/fzf?tab=readme-ov-file#using-git)
- [vivify](https://github.com/jannis-baum/vivify)

## Manual Theming
- Run `lxappearance` and select desired theme
- Rofi:
  1. install [theme](https://github.com/adi1090x/rofi)
  3. edit `~/.config/rofi/launchers/type-4/shared/colors.rasi` to `@import "~/.config/rofi/colors/black.rasi"`
  4. edit `~/.config/rofi/launchers/type-4/shared/fonts.rasi` and set font to 'Ubuntu Mono 13'
- Firefox
  1. install [Firefox Color Extension](https://addons.mozilla.org/en-US/firefox/addon/firefox-color/)
  2. visit link to [custom theme](https://color.firefox.com/?theme=XQAAAAJ_AQAAAAAAAABBKYhm849SCia73laEGccwS-xMDPr1qJSHhuu4s9wMJLlJ9dAdxyHeE6nQeWdDnNzjA3gavA2wvQ_m7_lBdxtETuZvw3ss445xH-D8Zlnwg0tilN8DkBUCna7nTysJS7LuwKod9QJT53ou5ZBZ1kDi3K3mllfzIuqhNf8tVEKttOdqlEsXTBa_Db9C3ZKwkj-yAPH7x8-8UX7vdJgz90ODpINQ3fv_iufTf38dgIRa0hoxgo5E1hSb9bOM8_tWTSdIL8CY0ar9ZBsE)
  3. install [Stylus Extension](https://addons.mozilla.org/en-US/firefox/addon/styl-us/) and import custom themes defined in `.config/.stylus.json`
