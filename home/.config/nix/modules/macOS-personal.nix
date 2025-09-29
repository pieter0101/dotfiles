{pkgs, ...}: {
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
}
