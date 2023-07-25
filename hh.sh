#!/bin/zsh
dotfile_dir=(.zsh .config)

get_dirs_and_files() {
    echo "$1"
    # local target_dir = "$1"
    if [ ! -d "$HOME/test/${1}" ]; then
        echo "Create dir $1"
        mkdir -p "$HOME/test/${1}"
    fi

    dirs=()
    files=()

    for entry in "$1"/*; do
        if [ -d "$entry" ]; then
            dirs+=("$entry")
        elif [ -f "$entry" ]; then
            files+=("$entry")
        fi
    done

    for f in "${files[@]}"; do
        ln -svf ~/dotfiles/${f} ~/test/${f}
    done
}

for i in "${dotfile_dir[@]}"; do
	echo "$i"
	get_dirs_and_files "$i"
done