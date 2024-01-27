{ config, pkgs, ... }:

{

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "de";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };


  # Enable flatpak
  services.flatpak.enable = true;
  services.packagekit.enable = true;

  # Enable dconf
  programs.dconf.enable = true;

  # set environment variables 
  environment.sessionVariables = {
    # Hint electron Apps to use wayland
    NIXOS_OZONE_WL = "1";
  };

  # Fix Filepickers for Firefox
  # https://wiki.archlinux.org/title/firefox#XDG_Desktop_Portal_integration
  programs.firefox = {                  
    enable = true;
    preferences = {
    "widget.use-xdg-desktop-portal.file-picker" = 1;
    "widget.use-xdg-desktop-portal.mime-handler" = 1;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

    firefox
    flatpak
    freerdp
    gparted
    remmina
    thunderbird
    vlc

  ];

}
