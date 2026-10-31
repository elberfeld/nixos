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

    # Hide the 32 raw IPU6 ISYS capture nodes (/dev/video0-31, all called "ipu6")
    # from udev based V4L2 enumeration, e.g. GStreamer's v4l2deviceprovider
    # used by Kamoso/Cheese, which only lists devices with ID_V4L_VERSION=2.
    # The nodes are unusable on their own, the camera only works through
    # libcamera/PipeWire. libcamera finds them via the media controller.
    SUBSYSTEM=="video4linux", ATTR{name}=="Intel IPU6 ISYS Capture*", ENV{ID_V4L_VERSION}=""
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

  # The camera is only available via PipeWire, so apps have to use PipeWire
  # instead of accessing V4L2 directly
  nixpkgs.overlays = [
    (final: prev: {
      # Chromium only honors the last --enable-features switch and the wrapper
      # already passes --enable-features=WaylandWindowDecorations for
      # NIXOS_OZONE_WL before commandLineArgs, so repeat that feature here
      chromium = prev.chromium.override {
        commandLineArgs = "--enable-features=WaylandWindowDecorations,WebRtcPipeWireCamera";
      };

      firefox = prev.firefox.override {
        extraPrefs = ''
          pref("media.webrtc.camera.allow-pipewire", true);
        '';
      };

      # Kamoso is only wrapped with the V4L2 GStreamer plugins,
      # add the PipeWire plugin so it can see the camera
      kdePackages = prev.kdePackages.overrideScope (kfinal: kprev: {
        kamoso = final.symlinkJoin {
          inherit (kprev.kamoso) pname version meta;
          paths = [ kprev.kamoso ];
          nativeBuildInputs = [ final.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/kamoso \
              --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : ${final.pipewire}/lib/gstreamer-1.0
          '';
        };
      });
    })
  ];

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
