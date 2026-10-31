{ config, pkgs, inputs, ... }:

{

  # CachyOS Kernel from https://github.com/xddxdd/nix-cachyos-kernel
  # x86_64-v3 = AVX2 (Intel Haswell and newer, AMD Zen 1 and newer).
  # x86_64-v4 requires AVX-512, which neither Skylake nor Alder Lake client CPUs support.
  # Binary cache is configured in shared/base.nix.
  nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-x86_64-v3;

}
