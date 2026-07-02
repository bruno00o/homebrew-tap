# bruno00o/homebrew-tap

Homebrew tap for [claude-dial](https://github.com/bruno00o/claude-dial) — a
physical M5Stack Dial desk companion for Claude Code.

## Install

```sh
brew tap bruno00o/tap
brew trust bruno00o/tap   # Homebrew 6+ gates third-party taps
brew install claude-dial
```

Then wire Claude Code to the bridge and keep the daemon running:

```sh
claude-dial hooks install --monitor-only --write
brew services start claude-dial            # simulator only
# …or, to drive the physical Dial over BLE:
claude-dial service install --ble --write
```

The simulator is at http://localhost:8787/.
