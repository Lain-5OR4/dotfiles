#!/bin/zsh

dotfiles=(.zshrc .tmux.conf .wezterm.lua .p10k.zsh)
dotdirs=(.zsh .config)
for file in "${dotfiles[@]}"; do
        ln -svf ${HOME}/dotfiles/${file} ${HOME}/${file}
done

create_links(){
    local source_dir="$1"
    local target_dir="$2"

    for item in "$source_dir"/*; do
        local item_name=$(basename "$item")
        local target_path="$target_dir/$item_name"

        if [ -d "$item" ]; then
            if [ ! -e "$target_path" ]; then
                echo "Create directory $target_path 👾"
                mkdir -p "$target_path"
            fi
            create_links "$item" "$target_path"
        elif [ -f "$item" ]; then
            ln -svf "$item" "$target_path"
        fi
    done
}

target_dir="${HOME}"

for dirs in "${dotdirs[@]}"; do
    create_links "${HOME}/dotfiles/$dirs" "$target_dir/$dirs"
done
