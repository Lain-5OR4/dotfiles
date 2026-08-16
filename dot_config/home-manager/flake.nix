{
  description = "lain home-manager (packages only; chezmoi owns dotfiles)";

  # neovim-nightly-overlay はソースビルドすると重く、Ubuntu(x86_64-linux)ではGCCの
  # LTOがICEでクラッシュしてビルド不能になることがあった（毎回ではなく再現性のない
  # 一時的な失敗だったが、それでも避けたい）。nix-communityのcachixバイナリキャッシュを
  # 使うことでソースビルド自体を回避する。
  # 適用にはnix側で一度承認プロンプト（extra-substituters/extra-trusted-public-keys、
  # それぞれyesで2回ずつ）が出るのに加え、実行ユーザーがnixのtrusted-usersに
  # 入っていないと結局 "ignoring untrusted substituter" で無視される
  # （Determinate Nixは /etc/nix/nix.conf を自前管理するため、カスタム設定は
  # /etc/nix/nix.custom.conf に書く。docs/INSTALL.md 参照）。
  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { self, nixpkgs, home-manager, neovim-nightly-overlay, ... }:
    let
      # macOSでもUbuntuでも `home-manager switch --flake ~/.config/home-manager --impure`
      # という同一コマンドで通せるように、システムを固定値ではなく実行時に検出する。
      # currentSystem はpure evaluationでは使えないため、呼び出し側で --impure が必須。
      system = builtins.currentSystem;
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations."lain" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit neovim-nightly-overlay system; };
        modules = [ ./home.nix ];
      };
    };
}
