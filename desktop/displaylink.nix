{ config, lib, pkgs, ... }:

{

  # Ugreen Revodok Pro 209
  # Display Link Driver - https://nixos.wiki/wiki/Displaylink
  # Driver Blob must be prefetched: 
  # (2024-05 Version - working) nix-prefetch-url --name displaylink-600.zip https://www.synaptics.com/sites/default/files/exe_files/2024-05/DisplayLink%20USB%20Graphics%20Software%20for%20Ubuntu6.0-EXE.zip
  # (2025-04 Version - current) nix-prefetch-url --name displaylink-600.zip https://www.synaptics.com/sites/default/files/exe_files/2025-04/DisplayLink%20USB%20Graphics%20Software%20for%20Ubuntu6.1.1-EXE.zip

  boot = {
    extraModulePackages = [ config.boot.kernelPackages.evdi ];
    initrd = {
      # List of modules that are always loaded by the initrd.
      kernelModules = [
        "evdi"
      ];
    };
  };
  
  services.xserver.videoDrivers = [ "displaylink" "modesetting" ];

  environment.variables = {
    KWIN_DRM_PREFER_COLOR_DEPTH = "24";
  };

  environment.systemPackages = with pkgs; [
    displaylink
  ];

  # Gnome only 
  systemd.services.dlm.wantedBy = [ "multi-user.target" ];

  # KDE Only
  # --- THIS IS THE CRUCIAL PART FOR ENABLING THE SERVICE ---
  systemd.services.displaylink-server = {
    enable = true;
    # Ensure it starts after udev has done its work
    requires = [ "systemd-udevd.service" ];
    after = [ "systemd-udevd.service" ];
    wantedBy = [ "multi-user.target" ]; # Start at boot
    # *** THIS IS THE CRITICAL 'serviceConfig' BLOCK ***
    serviceConfig = {
      Type = "simple"; # Or "forking" if it forks (simple is common for daemons)
      # The ExecStart path points to the DisplayLinkManager binary provided by the package
      ExecStart = "${pkgs.displaylink}/bin/DisplayLinkManager";
      # User and Group to run the service as (root is common for this type of daemon)
      User = "root";
      Group = "root";
      # Environment variables that the service itself might need
      # Environment = [ "DISPLAY=:0" ]; # Might be needed in some cases, but generally not for this
      Restart = "on-failure";
      RestartSec = 5; # Wait 5 seconds before restarting
    };
  };

}
