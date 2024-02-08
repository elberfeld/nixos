{ config, lib, pkgs, ... }:

{
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
    #<nixpkgs/nixos/modules/profiles/minimal.nix>
    <nix-ld/modules/nix-ld.nix>
    ./shared/base.nix
    ./shared/nix-ld-config.nix
    ./user/chris.nix
  ];

  wsl.enable = true;
  wsl.defaultUser = "chris";

  # Define your hostname
  networking.hostName = "adesso-wsl"; 

  # Enable nix-ld-config for vscode in WSL
  nix-ld-config.enable = true;
  nix-ld-config.user = "chris";

  environment.systemPackages = with pkgs; [

    direnv
    neovim
    socat
    thunderbird

  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}

