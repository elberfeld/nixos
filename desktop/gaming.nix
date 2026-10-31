{ config, lib, pkgs, ... }:

{

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = false; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = false; # Open ports in the firewall for Steam Local Network Game Transfers

    protontricks.enable = true;
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # steam and protontricks are installed by programs.steam above; listing
  # them here again would shadow the configured package.
  environment.systemPackages = with pkgs; [

    protonplus
    protonup-qt
    winetricks

  ];
  
}
