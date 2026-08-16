#!/usr/bin/env bash

# Rofi powermenu with a confirmation step for destructive actions

# Resolved through any symlink because rofi re-execs this file as a modi below.
self="$(readlink -f "$0")"
dir="$(dirname "$self")"

# The locker is `lockscreen`, a sibling component symlinked onto PATH, so it is
# called by name rather than through a variable. It is still checked rather
# than assumed: a machine that has not finished its setup loses the locking
# actions instead of being offered ones that would fail.
lock_available() {
    command -v -- lockscreen >/dev/null 2>&1
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
        "Lock")       lock_available || return; lockscreen ;;
        # Sleep gives the locker time to grab the display before suspending.
        "Suspend")    lock_available || return; lockscreen & sleep 0.5; systemctl suspend ;;
        "Hibernate")  lock_available || return; lockscreen & sleep 0.5; systemctl hibernate ;;
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

    # Every key that would otherwise type into the hidden input, parked on
    # kb-clear-line, which does nothing when the input is already empty. Rofi
    # 1.7.1 has no switch to turn matching off, so neutralising the keys one by
    # one is the only way to stop the menu filtering itself out of view.
    #
    # German layout, all three levels. Uppercase letters need no entry because
    # binding the lowercase keysym catches the shifted one too; the other levels
    # do not work that way and are listed in full.
    #
    # dead_grave is deliberately absent. Rofi already binds it to
    # kb-toggle-case-sensitivity, and rather than rejecting the duplicate it
    # drops the whole keymap, Return included.
    inert="Control+w"
    inert="$inert,a,b,c,d,e,f,g,h,i,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z"
    inert="$inert,1,2,3,4,5,6,7,8,9,0"
    inert="$inert,minus,equal,bracketleft,bracketright,semicolon,apostrophe"
    inert="$inert,comma,period,slash,backslash,numbersign,less,plus,space"
    inert="$inert,adiaeresis,odiaeresis,udiaeresis,ssharp"
    inert="$inert,dead_acute,dead_circumflex"
    inert="$inert,degree,exclam,quotedbl,section,dollar,percent,ampersand"
    inert="$inert,parenleft,parenright,question,asterisk,greater,colon,underscore"
    inert="$inert,Adiaeresis,Odiaeresis,Udiaeresis"
    inert="$inert,twosuperior,threesuperior,braceleft,braceright"
    inert="$inert,at,EuroSign,asciitilde,bar,mu"

    POWERMENU_OUT="$out" rofi -modi "powermenu:$self" -show powermenu \
        -theme "$dir/style.rasi" \
        -p "❯" \
        -i \
        -no-custom \
        -kb-row-down "j,Down,Control+n" \
        -kb-row-up "k,Up,Control+p,ISO_Left_Tab" \
        -kb-clear-line "$inert"

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
