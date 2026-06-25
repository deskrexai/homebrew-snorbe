cask "snorbe-desktop" do
  version "0.1.8"

  # Public release mirror — no token required, no special headers.
  # See https://github.com/deskrexai/snorbe-desktop-releases for the release
  # process. (Source code remains private at deskrexai/snorbe-app.)

  if Hardware::CPU.arm?
    sha256 "68ff5ab7e4d9d07a805f4ba026f2e4afb81cf1598aee8301ec821ec5a74d5a9b"
    url "https://github.com/deskrexai/snorbe-desktop-releases/releases/download/desktop-v#{version}/Snorbe.Desktop-#{version}-arm64.dmg"
  else
    sha256 "4afdbb9e616ce2dc24901639afe0631ea76a13f65aa473bfcf72c2883b28745d"
    url "https://github.com/deskrexai/snorbe-desktop-releases/releases/download/desktop-v#{version}/Snorbe.Desktop-#{version}.dmg"
  end

  name "Snorbe Desktop"
  desc "Bot-free recording app with on-device Whisper transcription and AI summarization"
  homepage "https://app.snorbe.deskrex.ai/"

  # The .dmg is currently unsigned (no Apple Developer ID — tracked in
  # deskrexai/snorbe-app#1667). Homebrew Cask automatically strips the
  # quarantine xattr on install — no manual `xattr -dr` needed.

  auto_updates true

  app "Snorbe Desktop.app"

  zap trash: [
    "~/Library/Application Support/snorbe-desktop",
    "~/Library/Preferences/ai.deskrex.snorbe.desktop.plist",
    "~/Library/Saved Application State/ai.deskrex.snorbe.desktop.savedState",
  ]
end
