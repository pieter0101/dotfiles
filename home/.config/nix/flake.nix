{
  description = "Pieter's nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/release-25.05";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = {
    nixpkgs,
    nixpkgs-stable,
    nix-darwin,
    nix-homebrew,
    ...
  }: let
    system = "aarch64-darwin";

    nixpkgsStableOverlay = _: prev:
      nixpkgs.lib.genAttrs (builtins.attrNames prev) (
        pkgName: let
          unstablePkg = prev.${pkgName};
          stablePkg = import nixpkgs-stable { inherit (prev.stdenv) system; };
        in
          if unstablePkg == null then
            if stablePkg == null then
              throw "Error: ${pkgName} does not exist in unstable or stable"
            else
              if stablePkg.meta.broken or false then
                builtins.trace "Warning: ${pkgName} is broken in unstable and stable" stablePkg
              else
                builtins.trace "Using stable version of ${pkgName}" stablePkg
          else
            if unstablePkg.meta.broken or false then
              builtins.trace "Warning: ${pkgName} is broken" unstablePkg
            else
              unstablePkg
      );

    mkPkgs = system:
      import nixpkgs {
        inherit system;
        overlays = [nixpkgsStableOverlay];
      };
  in {
    darwinConfigurations = {
      Pieters-MacBook-Air = nix-darwin.lib.darwinSystem {
        inherit system;

        specialArgs = {
          pkgs = mkPkgs system;
        };

        modules = [
          ./modules/base.nix
          ./modules/cli.nix
          ./modules/development.nix
          ./modules/desktop.nix
          ./modules/macOS.nix
          ./modules/macOS-personal.nix
          ./modules/games.nix
          ./modules/fun.nix

          nix-homebrew.darwinModules.nix-homebrew

          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = "pieter";
            };
          }
        ];
      };

      Pieters-WerkBook = nix-darwin.lib.darwinSystem {
        inherit system;

        specialArgs = {
          pkgs = mkPkgs system;
        };

        modules = [
          ./modules/base.nix
          ./modules/cli.nix
          ./modules/development.nix
          ./modules/desktop.nix
          ./modules/macOS.nix

          nix-homebrew.darwinModules.nix-homebrew

          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = "pieter";
            };
          }
        ];
      };
    };
  };
}
