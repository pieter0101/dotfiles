{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    mas
  ];

  homebrew = {
    enable = true;
    brews = [
    ];
    casks = [
      "bitwarden"
      "nikitabobko/tap/aerospace"
      "altserver"
      "tailscale-app"
    ];
    taps = [
      "nikitabobko/tap"
    ];
    masApps = {
      "Apple developer" = 640199958;
      "xcode" = 497799835;
    };
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
  };

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
