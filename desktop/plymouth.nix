{ config, lib, pkgs, inputs, ... }:

{

  # Plymouth theme overlay
  # https://github.com/SergioRibera/s4rchiso-plymouth-theme
  nixpkgs.overlays = [ inputs.mac-style-plymouth.overlays.default ];

  # Graphical boot screen 
  boot.initrd.systemd.enable = true;
  boot.initrd.verbose = false;
  boot.consoleLogLevel = 0; 

  boot.kernelParams = [
    "quiet" # Suppress most kernel messages during boot
    "splash" # Enable splash screen
    "boot.shell_on_fail" # Drop to shell on boot failure
    "loglevel=3" # Set kernel log level to 0 (emergencies only)
    "rd.systemd.show_status=false" # Hide systemd status messages
    "rd.udev.log_level=3" # Suppress udev logs
    "udev.log_priority=3" # Suppress udev logs
  ];

  boot.plymouth = {
    enable = true;
    theme = "mac-style";
    themePackages = [ pkgs.mac-style-plymouth ];

    extraConfig = ''
      [Daemon]
      ShowDelay=0
    '';
  };

}


