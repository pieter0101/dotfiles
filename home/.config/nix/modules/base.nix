{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    bc
    btop
    fzf
    git
    gnupg
    neovim
    pwgen
    restic
    ripgrep
    stow
    tealdeer
    tmux
    wgetpaste
    zellij
  ];

  nix.settings.experimental-features = "nix-command flakes";
}
