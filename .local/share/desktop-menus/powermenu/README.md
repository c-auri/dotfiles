# Power Menu

Rofi-based menu for session and system actions: 

- lock
- log out 
- shut down
- reboot
- suspend
- hibernate 

Lock executes immediately. Every other action prompts for confirmation in the same rofi window; the action name itself is the confirm choice, and cancel returns to the main menu. Suspend and Hibernate run the lockscreen first so the display is locked before the system sleeps.

## Delegation

Lock, Suspend, and Hibernate run [`lockscreen`](../../lockscreen/README.md), which `.local/bin` symlinks onto `PATH`. If that name does not resolve, those three actions are left out of the menu entirely. Nothing is offered that would then fail, and the machine cannot sleep with an unlocked display because the locker is missing.

Log out runs `$LOGOUT_CMD`, exported from [`.profile`](../../../../.profile) as AwesomeWM's own quit:

```sh
awesome-client 'awesome.quit()'
```

It holds a shell command rather than a bare executable, because every window manager's quit takes arguments. With the variable unset the menu ends the session through systemd instead, which it already depends on for Shut down and Reboot:

```sh
loginctl terminate-session "$(loginctl show-user "$USER" -p Display --value)"
```

The session is looked up when the action runs rather than taken from `$XDG_SESSION_ID`, because that variable goes stale across a session restart and would then name a closed session while the live one keeps running.

Log out drops out of the menu only if the command's first word cannot be resolved, which on a systemd machine means never.

Shut down and Reboot call `systemctl` directly.

## Design notes

- **Single rofi instance.** Main and confirm menus share one long-lived rofi window via script mode, so there is no flicker between prompts.
- **Menu built per invocation.** The action list is generated on each open rather than being static, so the locking actions can be omitted when no locker is configured. `run_action` still guards them, which is unreachable via the menu but covers the locker disappearing mid-session.
- **No group separators.** The actions fall naturally into three groups (lock / destructive / sleep) but rofi 1.7.1 will not honor per-row vertical spacing in any form, so the menu renders flat. See the comment in `powermenu.sh` for what was tried.
- **Vim navigation.** `j` and `k` move the selection alongside the arrow keys. Rofi replaces a binding list rather than extending it, so `-kb-row-down` and `-kb-row-up` restate the defaults next to the new keys.
- **The list is still filtered, invisibly.** Hiding the input bar is deliberate: the menu is short enough to navigate, and a text field would invite typing. But rofi keeps matching on every letter that is not bound to something else, with nothing on screen to show it. A stray keypress narrows the list, and one that matches nothing leaves `-no-custom` with no entry to accept, so Enter appears to do nothing. Rofi 1.7.1 has no way to turn matching off; a genuinely unfilterable list would mean leaving rofi.
