# NixOS Configurations

Clone this Repo and replace /etc/nixos/configuration.nix with a symlink to the configuration in this repo.

## Setup Nix-Chanels

```
nix-channel --remove nixos
nix-channel --add https://nixos.org/channels/nixos-unstable nixos
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
```

## Clone with SSH Key from Yubikey 

The folowing extensions in configuration.nix are needed 

```
services.yubikey-agent.enable = true;
```

