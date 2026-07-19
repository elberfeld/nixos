{ config, pkgs, lib, ... }:

{

  # Always use most recent kernel by default; hosts can override
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  
  # Enable networking with NetworkManager
  networking.networkmanager.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  networking.firewall.enable = true;

  # Firmware Update service - https://nixos.wiki/wiki/Fwupd
  services.fwupd.enable = true;

  # Support for Yubikey SSH Keys
  # see https://nixos.wiki/wiki/Yubikey
  
  services.udev.packages = [ pkgs.yubikey-personalization ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

}
