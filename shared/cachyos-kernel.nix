{ config, lib, pkgs, inputs, ... }:

{

  # CachyOS Kernel from https://github.com/xddxdd/nix-cachyos-kernel 
  nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;

  # Use Lantian Cache for CachyOS Kernel binaries
  nix.settings.substituters = [ "https://attic.xuyh0120.win/lantian" ];
  nix.settings.trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];

}


