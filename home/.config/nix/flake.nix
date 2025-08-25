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
          name:
          let
            pkg = prev.${name};
          in
          if pkg ? meta && pkg.meta.broken or false then
            builtins.trace "${name} is marked as broken, trying stable" stable.${name}
          else
            pkg
        );

      mkPkgs =
        system:
        import nixpkgs {
          inherit system;
          overlays = [ nixpkgsStableOverlay ];
        };

      base =
        { pkgs, ... }:
        {
          environment.systemPackages = with pkgs; [
            bc
            btop
            fzf
            git
            gnupg
            neovim
            pwgen
            restic
            ripgrep
            stow
            tealdeer
            tmux
            wgetpaste
            zellij
          ];

          nix.settings.experimental-features = "nix-command flakes";
        };

      cli =
        { pkgs, ... }:
        {
          environment.systemPackages =
            with pkgs;
            [
              # 7zip
              bat
              cpulimit
              duf
              eza
              fastfetch
              fd
              git-lfs
              glow
              htop
              lazygit
              ncdu
              nix-tree
              nvtopPackages.full
              pastel
              speedtest-cli
              starship
              tree
              yazi
              yt-dlp
              zoxide
            ]
            ++ (lib.optionals (pkgs.system == "x86_64-linux") [
              beets
              fwupd
              hwinfo
              playerctl
              tailscale
              usbutils
            ]);
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
            nix-output-monitor
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
        { pkgs, ... }:
        {
          environment.systemPackages =
            with pkgs;
            [
              audacity
              blender
              darktable
              qbittorrent
              syncthing
              vesktop
            ]
            ++ (lib.optionals (pkgs.system == "x86_64-linux") [
              aseprite
              baobao
              blanket
              boxbuddy
              chromium
              cpu-x
              freecad
              ghostty
              ghostty
              gimp3
              godot
              gpu-viewer
              halloy
              handbrake
              inkscape
              kicad
              kiwix
              krita
              libreoffice-fresh
              mission-center
              newelle
              obs-studio
              onlyoffice-desktopeditors
              parabolic
              pavucontrol
              qalculate-gtk
              qpwgraph
              renderdoc
              thunderbird
              tor-browser
              upscaler
              video-trimmer
              vlc
            ]);

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
            ];
            casks = [
              "moonlight"
              "steam"
              "wine-stable"
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
          environment.systemPackages =
            with pkgs;
            [
              prismlauncher
              ryubing
            ]
            ++ (lib.optionals (pkgs.system == "x86_64-linux") [
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
            ]);
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
          pkgs = mkPkgs "aarch64-darwin";
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
          pkgs = mkPkgs "aarch64-darwin";
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
