{ config, pkgs, ... }:

{
  # MIPI/IPU6 Camera - see https://github.com/NixOS/nixpkgs/issues/225743
  # - https://github.com/NixOS/nixpkgs/issues/225743#issuecomment-3704117883

  hardware.firmware = with pkgs; [
    ipu6-camera-bins
    ivsc-firmware
  ];
    
  services.udev.extraRules = ''
    SUBSYSTEM=="intel-ipu6-psys", MODE="0660", GROUP="video"
  '';

  boot.extraModulePackages = with config.boot.kernelPackages; [ ipu6-drivers ];

  environment.systemPackages = with pkgs; [
    libcamera
  ];

  # https://jgrulich.cz/2024/08/19/making-pipewire-default-option-for-firefox-camera-handling/
  services.pipewire.wireplumber.extraConfig."disable-v4l2" = {
    "wireplumber.profiles" = {
      "main" = {"monitor.v4l2" = "disabled";};
    };
  };

}
