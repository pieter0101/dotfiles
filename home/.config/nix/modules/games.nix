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
}
