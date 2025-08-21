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

      pkgs-stable = import nixpkgs-stable {
        system = "aarch64-darwin";
      };

      base =
        { pkgs, ... }:
        {
          environment.systemPackages = with pkgs; [
            btop
            git
            neovim
            pwgen
            restic
            tmux
            wgetpaste
            zellij
          ];

          nix.settings.experimental-features = "nix-command flakes";
        };

      cli =
        { pkgs, ... }:
        {
          environment.systemPackages = with pkgs; [
            # 7zip
            bat
            bc
            cpulimit
            duf
            eza
            fastfetch
            fd
            fzf
            git-lfs
            glow
            gnupg
            htop
            lazygit
            ncdu
            nix-tree
            nvtopPackages.full
            pastel
            ripgrep
            speedtest-cli
            starship
            stow
            tealdeer
            tree
            yazi
            yt-dlp
            zoxide
          ];
        };

      development =
        { pkgs, ... }:
        {
          environment.systemPackages = with pkgs; [
            bash-language-server
            clang
            clang-tools
            gcc
            gdb
            ghidra
            lua-language-server
            nixd
            nixfmt-rfc-style
            pyright
            rustup
            shellcheck
            shfmt
            stylua
            tombi
          ];
        };

      desktop =
        { pkgs, pkgs-stable, ... }:
        {
          environment.systemPackages =
            with pkgs;
            # A complete disregard to the hard work the Nix developers have spent making their system reproducable
            (builtins.map
              (
                pkg:
                let
                  name = lib.toLower (pkg.pname);
                in
                (
                  if !(pkg.meta.broken) then
                    pkgs.${name}
                  else
                    builtins.trace "${name} is marked as broken, trying stable" pkgs-stable.${name}
                )
              )
              [
                blender
                qbittorrent
                syncthing
                vesktop
              ]
            );

          fonts.packages = [
            pkgs.nerd-fonts.jetbrains-mono
          ];

          programs = {
            zsh = {
              enable = true;
              enableAutosuggestions = true;
              enableSyntaxHighlighting = true;
            };
          };
        };

      linux-shell =
        { pkgs, ... }:
        {
          environment.systemPackages = with pkgs; [
            apple-cursor
            fuzzel
            niri
            quickshell
            swww
            wl-clipboard
            xwayland-satellite
          ];

          fonts.packages = with pkgs; [
            noto-fonts-cjk-sans
          ];

        };

      linux-desktop =
        { pkgs, ... }:
        {
          environment.systemPackages = with pkgs; [
            #"steam"
            #"zen"
            aseprite
            audacity
            baobab
            beets
            blanket
            boxbuddy
            chromium
            cpu-x
            darktable
            freecad
            fwupd
            ghostty
            gimp3
            godot
            gpu-viewer
            halloy
            handbrake
            hwinfo
            inkscape
            kicad
            krita
            libreoffice-fresh
            mission-center
            newelle
            obs-studio
            onlyoffice-desktopeditors
            parabolic
            pavucontrol
            playerctl
            qalculate-gtk
            qpwgraph
            renderdoc
            tailscale
            thunderbird
            tor-browser
            upscaler
            usbutils
            video-trimmer
            vlc
          ];
          services.flatpak.enable = true;
          # Flatpaks: bottles flatseal sober
        };

      goxlr =
        { pkgs, ... }:
        {
          environment.systemPackages = with pkgs; [
            goxlr-utility
          ];
          services.goxlr-utility.enable = true;
        };

      macOS =
        { pkgs, ... }:
        {
          environment.systemPackages = with pkgs; [
            mas
          ];

          homebrew = {
            enable = true;
            brews = [
              #"syncthing"
            ];
            casks = [
              "ghostty"
              "maccy"
              "obs"
              "spotify"
              "raspberry-pi-imager"
              "zen"
              #"blender"
              #"vesktop"
            ];
            taps = [
            ];
            masApps = {
              "Bitwarden" = 1352778147;
              "tailscale" = 1475387142;
              "xcode" = 497799835;
            };
            onActivation.autoUpdate = true;
            onActivation.cleanup = "zap";
            onActivation.upgrade = true;
          };

          services.aerospace.enable = true;

          security.pam.services.sudo_local.touchIdAuth = true;

          system = {
            stateVersion = 6;
            primaryUser = "pieter";
            defaults = {
              controlcenter = {
                AirDrop = false;
                BatteryShowPercentage = true;
                Bluetooth = false;
                Display = false;
                FocusModes = false;
                NowPlaying = true;
                Sound = false;
              };
              dock.show-recents = false;
              dock.autohide = true;
              finder = {
                AppleShowAllExtensions = true;
                AppleShowAllFiles = true;
                ShowPathbar = true;
                ShowStatusBar = true;
                _FXSortFoldersFirst = true;
              };
              NSGlobalDomain.NSWindowShouldDragOnGesture = true;
            };
          };
        };

      macOS-personal =
        { pkgs, ... }:
        {
          environment.systemPackages = with pkgs; [
          ];
          homebrew = {
            enable = true;
            brews = [
              #"syncthing"
            ];
            casks = [
              "moonlight"
              "steam"
              "wine-stable"
              #"blender"
              #"vesktop"
            ];
            masApps = {
              "Apple developer" = 640199958;
            };
            onActivation.autoUpdate = true;
            onActivation.cleanup = "zap";
            onActivation.upgrade = true;
          };
        };

      games =
        { pkgs, ... }:
        {
          environment.systemPackages = with pkgs; [
            prismlauncher
            ryubing
          ];
        };

      linux-games =
        { pkgs, ... }:
        {
          environment.systemPackages = with pkgs; [
            dolphin-emu
            gamemode
            heroic
            luanti
            openttd
            pcsx2
            ppsspp
            retroarch
            rpcs3
            sunshine
            superTux
            superTuxKart
          ];
        };

      fun =
        { pkgs, ... }:
        {
          environment.systemPackages = with pkgs; [
            asciiquarium
            astroterm
            cbonsai
            cmatrix
            cowsay
            figlet
            fortune
            krabby
            lolcat
            nyancat
            sl
          ];
        };

      resolve =
        { pkgs, ... }:
        {
          environment.systemPackages = with pkgs; [
            davinci-resolve-studio
          ];
        };

    in
    {

      darwinConfigurations."Pieters-MacBook-Air" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {
          inherit pkgs-stable;
        };
        modules = [
          base
          cli
          development
          desktop
          macOS
          macOS-personal
          games
          fun
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
          inherit pkgs-stable;
        };
        modules = [
          base
          cli
          development
          desktop
          macOS
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
