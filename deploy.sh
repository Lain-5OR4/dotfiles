#!/bin/bash
dotfiles=(.zshrc .tmux.conf .wezterm.lua .p10k.zsh .zsh)

for file in "${dotfiles[@]}"; do
        ln -svf ~/dotfiles/${file} ~/${file}
done

# deploy nvim folder
ln -svf ~/dotfiles/.config/nvim ~/.config/nvim


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

create_font_symlinks

