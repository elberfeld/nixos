{ config, pkgs, ... }:

{

  # enable docker
  virtualisation.docker = {
    enable = true;
    # Set up resource limits
    daemon.settings = {
      experimental = true;
      default-address-pools = [
        {
          # default subnet 172.18.0.0/16 collides with Deutsche Bahn Wifi networks
          base = "172.36.0.0/16"; 
          size = 24;
        }
      ];
    };
  };

  # List packages installed in system profile. 
  #environment.systemPackages = with pkgs; [

  #];

}

