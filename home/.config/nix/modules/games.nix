{ pkgs, ... }:
{
  environment.systemPackages =
    with pkgs;
    [
    ]
    ++ (lib.optionals (pkgs.system == "x86_64-linux") [
      dolphin-emu
      gamemode
      heroic
      luanti
      openttd
      pcsx2
      ppsspp
      prismlauncher
      retroarch
      rpcs3
      ryubing
      sunshine
      superTux
      superTuxKart
    ]);

  homebrew.casks = [
    "moonlight"
    "prismlauncher"
    "steam"
  ];
}
