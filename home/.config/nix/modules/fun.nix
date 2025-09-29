{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    asciiquarium
    astroterm
    cbonsai
    cmatrix
    cowsay
    figlet
    fortune
    krabby
    lolcat
    nyancat
    sl
  ];
}
