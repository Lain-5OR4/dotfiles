# ZSH ABBREVIATIONS CONFIGURATION
# zsh-abbr（olets/zsh-abbr）による展開型ショートカット
# alias と違い、スペース/Enterでコマンドライン上に展開されるため
# 履歴にフルコマンドが残る。git のようにサブコマンドが多いものに向く。

# zsh-abbrは永続化された略語を起動時に自動ロードするため、
# 毎回 abbr で再定義すると「already has an expansion」エラーになる。
# -f/--force で黙って上書きし、-q/--quiet で正常時のログを抑制する。

# GIT ABBREVIATIONS
abbr -f -q g='git'                              # git短縮形
abbr -f -q ga='git add'                         # ファイルをステージング
abbr -f -q ga-all='git add .'                   # 全ての変更をステージング
abbr -f -q gc='git commit'                      # コミット
abbr -f -q gcm='git commit -m'                  # メッセージ付きコミット
abbr -f -q gp='git push'                        # プッシュ
abbr -f -q gs='git status'                      # ステータス確認
abbr -f -q gl='git log --oneline'               # 簡潔なログ表示
abbr -f -q gd='git diff'                        # 差分表示
abbr -f -q gb='git branch'                      # ブランチ表示
abbr -f -q gco='git checkout'                   # ブランチ切り替え
