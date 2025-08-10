# Example hardware configuration for testing
# Copy your real /etc/nixos/hardware-configuration.nix here for actual use
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  # Example minimal filesystem configuration
  # Replace with your actual filesystem setup
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  swapDevices = [ ];

  # Example hardware settings
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
