{ lib, stdenv, dpkg, autoPatchelfHook, cups }:

stdenv.mkDerivation {
  pname = "evolis-printer-driver";
  version = "4.12.8.8";

  src = ./evolisprinter-4.12.8.8.amd64.deb;

  nativeBuildInputs = [ dpkg autoPatchelfHook ];
  buildInputs = [ cups ];

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  installPhase = ''
    install -Dm755 usr/lib/cups/filter/rastertoevolis $out/lib/cups/filter/rastertoevolis
    install -Dm644 usr/share/cups/model/*.ppd.gz -t $out/share/cups/model/
  '';

  meta = {
    description = "Evolis card printer CUPS driver";
    homepage = "https://www.evolis.com";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
