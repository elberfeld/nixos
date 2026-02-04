{ config, lib, pkgs, inputs, ... }:

{

  # Unlock with TPM 
  # Initialize: sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+2+7+12 --wipe-slot=tpm2 <device>
  # see: https://jnsgr.uk/2024/04/nixos-secure-boot-tpm-fde/
  security.tpm2.enable = true;
  boot.initrd.systemd.enable = true;
  boot.initrd.systemd.tpm2.enable = true;

}


