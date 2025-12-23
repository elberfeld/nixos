{ config, pkgs, lib, inputs, lanzaboote, ... }:

{
  # configure lanzaboote for secure boot 
  # see https://github.com/nix-community/lanzaboote/blob/master/docs%2Fgetting-started%2Fprepare-your-system.md

  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  environment.systemPackages = [
    # For debugging and troubleshooting Secure Boot.
    pkgs.sbctl
  ];

  # Lanzaboote currently replaces the systemd-boot module.
  # This setting is usually set to true in configuration.nix
  # generated at installation time. So we force it to false
  # for now.
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.timeout = 5;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
    configurationLimit = 16;
  };

}
