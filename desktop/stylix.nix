{ config, lib, pkgs, inputs, ... }:

{
  # Stylix Configuration 
  # see https://nix-community.github.io/stylix/configuration.html

  stylix.enable = true;

  #stylix.image = ./wallpaper.png;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/argonaut.yaml";
}
