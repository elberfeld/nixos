{ config, lib, pkgs, ... }:

{

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Ugreen Revodok Pro 209
  # Display Link Driver - https://nixos.wiki/wiki/Displaylink
  # Driver Blob must be prefetched: $ nix-prefetch-url --name displaylink-580.zip https://www.synaptics.com/sites/default/files/exe_files/2023-08/DisplayLink%20USB%20Graphics%20Software%20for%20Ubuntu5.8-EXE.zip
  services.xserver.videoDrivers = [ "displaylink" "modesetting" ];

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
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

  # Enable XDG Portal
  xdg.portal.enable = true;
  xdg.portal.config.common.default = "*";
  xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];


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

    bitwarden-desktop
    firefox
    flatpak
    freerdp
    gparted
    remmina
    thunderbird
    vlc

  ];

}
