#!/bin/zsh

# ディレクトリのパス
nvim_dir=./rustpra
subdirs=()
subdirs2=()
# サブディレクトリ（ディレクトリ名）を取得する関数
get_subdirectories() {
    # nvimディレクトリが存在しない場合はエラーメッセージを表示して終了
    if [ ! -d "$nvim_dir" ]; then
        echo "Error: $nvim_dir が存在しません。"
        exit 1
    fi

    # サブディレクトリ（ディレクトリ名）を取得して表示
    while IFS= read -r -d '' subdir; do
        subdirs+=("$subdir")
    done < <(find "$nvim_dir" -mindepth 1 -maxdepth 1 -type d -print0)

    # サブディレクトリ（ディレクトリ名）の数が0の場合はメッセージを表示して終了
    if [ ${#subdirs[@]} -eq 0 ]; then
        echo "nvimディレクトリ内にサブディレクトリが存在しません。"
        exit 0
    fi

    # サブディレクトリ（ディレクトリ名）を表示
    echo "nvimディレクトリ内に存在するサブディレクトリ:"
    for subdir in "${subdirs[@]}"; do
        echo "$subdir"
    done
}

get_subdirectories2() {
    # nvimディレクトリが存在しない場合はエラーメッセージを表示して終了
    if [ ! -d "$1" ]; then
        echo "Error: $1 が存在しません。"
        exit 1
    fi

    # サブディレクトリ（ディレクトリ名）を取得して表示
    while IFS= read -r -d '' subdir; do
        subdirs2+=("$subdir")
    done < <(find "$1" -mindepth 1 -maxdepth 1 -type d -print0)

    if [ ${#subdirs2[@]} -eq 0 ]; then
        echo "naiディレクトリ内にサブディレクトリが存在しません。"
    fi

    # サブディレクトリ（ディレクトリ名）を表示
    echo "naiディレクトリ内に存在するサブディレクトリ:"
    for subdir in "${subdirs2[@]}"; do
        echo "$subdir"
    done
}
# サブディレクトリ（ディレクトリ名）を取得して表示
get_subdirectories

for subdir in "${subdirs[@]}"; do
        echo "精査- $subdir"
        get_subdirectories2 "$subdir"
    done
