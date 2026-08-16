# Lock Screen

Scripts that implement screen locking and idle-based auto-lock for AwesomeWM.

## Layout

The scripts live in `~/.local/share/lockscreen/` as one unit, because `lock.sh` needs `saver_solid` sitting next to it. The three entry points are reachable as commands through symlinks in `~/.local/bin`, which are tracked in this repo and therefore created by the checkout; no install step:

```
lockscreen        -> ~/.local/share/lockscreen/lock.sh
lockscreen-dim    -> ~/.local/share/lockscreen/dim.sh
lockscreen-undim  -> ~/.local/share/lockscreen/undim.sh
```

`lock.sh` resolves its own directory with `readlink -f`, so `saver_solid` is found through the symlink as well as by direct call. Callers use the bare names and hold no paths.

## Files

- `lock.sh`: Invokes xsecurelock with the desired appearance (font, colors). Called by the rofi power menu and by xidlehook on idle timeout.
- `dim.sh`: Gradually dims all connected displays to 20% brightness over about four seconds. Records its PID in `$XDG_RUNTIME_DIR` so the fade can be stopped while it is still stepping. Called by xidlehook at the first idle timer.
- `undim.sh`: Kills an in-progress fade, then restores all connected displays to full brightness. The kill is what makes the restore stick: the fade sets brightness every half second, so a reset issued while it is still running is overwritten by its next step. Called by xidlehook as the canceller when activity resumes before the lock triggers.
- `saver_solid`: Tiny xsecurelock saver module that paints its window a single solid color (`$SAVER_SOLID_COLOR`). Lets the area behind the auth dialog match the auth dialog's own background, since the bundled `saver_blank` is hardcoded to pure black. Python script using `ctypes` against `libX11.so.6` — no install or compile step.

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
  The binary lands in `~/.cargo/bin/`, which `.profile` puts on `PATH` so the graphical session can resolve it. `autorun.sh` invokes it by bare name and its failure is silent, so a missing binary means no auto-lock rather than an error anyone sees.

## How it works

### Manual lock

The [power menu](../desktop-menus/powermenu/README.md) runs `lockscreen` when the user picks `Lock`, and runs it again before issuing `systemctl suspend` / `hibernate` so the display is locked across a sleep cycle. It calls the command by name off `PATH`, and hides those three actions when the name does not resolve, so nothing is offered that would then fail.

### Auto-lock on idle

`xidlehook` is started by `autorun.sh` when the session begins, using two sequential timers. At the default timings:

```
0:00         3:00          3:10
|            |             |
| ... idle   | dim screen  | lock screen
|            |             |
             ^ move mouse/type → screen un-dims, timer resets
```

- After **3 minutes idle**: `dim.sh` runs (slow fade to 20%)
- If activity resumes: `undim.sh` runs and the timer resets to zero
- **10 seconds later**, if undisturbed: `undim.sh` then `lock.sh` run

The `--not-when-fullscreen` flag is passed to xidlehook, so all timers are paused while a fullscreen window is active (e.g. video playback, image slideshow). Audio-only playback does not exempt the machine.

### Per-machine configuration

Four environment variables control the hook. They share an `IDLE_` prefix so they sort together in an alphabetical environment dump:

- `IDLE_DIM_AFTER_SECONDS`: seconds of idle before the screen dims. Defaults to `180`. Values below `10` are treated as mistakes and replaced by the default.
- `IDLE_DIM_DISABLE`: set to `1` to turn the whole hook off, dimming and locking both.
- `IDLE_LOCK_DISABLE`: set to `1` to keep the dim but never lock.
- `IDLE_LOCK_SECONDS_AFTER_DIM`: further seconds before the screen locks. Defaults to `10`. It counts from the dim rather than from the start of the idle period, so the lock happens at `IDLE_DIM_AFTER_SECONDS + IDLE_LOCK_SECONDS_AFTER_DIM` seconds idle.

The two switches are deliberately asymmetric. The lock timer is chained behind the dim timer, so there is nothing for it to follow once the dim is gone: disabling the dim disables the hook outright, while disabling the lock leaves the fade in place as an idle indicator.

`autorun.sh` reads all four when the session starts, so they have to be in the environment by then. GDM sources `~/.profile`, which in turn sources every `*.sh` in `~/.profiles/`, so a drop-in there is where machine-specific values belong (see `~/docs/shell-startup.md`):

```sh
# ~/.profiles/local.sh
export IDLE_DIM_AFTER_SECONDS=600
export IDLE_LOCK_SECONDS_AFTER_DIM=30
```

Auto-lock is on unless it is explicitly disabled, so a machine with no drop-in at all still locks itself. A duration that is not a whole number of seconds, or is implausibly short, is replaced by its default rather than handed to xidlehook, which would refuse the argument and leave the session with no auto-lock at all. Only the exact value `1` disables anything; `0`, `false`, and `no` all leave the hook running.

## Appearance

xsecurelock renders a plain dark background with a minimal text prompt. No animations or ring indicator. Colors and font are set in `lock.sh` and follow the Kanagawa Dragon palette (see `~/.config/alacritty/kanagawa/dragon.toml`). The area behind the auth dialog is painted by `saver_solid` so it matches the dialog's own background — without it, the bundled saver leaves a pure-black surround that contrasts visibly with Dragon's `#181616`.

## Testing

1. **Manual lock** — open the power menu and select `Lock`. xsecurelock should appear immediately. Enter the wrong password: error text is shown. Enter the correct password: screen unlocks.
2. **Idle dim** — leave the machine idle for 3 minutes. The screen should fade to 20% brightness. Move the mouse: brightness restores and the timer resets.
3. **Idle lock** — leave the machine idle for 3 minutes 10 seconds without interrupting the dim. xsecurelock should appear about ten seconds after the fade finishes.
4. **Fullscreen exemption** — open a fullscreen video and leave it idle for 10+ minutes. The screen should not dim or lock.
5. **Audio-only** — play music with no fullscreen window. Leave idle past the lock delay. The screen should still lock.
6. **Custom timings** — set `IDLE_DIM_AFTER_SECONDS=20` and `IDLE_LOCK_SECONDS_AFTER_DIM=10` in a `~/.profiles` drop-in and restart the session. The screen should dim at 20 seconds and lock at 30. Then set `IDLE_DIM_AFTER_SECONDS=abc` and restart: the defaults apply again and auto-lock still works. Same for `IDLE_DIM_AFTER_SECONDS=5`, which is below the floor.
7. **Dim without lock** — set `IDLE_LOCK_DISABLE=1` and restart the session. The screen should dim on schedule and then stay dim indefinitely without locking. Input should still restore brightness.
8. **Full disable** — set `IDLE_DIM_DISABLE=1` and restart the session. Leave idle indefinitely: no dim, no lock. Manual lock via the power menu should still work.
9. **Crash resilience** — while the screen is locked, restart AwesomeWM (`Meta + Ctrl + V`). The screen should remain locked.
