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
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
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
        NowPlaying = false;
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
}
