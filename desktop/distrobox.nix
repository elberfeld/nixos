{ config, lib, pkgs, inputs, ... }:

{

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

    distrobox 
    kontainer

  ];
  
}
