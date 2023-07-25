#!/bin/zsh
dotfiles=(.zshrc .tmux.conf .wezterm.lua .p10k.zsh)
dotfile_dir=(.zsh .config)
for file in "${dotfiles[@]}"; do
        ln -svf ~/dotfiles/${file} ~/${file}
done

# Font install
target_font_dir=~/.local/share/fonts
source_dir=~/dotfiles/.fonts
create_font_symlinks() {
    for file in "$source_dir"/*.ttf; do
        filename=$(basename "$file")
        symlink_path="$target_font_dir/$filename"
        if [ -e "$symlink_path" ]; then
            echo "symlink $symlink_path is already exists"
            continue
        fi
        # create symlink
        ln -svf "$file" "$symlink_path"
    done
}

if [ ! -d "$target_font_dir" ]; then
    mkdir -p "$target_font_dir"
fi

# create_font_symlinks

get_dirs_and_files(){
    local target_dir = "$1"
    if [ ! -d "$target_dir" ]; then
        echo "Create dir $target_dir 🐧"
        mkdir -p "$target_dir"
    fi

    dirs=()
    files=()

    for entry in "$target_dir"/*; do
        if [ -d "$entry" ]; then
            dirs+=("$entry")
        elif [ -f "$entry" ]; then
            files+=("$entry")
        fi

    for f in "${files[@]}"; do
        ln -svf ~/dotfiles/${f} ~/${f}
    done
}

get_subdirectories(){
    if [ ! -d "$1" ]; then
        echo "No such dirs-- $1 "
        exit 1
    fi

    subdirs=()
    while IFS= read -r -d '' subdir; do
        subdirs+=("$subdir")
    done < < (find "$1" -mindepth 1 -maxdepth 1 -type d -print0)
    
    if [ ${#subdirs[@]} -eq 0 ]; then
        echo "No subdirs in $1 "
        exit 0
    fi

    for subdir in "${subdirs[@]}"; do
        echo "$subdir"
    done
}

