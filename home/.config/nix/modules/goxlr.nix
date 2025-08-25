{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    goxlr-utility
  ];
  services.goxlr-utility.enable = true;
}
