{ config, lib, pkgs, ... }:

{

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # vscode: to enable sudo commands in vscode terminal, run: code --no-sandbox
  environment.systemPackages = with pkgs; [

    claude-code
    drawio
    git
    opencode
    opencode-desktop
    vscode # git does not work properly as flatpak
    wireshark
    zenmap

  ];
  
}
