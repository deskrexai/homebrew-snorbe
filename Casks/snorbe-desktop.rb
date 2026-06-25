cask "snorbe-desktop" do
  version "0.1.4"

  # Public release mirror — no token required, no special headers.
  # See https://github.com/deskrexai/snorbe-desktop-releases for the release
  # process. (Source code remains private at deskrexai/snorbe-app.)

  if Hardware::CPU.arm?
    sha256 "009f8072119e7ae986b7deb60b97b49e56bd36b49ffdce0b624bbef9d0d57df5"
    url "https://github.com/deskrexai/snorbe-desktop-releases/releases/download/desktop-v#{version}/Snorbe.Desktop-#{version}-arm64.dmg"
  else
    sha256 "9224c4497b6980315cf56774b892e116fac0e7c9ffeda9cccba623303c8c5052"
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
