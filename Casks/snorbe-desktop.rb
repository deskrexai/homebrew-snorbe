cask "snorbe-desktop" do
  version "0.1.0"

  if Hardware::CPU.arm?
    sha256 "f34b483e30cb7034df9b94201da54c1a342dca301d6db861b20b015a79ddbcb4"
    url "https://github.com/deskrexai/snorbe-app/releases/download/v#{version}/Snorbe-Desktop-#{version}-arm64.dmg",
        verified: "github.com/deskrexai/snorbe-app/"
  else
    sha256 "7d5c9fdd6e9ebc76891bbc4ed799a7a392ecd98f50039622b81c45d472319357"
    url "https://github.com/deskrexai/snorbe-app/releases/download/v#{version}/Snorbe-Desktop-#{version}-x64.dmg",
        verified: "github.com/deskrexai/snorbe-app/"
  end

  name "Snorbe Desktop"
  desc "Bot-free recording app with on-device Whisper transcription and AI summarization"
  homepage "https://app.snorbe.deskrex.ai/"

  # NOTE: snorbe-app is a private GitHub repository. Users must set
  # HOMEBREW_GITHUB_API_TOKEN (or be authenticated via `gh auth login`) so brew
  # can download the .dmg asset. See:
  #   https://docs.brew.sh/Manpage#environment
  #
  # The .dmg is unsigned (no Apple Developer ID). Homebrew Cask automatically
  # strips the quarantine xattr on install, so no manual `xattr -dr` step is
  # required for the Cask path. (Direct .dmg download outside Homebrew still
  # needs `xattr -dr com.apple.quarantine /Applications/Snorbe\ Desktop.app`.)

  app "Snorbe Desktop.app"

  zap trash: [
    "~/Library/Application Support/snorbe-desktop",
    "~/Library/Preferences/ai.deskrex.snorbe.desktop.plist",
    "~/Library/Saved Application State/ai.deskrex.snorbe.desktop.savedState",
  ]
end
