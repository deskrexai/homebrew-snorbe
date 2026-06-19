# homebrew-snorbe

Private Homebrew Cask tap for DeskRex AI macOS apps.

## Install

```bash
# 1. (one-time) authenticate to GitHub so brew can download from private repos
gh auth login                    # or: export HOMEBREW_GITHUB_API_TOKEN=ghp_xxx

# 2. tap this repo
brew tap deskrexai/snorbe

# 3. install
brew install --cask snorbe-desktop
```

## What's included

| Cask | Description |
|---|---|
| `snorbe-desktop` | Snorbe Electron desktop app (録音 → on-device Whisper → 要約 → メール送信) |

## After install

1. Open Snorbe Desktop from `/Applications/`
2. Paste your API key (issued at https://app.snorbe.deskrex.ai/[locale]/ws/<wsId>/dashboard/api-keys)
3. Paste your Workspace ID (the `cm...` portion of the workspace URL)
4. First launch will download the Whisper model (~141 MB)
5. Start Recording → Stop → 完了後にメールが届く

## Uninstall

```bash
brew uninstall --cask snorbe-desktop
# To also remove ~/Library/Application Support data:
brew uninstall --cask --zap snorbe-desktop
```

## Updating to a new version

```bash
brew update
brew upgrade --cask snorbe-desktop
```

## Notes

- The .dmg is **unsigned** (Apple Developer ID is not yet acquired). Homebrew
  Cask handles the quarantine xattr automatically on install, so the
  "unidentified developer" / "破損しています" error you'd see with a direct
  .dmg download does not appear.
- Auto-update is not yet wired up. New versions require `brew upgrade`.
