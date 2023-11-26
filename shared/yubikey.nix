{ config, pkgs, ... }:

{

  # Verwendung des SSH-Schlüssels vom Yubikey
  # Hierfür ist der gnupg Agent erforderlich 

  environment.systemPackages = with pkgs; [
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
}
