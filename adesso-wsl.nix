{ config, lib, pkgs, ... }:

{
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
    ./shared/base.nix
    ./shared/docker.nix
    ./desktop/base.nix
    ./user/chris.nix
  ];

  wsl.enable = true;
  wsl.defaultUser = "chris";

  # Define your hostname
  networking.hostName = "adesso-wsl"; 

  environment.systemPackages = with pkgs; [

    ansible
    direnv
    neovim
    socat
    thunderbird
    vscode

  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}

