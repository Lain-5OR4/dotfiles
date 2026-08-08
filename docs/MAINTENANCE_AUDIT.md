# dotfiles運用状況の棚卸し（2026-08-08）

このリポジトリの現状を確認し、「最近のdotfiles管理として波に乗れていない」点を洗い出した記録。

## 結論

このリポジトリは実環境の正（source of truth）になっていない。手元の環境が先に変化し、リポジトリはそれを後追いすらできていない状態。

## 具体的な問題

### 1. Claude Code設定が実環境と乖離している（最も明確な証拠）

`settings.json` と `statusline-command.sh` がリポジトリ直下に置かれているが、`deploy.sh` はこの2つを一切シンボリックリンクしていない。実際に比較すると:

```
< "model": "claude-sonnet-5"   (実際の ~/.claude/settings.json, 2026-08-08更新)
> "model": "opus"              (リポジトリ版, 2026-05-09で止まっている)
```

さらに `advisorModel` / `tui` キーはリポジトリ版に存在せず、実環境にだけ追加されている。一度コピーしただけで以後の変更は一切バックポートされていない。deployフローに繋がっていないので当然の帰結。

### 2. 作業ツリーが常に汚れている

`.zshrc` に grok installer のブロック（`export PATH="$HOME/.grok/bin:$PATH"` 以下）が未コミットのまま乗っていた。しかもこのブロックは `compinit -C` を追加で呼んでいるが、`.zshrc` の20行目で既に `compinit`（フルモード）を実行済みのため、無意味な二重初期化になっている。ツールのインストーラーが自動追記した内容を無検証で放置している典型例。

### 3. コミットの間隔と質

```
2026-06-04 update      ← 直近唯一のコミット、2ヶ月以上前
2025-12-16 fix: telescope
2025-09-08 [chore]
2025-09-03 test
```

9月→12月、12月→6月と数ヶ月単位で空いており、その間にgrokやvite-plus、Claude Code設定など複数のツールが環境に入っているのに、リポジトリへの反映は散発的。コミットメッセージも `update` / `test` / `[chore]` のように内容が読み取れないものが増えている。

### 4. deploy.shのカバレッジが実態に追いついていない

`deploy.sh` がリンクするのは `.zshrc .tmux.conf .wezterm.lua .p10k.zsh` と `.zsh/` `.config/` のみ。一方でリポジトリには `.claude/`、`settings.json`、`statusline-command.sh`、`.github/workflows/` が後から追加されているが、デプロイ対象外のまま放置されている。

### 5. 手法自体も今どきのdotfiles管理から取り残されている

- 依存関係の管理がREADMEの手動コピペ手順（`brew install eza` 等の羅列）のままで、Brewfileのような宣言的マニフェスト化がされていない。
- シンボリックリンクを自前の再帰関数（`deploy.sh` 内の `create_links`）で回している。GNU Stow や chezmoi、あるいは最低限の冪等性チェックすらない素朴な実装で、コンフリクト検知や再実行の考慮がない。
- `.zshrc` は `.zsh/config/alias.zsh` のようなモジュール構成を持っているのに、bun・atuin・mise・vite-plus・grokの初期化ブロックはインストーラーが直接 `.zshrc` 本体に追記したものがそのまま残っており、モジュール化の恩恵を受けられていない。
- `.github/workflows/` にClaude連携のワークフローがあるのに、deploy.shの妥当性を検証するCI（シンタックスチェックやshellcheck等）は無い。

### 6. 軽微な散らかり

- `doc/`（画像用）と `docs/`（Markdown用）が用途で分かれているが、名前が紛らわしく統合の余地あり。
- コミットメッセージに `refacter`（refactorのtypo）が複数回登場。

## 採用できていない定番OSS

dotfiles管理そのものが「自前スクリプト + README手順」の時代から、専用ツールを使う方向にシフトして久しいが、このリポジトリはその波に一つも乗れていない。

### chezmoi（本命）
今のdotfiles管理で最も普及しているツール。このリポジトリが抱えている問題の多くを直接解決する。
- テンプレート機能でマシンごとの差分（macOS/Linux、会社/私用など）を1つのソースから出し分けられる。今 `.zshrc` に直書きされているツール別ブロック（bun/atuin/mise/vite-plus/grok）のような「環境依存の追記」を整理しやすい。
- `chezmoi apply` が冪等。`deploy.sh` の自前 `create_links` 再帰関数のような「動くけど再実行の安全性を誰も検証していないシェルスクリプト」を書かなくて済む。
- `age`/`gpg` によるシークレットの暗号化管理が組み込みで、APIキーなどを平文でリポジトリに置かずに済む。
- `chezmoi diff` で「実環境とリポジトリの差分」を明示的に見られる。今回発覚した `settings.json` のドリフト（`opus` vs `claude-sonnet-5`）のような乖離を最初から可視化できる。

### yadm
Gitをそのままラップした管理ツール。学習コストが低く、chezmoiほど大掛かりにしたくない場合の選択肢。ホスト名やOS別の「オルタネートファイル」機能があり、`.zshrc` 内のツール別ブロックの管理にも使える。

### dotbot
YAMLで「何をどこにリンクするか」を宣言するだけの軽量シンボリックリンカー。`deploy.sh` の `create_links` 関数をまるごと置き換えられる、最小の投資で最大の改善が見込める部分。

### Homebrew Bundle（Brewfile）
README に手順として書かれている `brew install eza` などの依存関係を `brew bundle dump` で `Brewfile` として書き出し、`brew bundle install` で一括再現できる。これは前回指摘した「依存関係がREADMEプローズのまま」を最も安く解決できる打ち手。

### Nix / nix-darwin / home-manager（発展形）
dotfilesだけでなくパッケージ・OS設定まで宣言的・再現可能に管理する、より重量級のアプローチ。今すぐ乗り換える必要はないが、「新しいMacに1コマンドで同じ環境を再現する」を本気でやるなら最終的な選択肢になる。

### 参考: プロンプト周り
Powerlevel10k（`.p10k.zsh`）は近年アップデート頻度が落ちており、クロスシェルで書き直し不要な Starship が乗り換え先として定番になりつつある。優先度は低いが選択肢として記載。

## 着手コストの割にリターンが大きい対応

1. ~~`settings.json` / `statusline-command.sh` を `deploy.sh` のリンク対象に入れるか、シンボリックリンク運用に切り替える。~~ → 対応済み（下記）
2. ~~溜まっている `.zshrc` の未コミット差分（grok installerブロック）を整理してコミットする。~~ → 対応済み
3. ~~`deploy.sh` の自前シンボリックリンク処理を dotbot（軽量）か chezmoi（本命・テンプレート/シークレット対応込み）に置き換える。~~ → 対応済み
4. 依存パッケージをBrewfile化し、`brew bundle install` で再現できるようにする。（未着手）

## 対応状況（2026-08-08 chezmoi移行完了）

上記1〜3を chezmoi への段階的移行で解消した。
- `sourceDir` をこのリポジトリ自身に向け（`chezmoi init --source ~/dotfiles`）、`.zshrc`/`.p10k.zsh`/`.tmux.conf`/`.wezterm.lua`/`.zsh/`/`.config/nvim/` を `dot_*` 命名規則にリネームして chezmoi 管理へ移行。`deploy.sh` は空になったため削除。
- ドリフトしていた `settings.json`/`statusline-command.sh` は、リポジトリの古いコピーではなく実環境 `~/.claude/`（2026-08-08時点で最新）を `chezmoi add` で正として取り込み、`dot_claude/` として管理下に置いた。
- リポジトリ直下には README/LICENSE/doc/docs のようなdotfile以外のスキャフォールドファイルが同居しているため、`.chezmoiignore` で除外している（sourceDirをリポジトリ直下に向ける場合の注意点）。
- Mac/Ubuntu両環境を使うことが判明したため、`.zshrc` の atuin/vite-plus ブロックに存在チェックを追加し、未インストール環境でのシェル起動エラーを解消した。マシン別のchezmoiテンプレート化（`.tmpl` + `.chezmoi.os`）は現時点では見送り、必要になったタイミングで追加する。

残っているのは4番のBrewfile化のみ。
