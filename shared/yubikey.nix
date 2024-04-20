{ config, pkgs, ... }:

{

  # Verwendung des SSH-Schlüssels vom Yubikey
  #services.yubikey-agent.enable = true;

  #environment.systemPackages = with pkgs; [
  #  pinentry-tty
  #];

  #programs.gnupg.agent = {
  #  enable = false;
  #  pinentryPackage = pkgs.pinentry-tty;
  #};

  # Alternative Konfiguration mit dem GnuPG-Agent 
  # https://nixos.wiki/wiki/Yubikey

  # Stand 20.04.2024: Option disable-ccid in $HOME/.gnupg/scdaemon.conf is needed 
  # Open Bug, see https://github.com/NixOS/nixpkgs/issues/155629 

  hardware.gpgSmartcards.enable = true;

  services.udev.packages = [ pkgs.yubikey-personalization ];
  services.pcscd.enable = true;

  programs.ssh.startAgent = false;
  
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-tty;
  };

  environment.systemPackages = with pkgs; [
    gnupg
    pinentry-all
    yubikey-personalization
  ];

  environment.shellInit = ''
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  '';

}
