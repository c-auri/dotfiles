#!/usr/bin/env bash

# Rofi powermenu with a confirmation step for destructive actions

# Resolved through any symlink because rofi re-execs this file as a modi below.
self="$(readlink -f "$0")"
dir="$(dirname "$self")"

# The locker is named by $LOCKSCREEN_CMD, with no default: this menu makes no
# guess about where a lock script lives. command -v accepts both an absolute
# path and a bare name on PATH.
lock_available() {
    [ -n "$LOCKSCREEN_CMD" ] && command -v -- "$LOCKSCREEN_CMD" >/dev/null 2>&1
}

# Logging out does get a default, because ending the session through systemd
# assumes nothing beyond the systemctl dependency the other actions already
# carry. $LOGOUT_CMD overrides it with a window manager's own quit, and unlike
# the locker it is a shell command rather than a single executable, since
# every such quit takes arguments: awesome-client 'awesome.quit()', i3-msg
# exit, swaymsg exit...
#
# The session is resolved when the action runs rather than read from
# $XDG_SESSION_ID, which goes stale across a session restart and would then
# name a closed session while the live one keeps running.
logout="$LOGOUT_CMD"
if [ -z "$logout" ]
then
    logout='loginctl terminate-session "$(loginctl show-user "$USER" -p Display --value)"'
fi

logout_available() {
    command -v -- "${logout%% *}" >/dev/null 2>&1
}

# No group separators: rofi 1.7.1's listview ignores per-row vertical
# margin/padding/border (verified with `fixed-height: false` and a debug bg
# color via `element normal.urgent`), and `nonselectable` rows are still
# walked by arrow navigation. Flat list is the available trade-off.
#
# An action whose command is not configured or not resolvable is omitted
# entirely, rather than offered and then refused.
main_menu() {
    printf '\0prompt\x1f❯\n'
    lock_available && printf 'Lock\n'
    printf 'Shut down\n'
    printf 'Reboot\n'
    logout_available && printf 'Log out\n'
    lock_available && printf 'Suspend\nHibernate\n'

    return 0
}

confirm_menu() {
    printf 'Cancel\0info\x1fcancel\n'
    printf '%s\0info\x1fconfirm:%s\n' "$1" "$1"
}

# The guards are unreachable through the menu, which never offers an action
# whose command is missing. They cover it disappearing mid-session, where for
# Suspend the alternative is sleeping an unlocked display.
run_action() {
    case "$1" in
        "Lock")       lock_available || return; "$LOCKSCREEN_CMD" ;;
        # Sleep gives the locker time to grab the display before suspending.
        "Suspend")    lock_available || return; "$LOCKSCREEN_CMD" & sleep 0.5; systemctl suspend ;;
        "Hibernate")  lock_available || return; "$LOCKSCREEN_CMD" & sleep 0.5; systemctl hibernate ;;
        "Shut down")  systemctl poweroff ;;
        "Reboot")     systemctl reboot ;;
        "Log out")    logout_available || return; sh -c "$logout" ;;
    esac
}

# The script invokes itself as a rofi modi so the main and confirm menus
# share one rofi window (no flicker on transition). Rofi script mode has
# no programmatic close, so the handler writes the chosen action to a
# tempfile and SIGTERMs rofi (its own $PPID); the wrapper then runs it.
if [ -z "$ROFI_RETV" ]
then
    out=$(mktemp)
    trap 'rm -f "$out"' EXIT

    POWERMENU_OUT="$out" rofi -modi "powermenu:$self" -show powermenu \
        -theme "$dir/style.rasi" \
        -p "❯" \
        -i \
        -no-custom

    [ -s "$out" ] && run_action "$(cat "$out")"
    exit 0
fi

# Script-mode handler (invoked by rofi for each interaction).
case "$ROFI_RETV" in
    0)
        main_menu
        ;;
    1)
        case "$ROFI_INFO" in
            cancel)
                main_menu
                ;;
            confirm:*)
                printf '%s' "${ROFI_INFO#confirm:}" > "$POWERMENU_OUT"
                kill "$PPID"
                ;;
            *)
                if [ "$1" = "Lock" ]
                then
                    printf 'Lock' > "$POWERMENU_OUT"
                    kill "$PPID"
                else
                    confirm_menu "$1"
                fi
                ;;
        esac
        ;;
esac
