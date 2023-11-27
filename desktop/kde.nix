{ config, pkgs, ... }:

{

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.defaultSession = "plasmawayland";
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

    kate
    konsole
    plasma-browser-integration

    libsForQt5.discover
    libsForQt5.dolphin
    libsForQt5.dolphin-plugins
  ];

}
