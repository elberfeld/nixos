{ config, pkgs, ... }:

{

  # Verwendung des SSH-Schlüssels vom Yubikey
  services.yubikey-agent.enable = true;
  services.pcscd.enable = true;

  environment.systemPackages = with pkgs; [
    pinentry
    pinentry-curses
    pinentry-gtk2
    pinentry-qt
  ];

  # Alternative Konfiguration mit dem GnuPG-Agent 
  # https://nixos.wiki/wiki/Yubikey

  #services.udev.packages = [ pkgs.yubikey-personalization ];
  #services.pcscd.enable = true;

  #programs.gnupg.agent = {
  #  enable = true;
  #  enableSSHSupport = true;
  #};

}
