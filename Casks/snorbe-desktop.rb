cask "snorbe-desktop" do
  version "0.1.0"

  # NOTE: Private GitHub Releases REQUIRE the api.github.com asset URL +
  # `Accept: application/octet-stream` header. The browser-friendly
  # `/releases/download/<tag>/<name>` URL returns 404 even with an
  # authenticated token for private repos — that's a GitHub quirk.
  #
  # Asset IDs come from:
  #   gh api repos/deskrexai/snorbe-app/releases/tags/v#{version} \
  #     --jq '.assets[] | {name, id}'
  # Update both IDs and both sha256 values when bumping version.

  if Hardware::CPU.arm?
    sha256 "f34b483e30cb7034df9b94201da54c1a342dca301d6db861b20b015a79ddbcb4"
    url "https://api.github.com/repos/deskrexai/snorbe-app/releases/assets/452246117",
        verified: "api.github.com/repos/deskrexai/snorbe-app/",
        header: ["Accept: application/octet-stream"]
  else
    sha256 "7d5c9fdd6e9ebc76891bbc4ed799a7a392ecd98f50039622b81c45d472319357"
    url "https://api.github.com/repos/deskrexai/snorbe-app/releases/assets/452246116",
        verified: "api.github.com/repos/deskrexai/snorbe-app/",
        header: ["Accept: application/octet-stream"]
  end

  name "Snorbe Desktop"
  desc "Bot-free recording app with on-device Whisper transcription and AI summarization"
  homepage "https://app.snorbe.deskrex.ai/"

  # NOTE: snorbe-app is a private GitHub repository. Users must set
  # HOMEBREW_GITHUB_API_TOKEN (or be authenticated via `gh auth login` +
  # `export HOMEBREW_GITHUB_API_TOKEN=$(gh auth token)`) so brew can
  # download the .dmg asset. See homebrew-snorbe README.
  #
  # The .dmg is unsigned (no Apple Developer ID). Homebrew Cask
  # automatically strips the quarantine xattr on install.

  app "Snorbe Desktop.app"

  zap trash: [
    "~/Library/Application Support/snorbe-desktop",
    "~/Library/Preferences/ai.deskrex.snorbe.desktop.plist",
    "~/Library/Saved Application State/ai.deskrex.snorbe.desktop.savedState",
  ]
end
