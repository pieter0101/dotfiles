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

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nixpkgs-stable,
      nix-homebrew,
    }:
    let

      pkgs-stable =
        {
          system,
        }:
        import nixpkgs-stable { inherit system; };

      nixpkgsStableOverlay =
        final: prev:
        let
          stable = pkgs-stable { system = prev.stdenv.system; };
        in
        nixpkgs.lib.genAttrs (builtins.attrNames prev) (
          pkgName:
          let
            unstablePkg = prev.${pkgName} or null;
            stablePkg = stable.${pkgName} or null;
            isBroken = (unstablePkg.meta.broken or false);
          in
          if !isBroken then
            unstablePkg
          else if  !(stablePkg.meta.broken or false) then
            builtins.trace "Using stable version of ${pkgName}, unstable is ${if isBroken then "broken" else "missing"}" stablePkg
          else if unstablePkg != null then
            builtins.trace "Warning: ${pkgName} is broken and no stable version available" unstablePkg
          else
            throw "Package ${pkgName} not found in either unstable or stable"
        );

      mkPkgs =
        system:
        import nixpkgs {
          inherit system;
          overlays = [ nixpkgsStableOverlay ];
        };

    in
    {

      darwinConfigurations."Pieters-MacBook-Air" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {
          pkgs = mkPkgs "aarch64-darwin";
        };
        modules = [
          {
            imports = [
              ./modules/base.nix
              ./modules/cli.nix
              ./modules/development.nix
              ./modules/desktop.nix
              ./modules/macOS.nix
              ./modules/games.nix
              ./modules/fun.nix
            ];
          }
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

      darwinConfigurations."Pieters-WerkBook" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {
          pkgs = mkPkgs "aarch64-darwin";
        };
        modules = [
          {
            imports = [
              ./modules/base.nix
              ./modules/cli.nix
              ./modules/development.nix
              ./modules/desktop.nix
              ./modules/macOS.nix
            ];
          }
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
}
