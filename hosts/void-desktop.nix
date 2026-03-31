{ config, lib, pkgs, inputs, ... }:

{
  # CachyOS Kernel from https://github.com/xddxdd/nix-cachyos-kernel 
  # x86_64-v4 is for newer CPUs like interl Skylake and newer
  nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-x86_64-v4;

  # Bootloader Settings
  boot.loader.efi.canTouchEfiVariables = true;

  # Use Systemd-Boot
  boot.loader.systemd-boot = { 
    enable = true;
    editor = false;
    consoleMode = "max";
  };

  # Define your hostname
  networking.hostName = "void-desktop"; 

  # Autologin on Start 
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "chris";

  # Additional Disks: Kingstoin SSD for Games
  fileSystems."/games" =
  { 
    device = "/dev/disk/by-uuid/888f57ec-e4a1-49d5-9da4-f2f4913db200";
    fsType = "ext4";
  };

  # Additional Disks: WD Red for Data
  fileSystems."/data" =
  { 
    device = "/dev/disk/by-uuid/9419485c-3dae-4946-89af-e9179c5fcfef";
    fsType = "ext4";
  };

  environment.systemPackages = with pkgs; [
    czkawka-full
    qbittorrent-enhanced
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}


