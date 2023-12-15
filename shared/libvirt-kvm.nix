{ config, pkgs, ... }:

{

  # enable libvirt/kvm
  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];
  virtualisation.libvirtd.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

    virt-manager
    win-virtio

  ];

}
