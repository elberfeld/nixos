{ config, lib, pkgs, ... }:

{

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Ugreen Revodok Pro 209
  # Display Link Driver - https://nixos.wiki/wiki/Displaylink
  # Driver Blob must be prefetched: $ nix-prefetch-url --name displaylink-600.zip https://www.synaptics.com/sites/default/files/exe_files/2024-05/DisplayLink%20USB%20Graphics%20Software%20for%20Ubuntu6.0-EXE.zip
  services.xserver.videoDrivers = [ "displaylink" "modesetting" ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true; 

  # Enable Avahi for network discovery and mdns
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable OpenGL 
  hardware.graphics.enable = true;

  # Enable Touchpad Support inX11/Wayland
  services.libinput.enable = true;

  # Enable CUPS to print documents.
  # see https://nixos.wiki/wiki/Printing
  services.printing = {
    enable = true;
    drivers = [ 
      # Drivers for many different printers from many different vendors.
      pkgs.gutenprint
      # Additional, binary-only drivers for some printers.
      pkgs.gutenprintBin
      # Drivers for HP printers.
      pkgs.hplip
      # Drivers for HP printers, with the proprietary plugin. Use NIXPKGS_ALLOW_UNFREE=1 nix-shell -p hplipWithPlugin --run 'sudo -E hp-setup' to add the printer, regular CUPS UI doesn't seem to work.
      #pkgs.hplipWithPlugin 
      # Postscript drivers for Lexmark
      #pkgs.postscript-lexmark
      # Proprietary Samsung Drivers
      #pkgs.samsung-unified-linux-driver
      # Drivers for printers supporting SPL (Samsung Printer Language).
      #pkgs.splix
      # Drivers for some Brother printers
      #pkgs.brlaser
      # Generic drivers for more Brother printers 
      # https://support.brother.com/g/s/id/linux/en/instruction_prn1a.html
      #pkgs.brgenml1lpr
      #pkgs.brgenml1cupswrapper 
      # Drivers for some Canon Pixma devices (Proprietary driver)
      #pkgs.cnijfilter2
    ];
  };

  # Enable sound with pipewire. Disable pulseaudio
  services.pulseaudio.enable = false;
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
  # programs.firefox = {                  
  #  enable = true;
  #  preferences = {
  #  "widget.use-xdg-desktop-portal.file-picker" = 1;
  #  "widget.use-xdg-desktop-portal.mime-handler" = 1;
  #  };
  #};

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # vscode: to enable sudo commands in vscode terminal, run: code --no-sandbox
  environment.systemPackages = with pkgs; [

    bitwarden-desktop
    flatpak
    gparted
    nextcloud-client # better system integration than flatpak
    vscode # git does not work properly as flatpak
    wireshark
    yubikey-manager-qt # not available as flatpak

  ];

}
