{ config, pkgs, ... }:

{

  # Enable networking with NetworkManager
  networking.networkmanager.enable = true;
  
  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Passwordless sudo for group wheel  
  security.sudo.wheelNeedsPassword = false;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    btop
    curl
    git
    iftop
    mtr
    nano
    powertop
    psmisc
    tmux
    wget
  ];

  # Install Fonts Fonts
  fonts.packages = with pkgs; [
    fira-code
    fira
    cooper-hewitt
    ibm-plex
    jetbrains-mono
    iosevka
    spleen
    fira-code-symbols
    powerline-fonts
    nerdfonts
  ];

  # Automatic upgrades 
  # https://nixos.wiki/wiki/Automatic_system_upgrades
  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/tasks/auto-upgrade.nix
  system.autoUpgrade.enable = true;
  system.autoUpgrade.dates = "04:00";
  system.autoUpgrade.allowReboot = false;

}
