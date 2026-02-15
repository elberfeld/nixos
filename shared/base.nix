{ config, pkgs, lib, ... }:

let
  GERMAN = "de_DE.UTF-8";
  GERMAN_UTF8 = "de_DE.UTF-8/UTF-8";
  ENGLISH = "en_US.UTF-8";
  ENGLISH_UTF8 = "en_US.UTF-8/UTF-8";
in {

  # Always use most recent kernel by default; hosts can override
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  
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

  # Don't allow to create new users
  # Change Passwords is still allowed for existing users, but no new users can be created.
  # users.mutableUsers = false; 

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
    noto-fonts-color-emoji
    powerline-fonts
    proggyfonts
    spleen
    vista-fonts
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
    options = "--delete-older-than 30d";
  };

  security.pki.certificates = [ ''Warpzone internal CA
-----BEGIN CERTIFICATE-----
MIIFBDCCAuygAwIBAgIUJt6dSah3Lpsy3zenka2t+OEOO6AwDQYJKoZIhvcNAQEL
BQAwGjEYMBYGA1UEAwwPd2FycHpvbmUubGFuIENBMB4XDTIzMDIyMTIxNDQ0OVoX
DTMzMDIxODIxNDQ0OVowGjEYMBYGA1UEAwwPd2FycHpvbmUubGFuIENBMIICIjAN
BgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA5hXLG/f8q2zVdtmrDeFHz/NYgd37
Rtv6Pl1fLd1z3E1JvwSNF/s0Qv9kXyK6RQfaO/5AqzRQTkwiR7pZ7aS5WPjPK3yL
vJBVfnwKqFlu3QIfwWc81kY2K3jDnXujeaKFmLFh8UIc6IZQPmM+CzV+1yY44bE4
gdF9vblilMdq5dnqZUnpiXWeFx7AUsOHYr/Ee4/HvudpSpC5gBIMVti0qqCgkhMi
tKdymFQ02seLR1P7J0LbUdCq8GZ4yQ6LvDLrpDj5KZuGAWL7fp9tF/GSOhDcNGPV
kACqzgftkqg+3Nomz31QwIvW0mz+y6n1mkm2Yg6H/h4XzOahbQkXb0YsHkFNFIS4
0W64WgfDrIBs/FvfVxWSSINWEMWrZtKcYEMN2LmlioK4SGO7KrNmnd9MuSkZHLzM
Xb240ixnrLTTpc4CzlXT78Z0C0fsZG8nJvuM++l/L+LSf0PXSephNsw3we4iTkQB
UZBPcGSkdd9Ba131JFyqm49x7u/Xv7Pv9OLmrrkzHcU4wZ7wl5CCFdtDxNq/ATkt
PBkI/1qlIf7aKCUVz0sl1rpFXKcYIcYHMjLPjbBtkEp2jr4d0YDtkr4iGqSypbJG
HSiBY4ncaMnrOAlhJhn/fbl6bp3Ty5JB/q3PjS0a5Ark4LM34MsJlTHVGjbA5lOA
/rxXERzkzUBF7icCAwEAAaNCMEAwDgYDVR0PAQH/BAQDAgIEMA8GA1UdEwEB/wQF
MAMBAf8wHQYDVR0OBBYEFGj0ueBuUflIhRe3vmKcOqesGSrpMA0GCSqGSIb3DQEB
CwUAA4ICAQAohHr/je7DsMzPyABL+gxIVQO+lvH3NAJCilC4bSVfJVK3u6TwK8k1
uBFZ7HFT75PQCVmtnVcGwlwdHjILJXlbyKNhQngayuSbyV3ewXKtcJhAkepRKwlS
cKKp6J23BzvM6tHA8NlCnepaACvXQWHsfj1IeRXsYpoqSsDi6S1R5kdtUB3CiUDN
xOI5HKCnQ49lchVkzRXWeRpCEBw7/XZU5hSbLhnPCq2sUcv1YTWK1FTX2nFWW1mJ
Q2CMfYg9ulCL4pEMfzUAzZAKlAAiQSdg9XUftizJN7E4PiiHxwNF3jNUKakVVrNa
wm/m6nEKkAiXwI6wAjICMvE4inFWixLthMhUER8XGI0s2sZIqhRdkzoIX1KjdfDY
xeIr6jSK/evUNPeC4C2HqO6w9sXWvTPMfhcIdcft1hHG9oQeaLekI+PHP9FDVEYt
FlMwqZqITRNZvcmiUgyVdPBe5dCrwccEtpmHWh57SdhcsZaEiEw6u+MWCrFSDdbO
WjYdQR9h/EgWoUlzw49G5jo874uI/qMiB7TatRGGjDtztFjg69O3brH+y9yhRFaj
i0hZhNAPEXhwMaokGxI40B78QmVnWmDcrQ/fn0lhZeI79VLv1mmhPi9C4v1/Gm80
/RiTDO0scPgtDhazoZV69CcV2+Dnyx9Z1FkXMX8mNzTBhH40KVUkFg==
-----END CERTIFICATE-----
  ''];

}
