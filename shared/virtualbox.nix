{ config, pkgs, ... }:

{

  # Activate virtualbox 
  # User must be in Group vboxusers to use virtualbox
  virtualisation.virtualbox.host.enable = true;

}
