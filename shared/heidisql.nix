{ config, pkgs, ... }:

let
  # NixOS hat kein /sbin/ldconfig. HeidiSQL ruft auf Linux aber genau diesen Pfad
  # auf, um verfügbare DB-Clientbibliotheken zu entdecken (ldconfig -p). Ohne diesen
  # Shim bleibt die Bibliotheksauswahl in den Session-Einstellungen leer.
  heidisqlLdconfig = pkgs.writeShellScriptBin "ldconfig" ''
    if [ "$1" = "-p" ]; then
      echo "6 libs found in cache '/etc/ld.so.cache'"
      printf '\tlibmariadb.so.3 (libc6,x86-64) => %s\n' "${pkgs.mariadb-connector-c}/lib/mariadb/libmariadb.so.3"
      printf '\tlibmysqlclient.so (libc6,x86-64) => %s\n' "${pkgs.mariadb-connector-c}/lib/mariadb/libmysqlclient.so"
      printf '\tlibpq.so.5 (libc6,x86-64) => %s\n' "${pkgs.postgresql.lib}/lib/libpq.so.5"
      printf '\tlibpq.so (libc6,x86-64) => %s\n' "${pkgs.postgresql.lib}/lib/libpq.so"
      printf '\tlibsqlite3.so.0 (libc6,x86-64) => %s\n' "${pkgs.sqlite.out}/lib/libsqlite3.so.0"
      printf '\tlibsqlite3.so (libc6,x86-64) => %s\n' "${pkgs.sqlite.out}/lib/libsqlite3.so"
      exit 0
    fi

    exec ${pkgs.glibc.bin}/bin/ldconfig "$@"
  '';

  heidisql = pkgs.stdenv.mkDerivation rec {
    pname = "heidisql";
    version = "12.16";

    src = pkgs.fetchurl {
      url = "https://github.com/HeidiSQL/HeidiSQL/releases/download/v${version}/build-qt6-v${version}.tgz";
      sha256 = "1hxlc0w2j662xhd7prbn3qlgrc2c5lfin7by8sa9mw8kwn9axbb8";
    };

    sourceRoot = ".";

    nativeBuildInputs = with pkgs; [
      autoPatchelfHook
      copyDesktopItems
      makeWrapper
    ];

    buildInputs = with pkgs; [
      qt6Packages.libqtpas
      xorg.libX11
    ];

    runtimeLibs = with pkgs; [
      qt6Packages.libqtpas
      xorg.libX11
      stdenv.cc.cc.lib
      zlib
      mariadb-connector-c
      libmysqlclient
      postgresql.lib
      sqlite
      openssl
    ];

    desktopItems = [
      (pkgs.makeDesktopItem {
        name = "heidisql";
        desktopName = "HeidiSQL";
        exec = "heidisql";
        icon = "heidisql";
        comment = "Database management for MySQL, MariaDB, PostgreSQL, SQLite and MS SQL Server";
        categories = [ "Development" "Database" ];
      })
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib/heidisql
      cp -r heidisql functions-*.ini locale LICENSE README.md $out/lib/heidisql/

      # DB-Clientbibliotheken ins App-Verzeichnis kopieren (.so + .dll-Aliase).
      cp -L ${pkgs.mariadb-connector-c}/lib/mariadb/libmariadb.so.3 $out/lib/heidisql/libmariadb.so.3
      cp -L ${pkgs.mariadb-connector-c}/lib/mariadb/libmariadb.so   $out/lib/heidisql/libmariadb.so
      cp -L ${pkgs.mariadb-connector-c}/lib/mariadb/libmysqlclient.so $out/lib/heidisql/libmysqlclient.so
      cp -L ${pkgs.postgresql.lib}/lib/libpq.so.5                   $out/lib/heidisql/libpq.so.5
      cp -L ${pkgs.postgresql.lib}/lib/libpq.so                     $out/lib/heidisql/libpq.so
      cp -L ${pkgs.sqlite.out}/lib/libsqlite3.so.0                  $out/lib/heidisql/libsqlite3.so.0
      cp -L ${pkgs.sqlite.out}/lib/libsqlite3.so                    $out/lib/heidisql/libsqlite3.so
      cp -L ${pkgs.mariadb-connector-c}/lib/mariadb/libmariadb.so   $out/lib/heidisql/libmariadb.dll
      cp -L ${pkgs.mariadb-connector-c}/lib/mariadb/libmysqlclient.so $out/lib/heidisql/libmysql.dll
      cp -L ${pkgs.postgresql.lib}/lib/libpq.so                     $out/lib/heidisql/libpq.dll
      cp -L ${pkgs.sqlite.out}/lib/libsqlite3.so                    $out/lib/heidisql/sqlite3.dll

      # Install icon
      mkdir -p $out/share/icons/hicolor/256x256/apps
      cp heidisql.png $out/share/icons/hicolor/256x256/apps/heidisql.png

      # Wrapper setzt LD_LIBRARY_PATH, damit die kopierten Libs beim Start gefunden werden.
      mkdir -p $out/bin
      makeWrapper $out/lib/heidisql/heidisql $out/bin/heidisql \
        --prefix LD_LIBRARY_PATH : "$out/lib/heidisql:${pkgs.lib.makeLibraryPath runtimeLibs}:${pkgs.mariadb-connector-c}/lib/mariadb"

      runHook postInstall
    '';

    meta = with pkgs.lib; {
      description = "Lightweight, fast database client for MySQL, MariaDB, PostgreSQL, SQLite, and MS SQL Server";
      homepage = "https://www.heidisql.com/";
      license = licenses.gpl2;
      platforms = [ "x86_64-linux" ];
    };
  };
in
{
  environment.systemPackages = with pkgs; [
    heidisql
    heidisqlLdconfig
    mariadb-connector-c
    libmysqlclient
    postgresql.lib
    sqlite
  ];

  # /sbin/ldconfig auf den Shim verlinken, da HeidiSQL diesen Pfad hart kodiert.
  systemd.tmpfiles.rules = [
    "L+ /sbin/ldconfig - - - - ${heidisqlLdconfig}/bin/ldconfig"
  ];
}
