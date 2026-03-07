{ config, lib, pkgs, inputs, ... }:

{
  # CachyOS Kernel from https://github.com/xddxdd/nix-cachyos-kernel 
  # x86_64-v4 is for newer CPUs like interl Skylake and newer
  nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-x86_64-v4;

  # Bootloader Settings
  boot.loader.efi.canTouchEfiVariables = true;

  # Use Systemd-Boot
  boot.loader.systemd-boot = { 
    enable = true;
    editor = false;
    consoleMode = "max";
  };

  # Define your hostname
  networking.hostName = "void-carbonx1"; 

  # Allow UDP port for AusweisApp
  networking.firewall.allowedUDPPorts = [ 24727 ];
  
  # Lenovo Device Info
  # https://psref.lenovo.com/Detail/ThinkPad_X1_Carbon_Gen_10?M=21CB00AEMB
  
  # Arch Wiki with Hardware Infos 
  # https://wiki.archlinux.org/title/Lenovo_ThinkPad_X1_Carbon_(Gen_10)


  # Fingerprint Sensor 
  # Causes Login delay, see https://github.com/NixOS/nixpkgs/issues/239770
  services.fprintd.enable = true;

  # Blacklist the iosm module (Intel LTE modem driver) because it causes hibernation to hang
  # with "msg timeout" errors. The modem doesn't work anyway (FCC unlock issue).
  # boot.blacklistedKernelModules = [ "iosm" ];
  # Note: blacklisting the module breaks the fingeprint Reader
  # => Deactivated Wireless WAN in BIOS settings 

  # exclude WWAN from Powersave 
  # see https://wiki.archlinux.org/title/Lenovo_ThinkPad_X1_Carbon_(Gen_10)
  #services.tlp.settings = {
  #  RUNTIME_PM_DENYLIST="08:00.0";
  #};

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


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  # Additional Entries for /etc/hosts
  #networking.extraHosts =
  #  ''
  #    127.0.0.1 some.host.net
  #  '';

}


