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

  # NOTE: A previous attempt at a systemd-sleep hook that unloaded/reloaded
  # intel_ipu6_isys/intel_ipu6_psys/ov2740/intel_ipu6 around suspend/hibernate
  # was tried here to work around a post-resume camera crash (see git history),
  # but it caused a WORSE regression: modprobe -r only ever succeeded for the
  # unreferenced intel_ipu6_psys module, while intel_ipu6_isys/ov2740/intel_ipu6
  # stayed loaded (busy, still referenced by WirePlumber's camera monitor).
  # That left the IPU6 driver stack in a half-torn-down state right before the
  # kernel tried to freeze devices for hibernation, which hung the machine
  # completely (no image ever written, hard reset required). Do not re-add
  # this kind of hook without first ensuring ALL dependent modules/handles are
  # actually released (e.g. stop wireplumber or anything with an open
  # /dev/video* fd) before attempting to unload the driver.

}
