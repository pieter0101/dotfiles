{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    apple-cursor
    fuzzel
    kdePackages.qt6ct
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
