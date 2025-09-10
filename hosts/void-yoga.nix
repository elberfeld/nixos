{ config, pkgs, ... }:

{



  # Bootloader Settimgs
  boot.loader.efi.canTouchEfiVariables = true;

  # Use Systemd-Boot
  boot.loader.systemd-boot = { 
    enable = true;
    editor = false;
    consoleMode = "max";
  };

  # Graphical boot scren 
  #boot.initrd.systemd.enable = true;
  #boot.plymouth.enable = true;
  #boot.plymouth.theme = "breeze";

  # Enable swap on luks
  boot.initrd.luks.devices."luks-1151810a-9681-4ea5-8c74-1e3886f7a091".device = "/dev/disk/by-uuid/1151810a-9681-4ea5-8c74-1e3886f7a091";

  # Hostname
  networking.hostName = "void-yoga"; 


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}


