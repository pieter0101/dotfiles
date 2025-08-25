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
}
