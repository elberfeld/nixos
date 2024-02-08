
# VSCode Server for NixOS in WSL, see https://github.com/nix-community/nixos-vscode-server

{ config, pkgs, ... }:

{
  imports = [
    (fetchTarball "https://github.com/nix-community/nixos-vscode-server/tarball/master")
  ];

  services.vscode-server.enable = true;

  environment.systemPackages = with pkgs; [
    vscode
    nodejs-16_x # Need this for https://nixos.wiki/wiki/Vscode server
  ];

  # https://code.visualstudio.com/docs/setup/linux#_visual-studio-code-is-unable-to-watch-for-file-changes-in-this-large-workspace-error-enospc
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = "524288";
  };

}
