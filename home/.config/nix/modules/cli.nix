{pkgs, ...}: {
  environment.systemPackages = with pkgs;
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
}
