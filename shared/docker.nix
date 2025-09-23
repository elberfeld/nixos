{ config, pkgs, ... }:

{

  # enable docker
  virtualisation.docker = {
    enable = true;
    # Set up resource limits
    daemon.settings = {
      experimental = true;
    };
  };

  # List packages installed in system profile. 
  #environment.systemPackages = with pkgs; [

  #];

}

