{ config, lib, pkgs, inputs, ... }:

{

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # vscode: to enable sudo commands in vscode terminal, run: code --no-sandbox
  environment.systemPackages = with pkgs; [

    claude-code
    # inputs.claude-desktop.packages.${pkgs.stdenv.hostPlatform.system}.claude-desktop-with-fhs # Disabled: upstream flake uses unmaintained nodePackages
    drawio
    git
    opencode
    opencode-desktop
    vscode # git does not work properly as flatpak
    wireshark
    zenmap

  ];
  
}
