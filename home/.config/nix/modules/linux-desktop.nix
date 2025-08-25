{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    #"steam"
    #"zen"
  ];
  services.flatpak.enable = true;
  # Flatpaks: bottles flatseal sober
}
