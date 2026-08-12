# Power Menu

Rofi-based menu for session and system actions: 

- lock
- log out 
- shut down
- reboot
- suspend
- hibernate 

AwesomeWM calls it via keybinding in `rc.lua`.

## Configuration

Lock, Suspend, and Hibernate need a lock script. There is no default: point `LOCKSCREEN_CMD` at an executable that locks the display and blocks until unlocked. Either an absolute path or the name of a command on `PATH` works.

```bash
export LOCKSCREEN_CMD="$HOME/path/to/lock.sh"
```

Set it somewhere the graphical session sources, such as `~/.profile`, rather than `~/.bashrc`; the menu inherits its environment from the session, not from a terminal. A change takes effect on the next login, not on an AwesomeWM restart.

If `LOCKSCREEN_CMD` is unset or does not resolve to an executable, Lock, Suspend, and Hibernate are left out of the menu entirely; the menu shows Shut down, Reboot, and Log out, which need no locker. Nothing is offered that would then fail, and the machine can never sleep with an unlocked display because of a missing setting.

Lock executes immediately. Every other action prompts for confirmation in the same rofi window — the action name itself is the confirm choice; cancel returns to the main menu. Suspend and Hibernate run the lockscreen first so the display is locked before the system sleeps.

## Design notes

- **Single rofi instance.** Main and confirm menus share one long-lived rofi window via script mode, so there is no flicker between prompts.
- **Menu built per invocation.** The action list is generated on each open rather than being static, so the locking actions can be omitted when no locker is configured. `run_action` still guards them, which is unreachable via the menu but covers the locker disappearing mid-session.
- **No group separators.** The actions fall naturally into three groups (lock / destructive / sleep) but rofi 1.7.1 will not honor per-row vertical spacing in any form, so the menu renders flat. See the comment in `powermenu.sh` for what was tried.
