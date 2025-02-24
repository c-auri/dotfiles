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
- [neovim](https://github.com/neovim/neovim/blob/master/INSTALL.md)
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
  2. visit link to [custom theme](https://color.firefox.com/?theme=XQAAAAKGAQAAAAAAAABBKYhm849SCia6aSqEGccwS-xNKliFvrJIcAF6ENZLAc3GqWJ4cTCWcqYqLSjBwhbYEWAdmqwHvbYFhZr34Na49EadonypbMvhzVBrjdzM5iZh075P423qIDkuNGHkQkxYYKPsQsaE2gylOg5ymWTDNfbYvW1qyVfdus6ipCxXzB4fPqV1uux3x9WHPWk913oZojM-n0pSeKk9jTfoT6kaFrCMlX00fbK1RBEfUgYPtazDli3qcmrVbb_w2PGe3Gv6SKdZ8IbO3sTA17mf_rBl7g)
