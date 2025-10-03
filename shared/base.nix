{ config, pkgs, ... }:

let
  GERMAN = "de_DE.UTF-8";
  GERMAN_UTF8 = "de_DE.UTF-8/UTF-8";
  ENGLISH = "en_US.UTF-8";
  ENGLISH_UTF8 = "en_US.UTF-8/UTF-8";
in {

  # Enable networking with NetworkManager
  networking.networkmanager.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  networking.firewall.enable = true;

  # Firmware Update service - https://nixos.wiki/wiki/Fwupd
  services.fwupd.enable = true;

  # Reduced wait time for jobs on reboot 
  systemd.settings.Manager.DefaultTimeoutStopSec = "10s";

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.supportedLocales = [ ENGLISH_UTF8 GERMAN_UTF8 ];
  i18n.defaultLocale = GERMAN;
  i18n.extraLocaleSettings = {

    LANG = GERMAN;
    LC_ALL = GERMAN;
    LC_IDENTIFICATION = GERMAN;
    LC_MESSAGES = GERMAN;

    LC_ADDRESS = GERMAN;
    LC_CTYPE = GERMAN;
    LC_COLLATE = GERMAN;
    LC_MEASUREMENT = GERMAN;
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

  # Enable flakes and new nix command
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Passwordless sudo for group wheel  
  security.sudo.wheelNeedsPassword = false;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    ansible
    ansible-lint
    btop
    carapace
    curl
    dig
    direnv
    git
    gitui
    glibcLocales
    glibcLocalesUtf8
    htop
    iftop
    mosh
    mtr
    mosh 
    nano
    neovim
    nmap
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
    corefonts    
    fira
    fira-code
    fira-code-symbols
    hack-font    
    ibm-plex
    iosevka
    jetbrains-mono
    liberation_ttf
    nerd-fonts.caskaydia-cove
    nerd-fonts.caskaydia-mono
    nerd-fonts.code-new-roman
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.monaspace
    nerd-fonts.ubuntu
    nerd-fonts.ubuntu-mono
    nerd-fonts.ubuntu-sans
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    powerline-fonts
    proggyfonts
    spleen
    vistafonts
    wireguard-go
    wireguard-tools
  ];

  # Automatic upgrades 
  # https://nixos.wiki/wiki/Automatic_system_upgrades
  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/tasks/auto-upgrade.nix
  system.autoUpgrade = {

    enable = true;
    operation = "boot";
    dates = "hourly";
    allowReboot = false;
  };

  # Garbage collection 
  nix.settings.auto-optimise-store = true;
  nix.gc = { 
    automatic = true;
    dates = "hourly";
    options = "--delete-older-than +10";
  };

}
