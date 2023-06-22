#!/bin/bash
# 配置したい設定ファイル
dotfiles=(.zshrc .tmux.conf)

# .zshrc と .tmux.conf という設定ファイルのシンボリックリンクを
# ホームディレクトリ直下に作成する
for file in "${dotfiles[@]}"; do
        ln -svf ~/dotfiles/${file} ~/${file}
done











# Font install
# シンボリックリンクを作成するフォントディレクトリのパス
target_font_dir=~/.local/share/fonts

# シンボリックリンクを作成するフォントファイルのディレクトリのパス
source_dir=.fonts

# シンボリックリンクを作成する関数
create_font_symlinks() {
    for file in "$source_dir"/*.ttf; do
        # ファイル名のみを抽出
        filename=$(basename "$file")
        
        # シンボリックリンクのパスを組み立てる
        symlink_path="$target_font_dir/$filename"
        
        # シンボリックリンクが既に存在する場合はスキップ
        if [ -e "$symlink_path" ]; then
            echo "symlink $symlink_path is already exists"
            continue
        fi
        
        # create symlink
        ln -s "$file" "$symlink_path"
        echo "symlink $symlink_path is created"
    done
}

# フォントディレクトリが存在しない場合は作成
if [ ! -d "$target_font_dir" ]; then
    mkdir -p "$target_font_dir"
fi

# シンボリックリンクの作成
create_font_symlinks
