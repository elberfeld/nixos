{ config, pkgs, ... }:

{

  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      ./desktop/base.nix
      ./desktop/kde.nix
      ./desktop/hyprland.nix
      ./desktop/sddm.nix
      ./shared/base.nix
      ./shared/libvirt-kvm.nix
      ./shared/powermgmt.nix
      ./shared/yubikey.nix
      ./user/chris.nix
    ];

  # Bootloader Settimgs
  boot.loader.efi.canTouchEfiVariables = true;

  # Use Systemd-Boot
  boot.loader.systemd-boot = { 
    enable = true;
    editor = false;
#    consoleMode = "1";
    consoleMode = "max";
  };

  # Graphical boot scren 
  #boot.initrd.systemd.enable = true;
  #boot.plymouth.enable = true;
  #boot.plymouth.theme = "breeze";

  # Enable swap on luks
  boot.initrd.luks.devices."luks-1151810a-9681-4ea5-8c74-1e3886f7a091".device = "/dev/disk/by-uuid/1151810a-9681-4ea5-8c74-1e3886f7a091";
  boot.initrd.luks.devices."luks-1151810a-9681-4ea5-8c74-1e3886f7a091".keyFile = "/crypto_keyfile.bin";

  # Hostname
  networking.hostName = "void-yoga"; 

  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true; 

  # Enable OpenGL 
  hardware.opengl.enable = true;

  # Enable Touchpad Support inX11/Wayland
  services.xserver.libinput.enable = true;

  # vscode: to enable sudo commands in vscode terminal, run: code --no-sandbox

  environment.systemPackages = with pkgs; [

    direnv
    hamsket
    keepassxc
    microsoft-edge
    neovim
    nextcloud-client
    remmina
    signal-desktop
    teams-for-linux
    ungoogled-chromium
    vscode 
    yubikey-manager-qt
    zettlr

  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}


