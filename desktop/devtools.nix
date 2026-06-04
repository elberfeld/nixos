{ config, lib, pkgs, inputs, ... }:

{

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

    claude-code
    # inputs.claude-desktop.packages.${pkgs.stdenv.hostPlatform.system}.claude-desktop-with-fhs # Disabled: upstream flake uses unmaintained nodePackages
    drawio
    git
    kilocode-cli
    opencode
    opencode-desktop
    vscode 
    vscodium
    wireshark
    zenmap

  ];
  
}
