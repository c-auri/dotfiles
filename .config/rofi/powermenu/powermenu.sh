#!/usr/bin/env bash

# Rofi powermenu with a confirmation step for destructive actions

dir="$HOME/.config/rofi/powermenu"
lock="$HOME/.config/lockscreen/lock.sh"

# No group separators: rofi 1.7.1's listview ignores per-row vertical
# margin/padding/border (verified with `fixed-height: false` and a debug bg
# color via `element normal.urgent`), and `nonselectable` rows are still
# walked by arrow navigation. Flat list is the available trade-off.
main_menu() {
    printf '\0prompt\x1f❯\n'
    printf 'Lock\n'
    printf 'Shut down\n'
    printf 'Reboot\n'
    printf 'Log out\n'
    printf 'Suspend\n'
    printf 'Hibernate\n'
}

confirm_menu() {
    printf 'Cancel\0info\x1fcancel\n'
    printf '%s\0info\x1fconfirm:%s\n' "$1" "$1"
}

run_action() {
    case "$1" in
        "Lock")       "$lock" ;;
        # Sleep gives the locker time to grab the display before suspending.
        "Suspend")    "$lock" & sleep 0.5; systemctl suspend ;;
        "Hibernate")  "$lock" & sleep 0.5; systemctl hibernate ;;
        "Shut down")  systemctl poweroff ;;
        "Reboot")     systemctl reboot ;;
        "Log out")    awesome-client 'awesome.quit()' ;;
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

    POWERMENU_OUT="$out" rofi -modi "powermenu:$0" -show powermenu \
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
