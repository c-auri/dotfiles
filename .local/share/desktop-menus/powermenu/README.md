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
- **Filtering is neutralized, not switched off.** Hiding the input bar is deliberate, but rofi 1.7.1 keeps matching on whatever is typed and shows nothing on screen while it does. A stray keypress would narrow the list, and one that matches nothing would leave `-no-custom` with no entry to accept, so Enter appears dead. There is no option to disable matching, so `-kb-clear-line` collects every text-producing key instead: the action is a no-op while the input is empty, and a key bound to an action never reaches the filter. The list assumes a German layout and covers all three levels of it, minus `dead_grave`, which rofi already uses for `kb-toggle-case-sensitivity` and which takes the entire keymap down with it if listed twice.
