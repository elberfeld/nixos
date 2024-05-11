{ config, pkgs, ... }:

{

  # see https://nixos.wiki/wiki/Yubikey
  
  services.udev.packages = [ pkgs.yubikey-personalization ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

}
