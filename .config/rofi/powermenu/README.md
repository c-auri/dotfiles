# Power Menu

Rofi-based menu for session and system actions: 

- lock
- log out 
- shut down
- reboot
- suspend
- hibernate 

AwesomeWM calls it via keybinding in `rc.lua`. Depends on the lockscreen at `~/.config/lockscreen/`.

Lock executes immediately. Every other action prompts for confirmation in the same rofi window — the action name itself is the confirm choice; cancel returns to the main menu. Suspend and Hibernate run the lockscreen first so the display is locked before the system sleeps.

## Design notes

- **Single rofi instance.** Main and confirm menus share one long-lived rofi window via script mode, so there is no flicker between prompts.
- **No group separators.** The actions fall naturally into three groups (lock / destructive / sleep) but rofi 1.7.1 will not honor per-row vertical spacing in any form, so the menu renders flat. See the comment in `powermenu.sh` for what was tried.
