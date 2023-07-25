#!/bin/zsh

# ディレクトリ直下にあるディレクトリとファイルを取得する関数
get_directories_and_files() {
    local target_dir="$1"

    # ディレクトリが存在しない場合はエラーメッセージを表示して終了
    if [ ! -d "$target_dir" ]; then
        echo "Error: $target_dir が存在しません。"
        exit 1
    fi

    # ディレクトリとファイルを格納する配列を初期化
    directories=()
    files=()

    # ディレクトリ直下のエントリを取得して配列に格納
    for entry in "$target_dir"/*; do
        if [ -d "$entry" ]; then
            directories+=("$entry") # ディレクトリをdirectories配列に追加
        elif [ -f "$entry" ]; then
            files+=("$entry")       # ファイルをfiles配列に追加
        fi
    done
}

# ディレクトリ直下のディレクトリとファイルを取得して配列に格納
get_directories_and_files ".git"

# ディレクトリを表示
echo "ディレクトリ:"
for dir in "${directories[@]}"; do
    echo "$dir"
done

# ファイルを表示
echo "ファイル:"
for file in "${files[@]}"; do
    echo "$file"
done
