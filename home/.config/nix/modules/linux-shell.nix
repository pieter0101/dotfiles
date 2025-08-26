{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    apple-cursor
    fuzzel
    niri
    quickshell
    satty
    swww
    wl-clipboard
    xwayland-satellite
  ];

  fonts.packages = with pkgs; [
    noto-fonts-cjk-sans
  ];
}
