{ config, pkgs, ... }:

{

  # Display Manager Ly
  # https://github.com/fairyglade/ly

  services.displayManager.ly = {
    enable = true;
  };

}
