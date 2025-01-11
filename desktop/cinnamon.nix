{ config, pkgs, ... }:

{

  # Enable the Cinnamon Desktop Environment.
  services.xserver.desktopManager.cinnamon.enable = true;
  
  # XDG Portal for kde
  xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-xapp ];

  # Exclude default Packages 
  environment.cinnamon.excludePackages = with pkgs; [
    gnome-screenshot
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    flameshot
    gnome-software
    gnome-system-monitor
  ];

}
