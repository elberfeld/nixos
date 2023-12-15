{ config, pkgs, ... }:

{

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.defaultSession = "plasmawayland";
  
  # XDG Portal for kde
  xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-kde ];

  # Exclude default Packages 
  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
    elisa
    kwalletmanager
    gwenview
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

    kate
    konsole
    plasma-browser-integration

    libsForQt5.discover
    libsForQt5.dolphin
    libsForQt5.dolphin-plugins
    libsForQt5.kamoso
    libportal-qt5

  ];

}
