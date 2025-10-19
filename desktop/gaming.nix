{ config, lib, pkgs, ... }:

{

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = false; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = false; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = false; # Open ports in the firewall for Steam Local Network Game Transfers

    protontricks.enable = true;
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # vscode: to enable sudo commands in vscode terminal, run: code --no-sandbox
  environment.systemPackages = with pkgs; [

    steam
    protonplus
    protonup-qt
    protontricks

  ];
  
}
