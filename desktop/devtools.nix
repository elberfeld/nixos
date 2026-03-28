{ config, lib, pkgs, inputs, claude-desktop, ... }:

{

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # vscode: to enable sudo commands in vscode terminal, run: code --no-sandbox
  environment.systemPackages = with pkgs; [

    claude-code
    claude-desktop-with-fhs # see https://github.com/k3d3/claude-desktop-linux-flake
    drawio
    git
    opencode
    opencode-desktop
    vscode # git does not work properly as flatpak
    wireshark
    zenmap

  ];
  
}
