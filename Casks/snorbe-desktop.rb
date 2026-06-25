cask "snorbe-desktop" do
  version "0.1.6"

  # Public release mirror — no token required, no special headers.
  # See https://github.com/deskrexai/snorbe-desktop-releases for the release
  # process. (Source code remains private at deskrexai/snorbe-app.)

  if Hardware::CPU.arm?
    sha256 "b18f6bd42fa5d5b8a50e6f24c1a8d7533d51d6f2699f755210b737b968113085"
    url "https://github.com/deskrexai/snorbe-desktop-releases/releases/download/desktop-v#{version}/Snorbe.Desktop-#{version}-arm64.dmg"
  else
    sha256 "c318752b53abb388e4e0e81e8396fee72b9ee7d699cdd10ca1c1cf1410ee4849"
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
