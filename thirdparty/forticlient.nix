{ config, pkgs, lib, ... }:

let
  forticlientPkg = pkgs.stdenv.mkDerivation rec {
    pname = "forticlient";
    version = "7.2.14.1042";

    src = pkgs.fetchurl {
      url = "https://ems.webdiscount.net:10443/installers/Default/WD-Intern-Linux/FortiClient_7.2.14.deb";
      hash = "sha256:c8eead6b8beafc30c1bb13746bf7f4853f6c9d694595f0a7cfbc5b476550699e";
    };

    nativeBuildInputs = with pkgs; [
      dpkg
      autoPatchelfHook
    ];

    buildInputs = with pkgs; [
      glib
      gtk3
      atk
      at-spi2-atk
      at-spi2-core
      cairo
      pango
      cups
      expat
      nspr
      nss
      libsecret
      systemd        # libudev1
      stdenv.cc.cc.lib
      libappindicator-gtk3
      alsa-lib        # libasound.so.2
      gtk2            # libgtk-x11-2.0.so.0 / libgdk-x11-2.0.so.0 (fortitray)
      libnotify       # libnotify.so.4
      libdrm          # libdrm.so.2
      mesa            # libgbm.so.1
      libx11
      libxcb
      libxcomposite
      libxcursor
      libxdamage
      libxext
      libxfixes
      libxi
      libxrandr
      libxrender
      libxscrnsaver
      libxtst
    ];

    # FortiClient enthält eigene .so-Dateien; fehlende System-Deps tolerieren
    autoPatchelfIgnoreMissingDeps = true;

    unpackPhase = ''
      dpkg-deb -x $src .
    '';

    # Eigene .so-Dateien aus /opt/forticlient als Suchpfad registrieren,
    # bevor autoPatchelfHook die ELF-Binaries patcht
    preFixup = ''
      addAutoPatchelfSearchPath $out/opt/forticlient
    '';

    installPhase = ''
      runHook preInstall

      # $out muss als Verzeichnis existieren bevor cp dorthin kopiert,
      # sonst wird opt/ direkt zu $out umbenannt (Pfade fehlen /opt-Prefix)
      mkdir -p $out
      cp -r opt $out/

      # Das .deb ist ein "repackaged" Installer: execute-Bits werden nicht
      # im Archiv gespeichert, sondern erst per setfacl in postinst aus .acl
      # wiederhergestellt. Auf NixOS erkennen wir ELF-Binaries und Scripts
      # und setzen das execute-Bit manuell.
      find $out/opt/forticlient -type f | while IFS= read -r f; do
        magic=$(od -An -tx1 -N4 "$f" 2>/dev/null | tr -d ' \n')
        if [[ "$magic" == 7f454c46* ]]; then
          chmod +x "$f"
        elif head -c2 "$f" 2>/dev/null | grep -q '^#!'; then
          chmod +x "$f"
        fi
      done

      # Systemd-Unit
      install -Dm644 lib/systemd/system/forticlient.service \
        $out/lib/systemd/system/forticlient.service

      # Desktop-Dateien
      install -Dm644 usr/share/applications/forticlient.desktop \
        $out/share/applications/forticlient.desktop
      install -Dm644 usr/share/applications/forticlient-register.desktop \
        $out/share/applications/forticlient-register.desktop

      # Icons
      for icon in usr/share/icons/hicolor/*/apps/forticlient.png; do
        size=$(echo "$icon" | cut -d/ -f4)
        install -Dm644 "$icon" \
          "$out/share/icons/hicolor/$size/apps/forticlient.png"
      done

      # Polkit-Actions
      install -Dm644 usr/share/polkit-1/actions/org.fortinet.forticlient.policy \
        $out/share/polkit-1/actions/org.fortinet.forticlient.policy
      install -Dm644 usr/share/polkit-1/actions/org.fortinet.fortitray.policy \
        $out/share/polkit-1/actions/org.fortinet.fortitray.policy

      # CLI-Symlink
      mkdir -p $out/bin
      ln -s $out/opt/forticlient/forticlient-cli $out/bin/forticlient

      runHook postInstall
    '';

    meta = {
      description = "FortiClient endpoint protection and SSL/IPsec VPN client";
      homepage = "https://www.forticlient.com";
      license = lib.licenses.unfree;
      platforms = [ "x86_64-linux" ];
      maintainers = [];
    };
  };

in
{
  environment.systemPackages = [ forticlientPkg ];

  # FortiClient erwartet seine Dateien unter /opt/forticlient
  systemd.tmpfiles.rules = [
    "L+ /opt/forticlient - - - - ${forticlientPkg}/opt/forticlient"
    "d  /etc/forticlient      0755 root root -"
    "d  /var/lib/forticlient  0755 root root -"
  ];

  # Initiale config.db anlegen, falls noch nicht vorhanden
  system.activationScripts.forticlient-init-db = ''
    if [ ! -f /var/lib/forticlient/config.db ]; then
      mkdir -p /var/lib/forticlient
      cp ${forticlientPkg}/opt/forticlient/.config.db.init \
         /var/lib/forticlient/config.db
      chmod 600 /var/lib/forticlient/config.db
    fi
  '';

  # Systemd-Dienst (entspricht der Unit aus dem .deb)
  systemd.services.forticlient = {
    description = "FortiClient Scheduler";
    requires = [ "dbus.service" ];
    wants    = [ "dbus.service" ];
    after    = [ "dbus.service" "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type       = "simple";
      ExecStart  = "/opt/forticlient/fctsched";
      User       = "root";
      ExecReload = "${pkgs.util-linux}/bin/kill -HUP $MAINPID";
      Restart    = "always";
      RestartSec = "5s";
      StartLimitIntervalSec = 300;
      StartLimitBurst       = 30;
      KillMode   = "mixed";
    };
  };

  # Polkit-Regeln aus dem Paket einbinden
  security.polkit.enable = lib.mkDefault true;

  # TUN-Kernelmodul für VPN
  boot.kernelModules = [ "tun" ];

  # Unfree-Pakete erlauben
  nixpkgs.config.allowUnfree = lib.mkDefault true;
}
