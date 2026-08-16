{
  description = "lain home-manager (packages only; chezmoi owns dotfiles)";

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
