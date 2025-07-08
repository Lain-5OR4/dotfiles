#!/bin/zsh

# ═══════════════════════════════════════════════════════════════════════════════
# DOTFILES DEPLOYMENT SCRIPT
# ═══════════════════════════════════════════════════════════════════════════════
# このスクリプトは dotfiles リポジトリの設定ファイルを
# ホームディレクトリにシンボリックリンクとして配置します

# ═══════════════════════════════════════════════════════════════════════════════
# CONFIGURATION
# ═══════════════════════════════════════════════════════════════════════════════
# 直接ホームディレクトリにリンクするファイル（単一ファイル）
dotfiles=(.zshrc .tmux.conf .wezterm.lua .p10k.zsh)

# ディレクトリ構造を保持してリンクするディレクトリ
dotdirs=(.zsh .config)

# ═══════════════════════════════════════════════════════════════════════════════
# DEPLOY SINGLE FILES
# ═══════════════════════════════════════════════════════════════════════════════
# 単一ファイルのシンボリックリンクを作成
echo "📁 Deploying single dotfiles..."
for file in "${dotfiles[@]}"; do
    echo "🔗 Linking: ${file}"
    ln -svf ${HOME}/dotfiles/${file} ${HOME}/${file}
done

# ═══════════════════════════════════════════════════════════════════════════════
# RECURSIVE LINK CREATION FUNCTION
# ═══════════════════════════════════════════════════════════════════════════════
# ディレクトリ構造を再帰的に処理してシンボリックリンクを作成する関数
create_links(){
    local source_dir="$1"    # ソースディレクトリ（dotfiles内）
    local target_dir="$2"    # ターゲットディレクトリ（ホーム内）

    # ソースディレクトリ内の全アイテムを処理
    for item in "$source_dir"/*; do
        local item_name=$(basename "$item")          # アイテム名を取得
        local target_path="$target_dir/$item_name"   # ターゲットパスを構築

        # ディレクトリの場合
        if [ -d "$item" ]; then
            # ターゲットディレクトリが存在しない場合は作成
            if [ ! -e "$target_path" ]; then
                echo "📁 Create directory $target_path 👾"
                mkdir -p "$target_path"
            fi
            # 再帰的に処理
            create_links "$item" "$target_path"
        
        # ファイルの場合
        elif [ -f "$item" ]; then
            echo "🔗 Linking: $item_name"
            ln -svf "$item" "$target_path"
        fi
    done
}

# ═══════════════════════════════════════════════════════════════════════════════
# DEPLOY DIRECTORY STRUCTURES
# ═══════════════════════════════════════════════════════════════════════════════
# ターゲットディレクトリの設定
target_dir="${HOME}"

# ディレクトリ構造を保持してリンクを作成
echo "📁 Deploying directory structures..."
for dirs in "${dotdirs[@]}"; do
    echo "🔄 Processing directory: ${dirs}"
    create_links "${HOME}/dotfiles/$dirs" "$target_dir/$dirs"
done

echo "✅ Deployment completed!"
