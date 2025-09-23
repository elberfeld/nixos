{ config, pkgs, ... }:

{

  # Enable the KDE Plasma Desktop Environment.
  services.desktopManager.plasma6.enable = true;
  
  # XDG Portal for kde
  xdg.portal.extraPortals = with pkgs; [ kdePackages.xdg-desktop-portal-kde ];

  # Exclude default Packages 
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    gwenview
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs.kdePackages; [

    discover
    dolphin
    dolphin-plugins
    #kamoso - 10.03.2024 - Package is broken
    kate
    konsole
    partitionmanager
    plasma-browser-integration
    sddm
    sddm-kcm 
    spectacle

  ];

}
