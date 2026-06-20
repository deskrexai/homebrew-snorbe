# homebrew-snorbe

Private Homebrew Cask tap for DeskRex AI macOS apps.

## What's included

| Cask | Description |
|---|---|
| `snorbe-desktop` | Snorbe Electron desktop app (録音 → on-device Whisper → 要約 → メール送信) |

---

## Install (full walk-through)

### Step 0. GitHub 認証 (一度きり)

このリポジトリ (`deskrexai/homebrew-snorbe`) と配信先 (`deskrexai/snorbe-app`) は
どちらも **private**。Homebrew が clone / download するために GitHub 認証が必要。

```bash
gh auth login    # 既にログイン済ならスキップ
```

すでに `gh` で auth 済みでも、`repo` scope が無いと private リポへの
access に失敗する。scope を確認:

```bash
gh auth status   # Token scopes: 行を見て repo があるか確認
```

`repo` scope が無ければ追加:

```bash
gh auth refresh -h github.com -s repo
```

`gh` を使わず PAT を直接設定したい場合は:

```bash
# ~/.zshrc に追加
export HOMEBREW_GITHUB_API_TOKEN=ghp_xxxxxxxxxxxx
```

### Step 1. tap を追加

```bash
brew tap deskrexai/snorbe
```

成功すれば `Tapped 1 cask` と出る。エラー時の対処は[トラブルシューティング](#トラブルシューティング)参照。

### Step 2. tap を信頼する (新しい Homebrew で必須)

Homebrew 4.x 系から、third-party tap の Cask は明示的に trust しないと
install できない (Cask は任意コードを実行できるため、誤って悪意ある
tap を install する事故防止)。

```bash
brew trust deskrexai/snorbe
```

これは一度きり。以降この tap に Cask が増えても再 trust 不要。

### Step 3. install

```bash
brew install --cask snorbe-desktop
```

Homebrew Cask が以下を自動でやってくれる:
1. `https://github.com/deskrexai/snorbe-app/releases/download/v0.1.0/Snorbe-Desktop-0.1.0-arm64.dmg` (or x64) を download
2. SHA256 検証
3. `.dmg` をマウント → `Snorbe Desktop.app` を `/Applications/` にコピー
4. **quarantine xattr 自動削除** (これが Cask の真の旨み、`.dmg` 直 download だと自分で `xattr -dr` する必要)
5. `.dmg` をアンマウント

### Step 4. 起動

```bash
open "/Applications/Snorbe Desktop.app"
```

または Spotlight (⌘Space) → "Snorbe Desktop"。

---

## 初回セットアップ

1. **API Key** 入力
   - `https://app.snorbe.deskrex.ai/[locale]/ws/<wsId>/dashboard/api-keys` で発行
   - `snorbe_...` で始まる文字列を貼り付け (Electron 内 `safeStorage` で暗号化保存)
2. **Workspace ID** 入力
   - workspace URL の `cm...` 部分 (例: `cmpqne1tn0007wydemwgv89hh`)
   - in-memory なので App 再起動で消える (Phase 2 で永続化予定)
3. **Whisper モデル** 自動 DL
   - 初回のみ ~141 MB を Hugging Face から download
   - `~/Library/Application Support/snorbe-desktop/models/ggml-base.bin`
4. **Start Recording** → 数秒〜数分話す → **Stop & Upload**
   - 進捗 phase: uploading → transcribing → submitting-transcript → summarizing → done
5. メール受信確認 (`User.email` 宛 + BCC `snorbe.ai@gmail.com`)
6. Web ダッシュボード (`/dashboard/sources?type=audio`) で
   - **body**: whisper の書き起こし
   - **description**: snorbe-medium LLM による要約 + next actions

---

## Uninstall

```bash
# App + cask 情報を削除
brew uninstall --cask snorbe-desktop

# 加えて ~/Library/Application Support/snorbe-desktop/ の状態 (model + api-key.enc) も消す
brew uninstall --cask --zap snorbe-desktop
```

---

## Updating

新しいバージョン (例: v0.2.0) がリリースされたら:

```bash
brew update                                  # tap の Cask Formula 更新を pull
brew upgrade --cask snorbe-desktop           # .dmg 再 download → 入れ替え
```

auto-update は未実装 (Phase 2)。新リリースは [Releases ページ](https://github.com/deskrexai/snorbe-app/releases) を watch。

---

## トラブルシューティング

| エラー | 原因 | 対処 |
|---|---|---|
| `Cask 'snorbe-desktop' is unavailable: No Cask with this name exists` | `brew tap` をやってない | `brew tap deskrexai/snorbe` を先に実行 |
| `Refusing to load cask ... from untrusted tap` | tap を trust してない (新 Homebrew) | `brew trust deskrexai/snorbe` |
| `Permission denied (publickey)` on `brew tap` | GitHub SSH key 未設定 | `gh auth login` をやり直す or `~/.ssh/id_*` を GitHub に登録 |
| `repository ... not found` on `brew tap` | gh の `repo` scope が無い | `gh auth refresh -h github.com -s repo` |
| `brew install` で 401 / 403 | HOMEBREW_GITHUB_API_TOKEN 未設定 | `export HOMEBREW_GITHUB_API_TOKEN=$(gh auth token)` を `~/.zshrc` に追加して再起動 |
| 起動時「壊れています」or「unidentified developer」 | `brew install --cask` 以外で install (例: 直接 .dmg ダブルクリック) | `xattr -dr com.apple.quarantine "/Applications/Snorbe Desktop.app"` を実行、または **Cask 経由で再 install** (こちらが安全) |
| マイク許可ダイアログが出ない | macOS TCC 状態がおかしい | `tccutil reset Microphone ai.deskrex.snorbe.desktop` を実行して App 再起動 |

---

## Notes

- **`.dmg` は unsigned** (Apple Developer ID $99/year を未取得)。Homebrew Cask が
  quarantine xattr を自動削除するため install には支障なし。直接 .dmg を
  download した場合は手動で `xattr -dr com.apple.quarantine` が必要。
- **arm64 / x64 自動判定** (`Hardware::CPU.arm?`)。Apple Silicon Mac → arm64 .dmg、
  Intel Mac → x64 .dmg を download。
- **配信元 (snorbe-app private repo) は private**。tap repo (homebrew-snorbe) も private。
  社内利用のみで、外部公開する場合は別途検討。
- **auto-update 未実装**。新リリース時は `brew upgrade` を手動で。Phase 2 で
  electron-updater + GitHub Release を組み合わせて auto-update 化予定。

---

## 配布 pipeline の全体像

```
[Itaru の Mac]
   pnpm --filter snorbe-desktop dist
   ↓
[apps/desktop/release/]
   Snorbe-Desktop-0.1.0-arm64.dmg (104 MB)
   Snorbe-Desktop-0.1.0-x64.dmg   (108 MB)
   ↓ shasum -a 256 で SHA256 取得
   ↓ gh release create v0.1.0 ... で snorbe-app private repo に upload
[github.com/deskrexai/snorbe-app/releases/tag/v0.1.0]
   ↑
[github.com/deskrexai/homebrew-snorbe] ← Cask Formula が指す
   Casks/snorbe-desktop.rb (sha256 + url 指定)
   ↑
[ユーザーの Mac]
   gh auth login → repo scope 確認 → brew tap → brew trust → brew install --cask
   /Applications/Snorbe Desktop.app  ← quarantine 自動削除済
```

新バージョンリリース時の手順:
1. `apps/desktop/package.json` の version bump (例: 0.1.0 → 0.2.0)
2. `pnpm --filter snorbe-desktop dist` で新 .dmg 生成
3. `shasum -a 256` で新 SHA256 計算
4. `gh release create v0.2.0 ...` で新 Release + .dmg upload
5. このリポの `Casks/snorbe-desktop.rb` の `version` と 2 つの `sha256` を更新
6. commit + push (Itaru 自身) → ユーザー側は `brew upgrade --cask snorbe-desktop`
