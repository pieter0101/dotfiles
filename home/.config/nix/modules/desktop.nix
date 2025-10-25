{ pkgs, ... }:
{
  environment.systemPackages =
    with pkgs;
    [
    ]
    ++ (lib.optionals (pkgs.system == "x86_64-linux") [
      aseprite
      audacity
      baobab
      blanket
      blender
      boxbuddy
      chromium
      cpu-x
      darktable
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
      obs-studio
      onlyoffice-desktopeditors
      parabolic
      pavucontrol
      qalculate-gtk
      qbittorrent
      qpwgraph
      renderdoc
      syncthing
      thunderbird
      tor-browser
      upscaler
      vesktop
      video-trimmer
      vlc
    ]);

  homebrew = {
    brews = [
      "syncthing"
    ];
    casks = [
      "audacity"
      "blender"
      "darktable"
      "ghostty"
      "obs"
      "raspberry-pi-imager"
      "spotify"
      "vesktop"
      "wine-stable"
      "zen"
    ];
  };

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
}
