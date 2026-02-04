{ config, lib, pkgs, inputs, ... }:

{

  # Graphical boot screen 
  boot.initrd.systemd.enable = true;
  boot.plymouth.enable = true;
  boot.plymouth.theme = "breeze";

}


