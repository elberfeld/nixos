{ config, pkgs, ... }:

let
  GERMAN = "de_DE.UTF-8/UTF-8";
  ENGLISH = "en_US.UTF-8/UTF-8";
in {

  # Enable networking with NetworkManager
  networking.networkmanager.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  networking.firewall.enable = true;
  
  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.supportedLocales = [ ENGLISH GERMAN ];
  i18n.defaultLocale = GERMAN;
  i18n.extraLocaleSettings = {

    LC_ADDRESS = GERMAN;
    LC_ALL = GERMAN;
    LC_CTYPE = GERMAN;
    LC_COLLATE = GERMAN;
    LC_IDENTIFICATION = GERMAN;
    LC_MEASUREMENT = GERMAN;
    LC_MESSAGES = GERMAN;
    LC_MONETARY = GERMAN;
    LC_NAME = GERMAN;
    LC_NUMERIC = GERMAN;
    LC_PAPER = GERMAN;
    LC_TELEPHONE = GERMAN;
    LC_TIME = GERMAN;
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
    carapace
    curl
    git
    htop
    iftop
    mosh
    mtr
    mosh 
    nano
    nushell
    pciutils
    powertop
    psmisc
    starship
    tmux
    tree
    usbutils
    vim
    wget
  ];

  # Install Fonts Fonts
  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [

    cooper-hewitt    
    fira
    fira-code
    fira-code-symbols
    hack-font    
    ibm-plex
    iosevka
    jetbrains-mono
    liberation_ttf
    nerdfonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    powerline-fonts
    proggyfonts
    spleen
  ];

  # Automatic upgrades 
  # https://nixos.wiki/wiki/Automatic_system_upgrades
  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/tasks/auto-upgrade.nix
  system.autoUpgrade.enable = true;
  system.autoUpgrade.dates = "daily";
  system.autoUpgrade.allowReboot = false;

  # Garbage collection 
  nix.settings.auto-optimise-store = true;
  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than 7d";

}
