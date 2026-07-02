class ClaudeDial < Formula
  desc "Physical M5Stack Dial desk companion for Claude Code"
  homepage "https://github.com/bruno00o/claude-dial"
  # Prebuilt binary attached to the GitHub Release by the release-binaries
  # workflow; the release's .sha256 asset holds the value below. Apple Silicon
  # only — the BLE bridge targets the Macs this ships to.
  url "https://github.com/bruno00o/claude-dial/releases/download/v0.17.0/claude-dial_v0.17.0_darwin_arm64.tar.gz"
  version "0.17.0"
  sha256 "9907c0eace3929e353127daf18dbfb9fc4cfd950160fb724c8ee719917563a89"
  license "MIT"

  depends_on arch: :arm64
  depends_on :macos

  def install
    bin.install "claude-dial"
  end

  # `brew services start claude-dial` runs the bridge (simulator only). To drive
  # the physical Dial over BLE, run `claude-dial service install --ble --write`
  # instead — that launchd agent and brew services are two ways to the same end,
  # so enable only one (both would fight over the port).
  service do
    run [opt_bin/"claude-dial", "serve", "--ble"]
    keep_alive true
    log_path var/"log/claude-dial.log"
    error_log_path var/"log/claude-dial.log"
  end

  def caveats
    <<~EOS
      Point Claude Code at the bridge (non-blocking session view):
        claude-dial hooks install --monitor-only --write

      First run — grant Bluetooth so the daemon can reach the Dial. A background
      service can't show the macOS prompt, so run it once in the foreground and
      click Allow:
        claude-dial serve --ble
        # allow the Bluetooth prompt, watch "dial" go scanning... -> connected, then Ctrl-C

      Then keep it running at login (drives the Dial over BLE):
        brew services start claude-dial

      Open the simulator at http://localhost:8787/
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude-dial version")
  end
end
