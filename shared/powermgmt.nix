{ config, pkgs, ... }:

{

  # Laptop Power Management Options 
  # https://nixos.wiki/wiki/Laptop
  # https://nixos.wiki/wiki/Power_Management

  # Enable Power Management 
  powerManagement.enable = true;
  # powertop auto-tune is disabled on purpose: it re-enables USB autosuspend,
  # which conflicts with usbcore.autosuspend=-1 in desktop/base.nix (input lag).
  powerManagement.powertop.enable = false;
  
  # Enable Thermald to prevent overheat on inter CPUs
  services.thermald.enable = true;

  # Enable Power Profiles Daemon 
  services.power-profiles-daemon.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

    powertop
  ];

}
