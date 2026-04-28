#!/usr/bin/env bash
dir="$HOME/.config/rofi/powermenu"
lock="$HOME/.config/awesome/lockscreen/lock.sh"

selected=$(
    {
        printf 'Lock\n'
        printf ' \n'
        printf 'Shut down\n'
        printf 'Reboot\n'
        printf 'Log out\n'
        printf ' \n'
        printf 'Suspend\n'
        printf 'Hibernate\n'
    } | rofi -dmenu \
        -p "❯" \
        -i \
        -no-custom \
        -theme "$dir/style.rasi"
)

[ -z "$selected" ] && exit 0

confirm() {
    printf 'Cancel\nConfirm' | rofi -dmenu \
        -p "$1?" \
        -no-custom \
        -selected-row 0 \
        -theme "$dir/style.rasi"
}

case "$selected" in
    "Lock")
        "$lock"
        ;;
    "Shut down"|"Reboot"|"Log out"|"Suspend"|"Hibernate")
        answer=$(confirm "$selected")
        [ "$answer" = "Confirm" ] || exit 0
        case "$selected" in
            "Suspend")
                "$lock" &
                sleep 0.5
                systemctl suspend
                ;;
            "Hibernate")
                "$lock" &
                sleep 0.5
                systemctl hibernate
                ;;
            "Shut down")
                systemctl poweroff
                ;;
            "Reboot")
                systemctl reboot
                ;;
            "Log out")
                awesome-client 'awesome.quit()'
                ;;
        esac
        ;;
esac
