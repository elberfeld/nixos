{ config, lib, pkgs, inputs, ... }:

{

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

    claude-code
    inputs.claude-desktop.packages.${pkgs.stdenv.hostPlatform.system}.claude-desktop-fhs
    drawio
    git
    opencode
    opencode-desktop
    python3
    vscode 
    vscodium
    wireshark
    zenmap

  ];
  
}
