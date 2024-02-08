
# code from https://discourse.nixos.org/t/vscode-remote-wsl-extension-works-on-nixos-without-patching-thanks-to-nix-ld/14615

{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.nix-ld-config;
  ldEnv = {
    NIX_LD_LIBRARY_PATH = with pkgs; makeLibraryPath [
      stdenv.cc.cc
    ];
    NIX_LD = removeSuffix "\n" (builtins.readFile "${pkgs.stdenv.cc}/nix-support/dynamic-linker");
  };
  ldExports = mapAttrsToList (name: value: "export ${name}=${value}") ldEnv;
  joinedLdExports = concatStringsSep "\n" ldExports;
in
{
  options.nix-ld-config = {
    enable = mkEnableOption "nix-ld config module";
    user = mkOption {
      type = types.str;
      description = "The name of user you want to configure for using VSCode's Remote WSL extension.";
      default = "${cfg.user}";
    };
  };
  config = mkIf cfg.enable {
    environment.variables = ldEnv;
    home-manager.users.${cfg.user}.home.file.".vscode-server/server-env-setup".text = joinedLdExports;
  };
}


