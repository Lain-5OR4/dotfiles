{ pkgs, neovim-nightly-overlay, system, ... }:
{
  home.username = "lain";
  # macOSは /Users/<user>、Linux(Ubuntu)は /home/<user> とホームの位置が違うため出し分ける。
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/lain" else "/home/lain";
  home.stateVersion = "26.05";

  # CLI 本体のみ管理する。dotfiles/設定ファイルは引き続き chezmoi が所有するため
  # programs.* モジュール（設定ファイルを生成するもの）は使わない。
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    jq
    ripgrep
    eza
    fastfetch
    wget
    curl

    bat
    fzf
    gh
    tmux
    watchman

    git
    neovim-nightly-overlay.packages.${system}.default

    pkgconf

    # nixpkgs の onetrueawk はバイナリ名が `nawk` なので、
    # 今まで通り `awk` で呼べるように bin/awk としてラップする。
    (runCommand "awk" { } ''
      mkdir -p $out/bin
      ln -s ${nawk}/bin/nawk $out/bin/awk
    '')

    deno
    python312
    nodejs_26
    go
    zig
  ];
}
