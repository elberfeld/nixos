{ config, lib, pkgs, inputs, ... }:

{

  # Die von nixos-unstable ausgelieferte opencode-Version 2.2.5 bricht beim
  # Build mit "hash mismatch in fixed-output derivation" ab: `bun install`
  # erzeugt fuer die Node-Modules inzwischen einen anderen Inhalt als der in
  # nixpkgs hinterlegte outputHash. Upstream hat den Hash bereits korrigiert
  # (NixOS/nixpkgs, Commit c399e1b7fb "opencode: fix hash"); hier wird derselbe
  # Wert vorweggenommen, bis die Korrektur in nixos-unstable ankommt.
  # opencode-desktop erbt die node_modules von opencode und ist damit mitbehoben.
  nixpkgs.overlays = [
    (final: prev: {
      opencode = prev.opencode.overrideAttrs (old: {
        node_modules = old.node_modules.overrideAttrs (nm: {
          outputHash =
            if prev.stdenv.hostPlatform.isLinux then
              "sha256-prx9dX7kUvs/E3zopkaPk5LXh3xJAy5sZeum/W8L7cA="
            else
              nm.outputHash;
        });
      });
    })
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

    claude-code
    inputs.claude-desktop.packages.${pkgs.stdenv.hostPlatform.system}.claude-desktop-fhs
    drawio
    git
    opencode
    opencode-desktop
    python3
    vscode 
    vscodium
    wireshark
    zenmap

  ];
  
}
