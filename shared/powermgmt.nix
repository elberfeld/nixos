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

  # Disable USB Autosuspend to avoid issues with some USB devices
  # Avoid USB Keyboard input Lag 
  # https://discourse.nixos.org/t/external-mouse-and-keyboard-sleep-when-they-stay-untouched-for-a-few-seconds/14900/11
  boot.kernelParams = [ "usbcore.autosuspend=-1" ];

}
