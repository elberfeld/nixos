# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ 
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Include base config 
      ./base.nix
      # Include Host specific config 
      #./hosts/${hostname}
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-0d883292-d0a9-470e-bbc1-e12030fa0265".device = "/dev/disk/by-uuid/0d883292-d0a9-470e-bbc1-e12030fa0265";
  networking.hostName = "nixos"; # Define your hostname.

}
