cask "snorbe-desktop" do
  version "0.1.9"

  # Public release mirror — no token required, no special headers.
  # See https://github.com/deskrexai/snorbe-desktop-releases for the release
  # process. (Source code remains private at deskrexai/snorbe-app.)
  #
  # Apple Silicon only: whisper-cli binary is committed for darwin-arm64
  # only (apps/desktop/resources/whisper/darwin-arm64/). Intel Mac support
  # is tracked separately — see deskrexai/snorbe-app for status.

  depends_on arch: :arm64

  sha256 "c94767531aa524ca53ba4e34c398d763dd24f64228822b85ed33f1627565f041"
  url "https://github.com/deskrexai/snorbe-desktop-releases/releases/download/desktop-v#{version}/Snorbe.Desktop-#{version}-arm64.dmg"

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
