# Lock Screen

Scripts that implement screen locking and idle-based auto-lock for AwesomeWM.

## Files

| File | Purpose |
|---|---|
| `lock.sh` | Invokes xsecurelock with the desired appearance (font, colors). Called by the rofi power menu and by xidlehook on idle timeout. |
| `dim.sh` | Gradually dims all connected displays to 20% brightness. Called by xidlehook at the first idle timer. |
| `undim.sh` | Restores all connected displays to full brightness. Called by xidlehook as the canceller when activity resumes before the lock triggers. |


## Dependencies

- **xsecurelock** — the screen locker. Install via apt:
  ```sh
  apt install xsecurelock
  ```

- **xidlehook** — the idle daemon that fires the dim/lock timers. Not in apt; build from source (requires Rust):
  ```sh
  # Install Rust first if needed: https://rustup.rs
  cargo install xidlehook --bins
  ```
  The binary lands in `~/.cargo/bin/`. Make sure that directory is in `$PATH`.

## How it works

### Manual lock

The rofi power menu (`~/.config/rofi/powermenu/`) calls `lock.sh` directly when the user picks `Lock`. It also calls `lock.sh` before issuing `systemctl suspend` / `hibernate` so the display is locked across a sleep cycle.

### Auto-lock on idle

`xidlehook` is started by `autorun.sh` when the session begins, using two sequential timers:

```
0 min        3 min               5 min
|            |                   |
| ... idle   | dim screen slowly | lock screen
|            |                   |
             ^ move mouse/type → screen un-dims, timer resets
```

- After **3 minutes idle**: `dim.sh` runs (slow fade to 20%)
- If activity resumes: `undim.sh` runs and the timer resets to zero
- After **5 minutes idle** (2 min after dimming, if undisturbed): `undim.sh` then `lock.sh` run

The `--not-when-fullscreen` flag is passed to xidlehook, so all timers are paused while a fullscreen window is active (e.g. video playback, image slideshow). Audio-only playback does not exempt the machine.

### Per-machine opt-out

Auto-lock is on by default so a misconfigured or new machine fails toward the more secure outcome. To disable it on a specific machine, set this variable before the session starts:

```sh
# ~/.xprofile
export LOCK_IDLE_DISABLE=1
```

The Gnome Display Manager (GDM) sources `~/.xprofile` before the session. If the file does not exist, create it. 

## Appearance

xsecurelock renders a plain dark background with a minimal text prompt. No animations or ring indicator. Appearance is controlled via environment variables in `lock.sh`.

## Testing

1. **Manual lock** — open the power menu and select `Lock`. xsecurelock should appear immediately. Enter the wrong password: error text is shown. Enter the correct password: screen unlocks.
2. **Idle dim** — leave the machine idle for 3 minutes. The screen should fade to 20% brightness. Move the mouse: brightness restores and the timer resets.
3. **Idle lock** — leave the machine idle for 5 minutes without interrupting the dim. xsecurelock should appear at the 5-minute mark.
4. **Fullscreen exemption** — open a fullscreen video and leave it idle for 10+ minutes. The screen should not dim or lock.
5. **Audio-only** — play music with no fullscreen window. Leave idle for 5 minutes. The screen should still lock.
6. **Per-machine disable** — set `LOCK_IDLE_DISABLE=1` in `~/.xprofile` and restart the session. Leave idle indefinitely: no auto-lock. Manual lock via the power menu should still work.
7. **Crash resilience** — while the screen is locked, restart AwesomeWM (`Meta + Ctrl + V`). The screen should remain locked.
