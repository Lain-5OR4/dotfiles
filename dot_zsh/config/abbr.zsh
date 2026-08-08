# ZSH ABBREVIATIONS CONFIGURATION
# zsh-abbr（olets/zsh-abbr）による展開型ショートカット
# alias と違い、スペース/Enterでコマンドライン上に展開されるため
# 履歴にフルコマンドが残る。git のようにサブコマンドが多いものに向く。

# GIT ABBREVIATIONS
abbr g='git'                              # git短縮形
abbr ga='git add'                         # ファイルをステージング
abbr ga-all='git add .'                   # 全ての変更をステージング
abbr gc='git commit'                      # コミット
abbr gcm='git commit -m'                  # メッセージ付きコミット
abbr gp='git push'                        # プッシュ
abbr gs='git status'                      # ステータス確認
abbr gl='git log --oneline'               # 簡潔なログ表示
abbr gd='git diff'                        # 差分表示
abbr gb='git branch'                      # ブランチ表示
abbr gco='git checkout'                   # ブランチ切り替え
