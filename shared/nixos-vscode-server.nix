
# VSCode Server for NixOS in WSL, see https://github.com/nix-community/nixos-vscode-server

{ config, pkgs, ... }:

{
  imports = [
    (fetchTarball "https://github.com/nix-community/nixos-vscode-server/tarball/master")
  ];

  services.vscode-server.enable = true;
}
