cask "snorbe-desktop" do
  version "0.1.1"

  # NOTE: Private GitHub Releases REQUIRE:
  #   1. api.github.com asset URL (the `/releases/download/...` browser URL
  #      returns 404 even with token for private repos — GitHub quirk)
  #   2. Accept: application/octet-stream header
  #   3. Authorization: Bearer <token> header  ← Homebrew does NOT add this
  #      automatically; HOMEBREW_GITHUB_API_TOKEN is only used for
  #      `brew tap` git operations and API metadata calls, NOT for the
  #      cask download curl.
  #
  # Users MUST `export HOMEBREW_GITHUB_API_TOKEN=$(gh auth token)` in their
  # shell BEFORE running `brew install --cask snorbe-desktop`.
  #
  # Asset IDs come from:
  #   gh api repos/deskrexai/snorbe-app/releases/tags/v#{version} \
  #     --jq '.assets[] | {name, id}'
  # Update both IDs and both sha256 values when bumping version.

  if Hardware::CPU.arm?
    sha256 "bda13aaa7254e8921869f759450dbe514c4a36307299d649e06d6577442fc321"
    url "https://api.github.com/repos/deskrexai/snorbe-app/releases/assets/452662195",
        verified: "api.github.com/repos/deskrexai/snorbe-app/",
        header: [
          "Accept: application/octet-stream",
          "Authorization: Bearer #{ENV.fetch('HOMEBREW_GITHUB_API_TOKEN', '')}",
        ]
  else
    sha256 "b40c58603a1fa48058a9c1260291de3d76680d3cb7a60d43d7b1c31db23e0184"
    url "https://api.github.com/repos/deskrexai/snorbe-app/releases/assets/452662196",
        verified: "api.github.com/repos/deskrexai/snorbe-app/",
        header: [
          "Accept: application/octet-stream",
          "Authorization: Bearer #{ENV.fetch('HOMEBREW_GITHUB_API_TOKEN', '')}",
        ]
  end

  name "Snorbe Desktop"
  desc "Bot-free recording app with on-device Whisper transcription and AI summarization"
  homepage "https://app.snorbe.deskrex.ai/"

  # The .dmg is unsigned (no Apple Developer ID). Homebrew Cask
  # automatically strips the quarantine xattr on install — no manual
  # `xattr -dr` needed.

  app "Snorbe Desktop.app"

  zap trash: [
    "~/Library/Application Support/snorbe-desktop",
    "~/Library/Preferences/ai.deskrex.snorbe.desktop.plist",
    "~/Library/Saved Application State/ai.deskrex.snorbe.desktop.savedState",
  ]
end
