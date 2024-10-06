{ config, pkgs, ... }:

{

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.desktopManager.gnome.enable = true;
  
  # XDG Portal for kde
  xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-gnome ];

  # Exclude default Packages 
  # environment.gnome.excludePackages = with pkgs; [

  # ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [

  # ];

}
