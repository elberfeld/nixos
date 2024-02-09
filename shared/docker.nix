{ config, pkgs, ... }:

{

  # enable docker
  virtualisation.docker.enable = true;

  # List packages installed in system profile. 
  #environment.systemPackages = with pkgs; [

  #];

}

