{ config, pkgs, ... }:

{

  # Activate virtualbox 
  # User must be in Group vboxusers to use virtualbox
  virtualisation.virtualbox.host = {
    enable = true;
    enableKvm = true;
    addNetworkInterface = false;
  };

  # see https://discourse.nixos.org/t/issue-with-virtualbox-in-24-11/57607/2
  boot.kernelParams = [ "kvm.enable_virt_at_load=0" ];

}
