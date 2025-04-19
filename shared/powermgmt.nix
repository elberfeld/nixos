{ config, pkgs, ... }:

{

  # Laptop Power Management Options 
  # https://nixos.wiki/wiki/Laptop
  # https://nixos.wiki/wiki/Power_Management

  # Enable Power Management 
  powerManagement.enable = true;
  powerManagement.powertop.enable = true;
  
  # Enable Thermald to prevent overheat on inter CPUs
  services.thermald.enable = true;

  # Enable Power Profiles Daemon 
  services.power-profiles-daemon.enable = true;

}
