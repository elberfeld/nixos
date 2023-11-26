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

  # Disable Prower Profiles Daemon (conflicts with TLP) 
  services.power-profiles-daemon.enable = false;

  # Enable TLP
  # https://linrunner.de/tlp/
  # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/hardware/tlp.nix
  services.tlp.enable = true;

  # Enable Auto-CpuFreq
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
    };
  };

  # acpi_call makes tlp work for newer thinkpads
  boot = {
    kernelModules = [ "acpi_call" ];
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
  };

}
