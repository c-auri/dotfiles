# Config
My dotfiles and other configurations, organized using the git bare repository method:
- https://www.atlassian.com/git/tutorials/dotfiles
- https://www.youtube.com/watch?v=tBoLDpTWVOM

## Installations 
Install apt packages: 
```
apt install arandr awesome fzf mpv lxappearance lxsession lxpolkit ripgrep rofi vlc xterm
```

Install manually:
- [Alacritty](https://github.com/alacritty/alacritty/blob/master/INSTALL.md)
- [neovim](https://github.com/neovim/neovim/blob/master/INSTALL.md) and [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
- [zoxide](https://github.com/ajeetdsouza/zoxide?tab=readme-ov-file#installation)
- [eza](https://github.com/eza-community/eza/blob/main/INSTALL.md)
- [nvm](https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-and-updating) (running the install script should be enough)


## Manually install Themes
- Run `lxappearance` and select desired theme
- Rofi: 
  1. install [theme](https://github.com/adi1090x/rofi)
  3. edit `~/.config/rofi/launchers/type-4/shared/colors.rasi` to `@import "~/.config/rofi/colors/black.rasi"`
  4. edit `~/.config/rofi/launchers/type-4/shared/fonts.rasi` and set 'Ubuntu Mono 13' font
- Firefox 
  1. install [Firefox Color Extension](https://addons.mozilla.org/en-US/firefox/addon/firefox-color/)
  2. visit link to [custom theme](https://color.firefox.com/?theme=XQAAAAI8AQAAAAAAAABBKYhm849SCia48_6EGccwS-xMDPrv2Sw6Caq-qy5QgqeHG4K15QclheASPKN1fJIx9PWthmsaa6HAbqbuA9Kv-Hq-RuPvtK5tJ0Z6mvqzslWZE2dmNfQBe83zmLh3aFYkM5rdXNIcpTLXKdUFkKWXxis7LXNgOrAKWkz4h8wdMUrmBiCHyhzDq1dfmn9o5Esa_8jxLCXIMhHbVAhdfmry02dxMIis_vsabUA)
  3. install [Stylus Extension](https://addons.mozilla.org/en-US/firefox/addon/styl-us/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search)
  4. import `.config/stylus/stylus-YYYY-MM-DD.json` using Stylus plugin
