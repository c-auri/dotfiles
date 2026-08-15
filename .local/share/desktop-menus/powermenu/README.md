# Power Menu

Rofi-based menu for session and system actions: 

- lock
- log out 
- shut down
- reboot
- suspend
- hibernate 

## Configuration

Lock, Suspend, and Hibernate need a lock script. There is no default: point `LOCKSCREEN_CMD` at an executable that locks the display and blocks until unlocked. Either an absolute path or the name of a command on `PATH` works.

```bash
export LOCKSCREEN_CMD="$HOME/path/to/lock.sh"
```

Set it somewhere the graphical session sources, such as `~/.profile`, rather than `~/.bashrc`; the menu inherits its environment from the session, not from a terminal. A change takes effect on the next login, not on a window manager restart.

If `LOCKSCREEN_CMD` is unset or does not resolve to an executable, Lock, Suspend, and Hibernate are left out of the menu entirely. Nothing is offered that would then fail, and the machine can never sleep with an unlocked display because of a missing setting.

Log out needs no configuration. It defaults to ending the session through systemd, which the menu already depends on for Shut down and Reboot:

```sh
loginctl terminate-session "$(loginctl show-user "$USER" -p Display --value)"
```

The session is looked up when the action runs rather than taken from `$XDG_SESSION_ID`, because that variable goes stale across a session restart and would then name a closed session while the live one keeps running.

Set `LOGOUT_CMD` to override it with the window manager's own quit. Unlike `LOCKSCREEN_CMD`, it is a shell command rather than a single executable, since these all take arguments:

```bash
export LOGOUT_CMD="awesome-client 'awesome.quit()'"   # or: i3-msg exit, swaymsg exit, bspc quit
```

Log out drops out of the menu only if the command's first word cannot be resolved, which on a systemd machine means never.

Lock executes immediately. Every other action prompts for confirmation in the same rofi window — the action name itself is the confirm choice; cancel returns to the main menu. Suspend and Hibernate run the lockscreen first so the display is locked before the system sleeps.

## Design notes

- **Single rofi instance.** Main and confirm menus share one long-lived rofi window via script mode, so there is no flicker between prompts.
- **Menu built per invocation.** The action list is generated on each open rather than being static, so the locking actions can be omitted when no locker is configured. `run_action` still guards them, which is unreachable via the menu but covers the locker disappearing mid-session.
- **No group separators.** The actions fall naturally into three groups (lock / destructive / sleep) but rofi 1.7.1 will not honor per-row vertical spacing in any form, so the menu renders flat. See the comment in `powermenu.sh` for what was tried.
