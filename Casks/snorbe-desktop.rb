cask "snorbe-desktop" do
  version "0.1.3"

  # Public release mirror — no token required, no special headers.
  # See https://github.com/deskrexai/snorbe-desktop-releases for the release
  # process. (Source code remains private at deskrexai/snorbe-app.)

  if Hardware::CPU.arm?
    sha256 "3ed1ce0f78f95ee295dea3e0b2fc5da92a19607309300a64647cea5bf189df72"
    url "https://github.com/deskrexai/snorbe-desktop-releases/releases/download/desktop-v#{version}/Snorbe.Desktop-#{version}-arm64.dmg"
  else
    sha256 "7d0064863228162b13f75512097c54fb8912e37efa2a0b5cea643df7cc7238d5"
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
