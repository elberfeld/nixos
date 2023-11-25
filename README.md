# NixOS Configurations

Clone this Repo and replace /etc/nixos/configuration.nix with a symlink to the configuration in this repo.

## Setup Nix-Chanels

nix-channel --remove nixos
nix-channel --add https://nixos.org/channels/nixos-unstable nixos
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

## Clone with SSH Key from Yubikey 

The folowing extensions in configuration.nix are needed 

```
  environment.systemPackages = with pkgs; [
    git
    gnupg
    yubikey-personalization
   ];

  services.udev.packages = with pkgs; [ 
    yubikey-personalization 
  ];

  programs.ssh.startAgent = false;
  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.enableSSHSupport = true;
  services.pcscd.enable = true;

```

