{ config, pkgs, ... }:

{

  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      ./desktop/base.nix
      ./desktop/kde.nix
      ./shared/base.nix
      ./shared/powermgmt.nix
      ./shared/yubikey.nix
      ./user/chris.nix
    ];

  # Bootloader Settimgs
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.consoleMode = "1";
  boot.loader.efi.canTouchEfiVariables = true;

  # Luks devices
  boot.initrd.luks.devices."luks-0d883292-d0a9-470e-bbc1-e12030fa0265".device = "/dev/disk/by-uuid/0d883292-d0a9-470e-bbc1-e12030fa0265";

  # Define your hostname
  networking.hostName = "void-carbonx1"; 

  # Login Manager 
  services.xserver.displayManager.sddm.enable = true;

  # Lenovo Device Info
  # https://psref.lenovo.com/Detail/ThinkPad_X1_Carbon_Gen_10?M=21CB00AEMB
  
  # Arch Wiki with Hardware Infos 
  # https://wiki.archlinux.org/title/Lenovo_ThinkPad_X1_Carbon_(Gen_10)

  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true; 

  # Enable OpenGL 
  hardware.opengl.enable = true;

  # Enable Touchpad Support inX11/Wayland
  services.xserver.libinput.enable = true;

  # Fingerprint Sensor 
  services.fprintd.enable = true;

  # Camera
  # currently unstable, causes system freeze after standby/suspend
  # see https://github.com/NixOS/nixpkgs/issues/225743
  #hardware.ipu6 = {
  #  enable = true;
  #  platform = "ipu6ep";
  #};

  # FCC Unlock for integrated LTE Modem
  # curently not working, see
  # https://modemmanager.org/docs/modemmanager/fcc-unlock/#integration-with-third-party-fcc-unlock-tools
  # https://forums.lenovo.com/t5/Other-Linux-Discussions/L860GL-fcc-unlock-issue/m-p/5233291
  # systemd.services.ModemManager.enable = true;
  # networking.networkmanager.fccUnlockScripts = [
  #   { id = "1199:9079"; path = "${pkgs.modemmanager}/share/ModemManager/fcc-unlock.available.d/1199:9079"; }
  # ];

  # exclude WWAN from Powersave 
  # see https://wiki.archlinux.org/title/Lenovo_ThinkPad_X1_Carbon_(Gen_10)
  services.tlp.settings = {
    RUNTIME_PM_DENYLIST="08:00.0";
  };

  #fonts.fontconfig.dpi = 135;
  #i18n.consoleFont = "ter-132b";
  #i18n.consolePackages = with pkgs; [ terminus_font ];
  #boot.earlyVconsoleSetup = true;  

  # set up console font for boot 
  #console = {
  #  earlySetup = true;
  #  font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
  #  packages = with pkgs; [ terminus_font ];
  #};

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

    vscodium 

  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}


