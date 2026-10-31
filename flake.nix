{
  description = "Chris's NixOS Configuration Flake";

  # CachyOS-Kernel-Binary-Cache. Der alte Endpunkt
  # (https://attic.xuyh0120.win/lantian) ist nach einem Server-Kompromiss
  # abgeschaltet; ohne erreichbaren Cache wird der Kernel aus dem Quellcode
  # gebaut und sprengt den Speicherplatz des CI-Runners.
  nixConfig = {
    extra-substituters = [ "https://cache.lantian.pub/lantian" ];
    extra-trusted-public-keys = [ "lantian:WVGO7vsRMSEN+h7Lp7kv6SAmrkEXgUGbbXm7jMDjBuQ=" ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # CachyOS Kernel from https://github.com/xddxdd/nix-cachyos-kernel
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    claude-desktop = {
      url = "github:aaddrick/claude-desktop-debian";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-updater = {
      url = "github:elberfeld/nixos-updater";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-wsl, home-manager, ... }@inputs:
  let
    # Common setup for all hosts: flake inputs as module argument and
    # Home-Manager as NixOS module. The platform is set per host via
    # nixpkgs.hostPlatform in the host files.
    mkHost = modules: nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = modules ++ [
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];
    };
  in {
    nixosConfigurations = {

      # Desktop/Laptop configurations

      void-carbonx1 = mkHost [

        ./hosts/void-carbonx1.nix
        ./hosts/void-carbonx1-hardware.nix

        ./user/chris.nix

        ./hardware/mipi-ipu6-camera.nix
        ./hardware/tpm2-unlock.nix

        ./shared/base.nix
        ./shared/cachyos-kernel.nix
        ./shared/docker.nix
        ./shared/heidisql.nix
        ./shared/lanzaboote.nix
        ./shared/powermgmt.nix
        ./shared/physicalmachine.nix
        ./shared/virtualbox.nix

        ./desktop/base.nix
        ./desktop/devtools.nix
        ./desktop/distrobox.nix
        ./desktop/gaming.nix
        #./desktop/hyprland.nix
        ./desktop/kde.nix
        #./desktop/lydm.nix
        ./desktop/plasma-login-manager.nix
        #./desktop/sddm.nix

      ];

      void-desktop = mkHost [

        ./hosts/void-desktop.nix
        ./hosts/void-desktop-hardware.nix

        ./user/chris.nix

        ./hardware/nvidia_desktop.nix

        ./shared/base.nix
        ./shared/cachyos-kernel.nix
        ./shared/physicalmachine.nix

        ./desktop/base.nix
        ./desktop/gaming.nix
        ./desktop/kde.nix
        ./desktop/sddm.nix

      ];

      void-yoga = mkHost [

        ./hosts/void-yoga.nix
        ./hosts/void-yoga-hardware.nix

        ./user/chris.nix

        ./shared/base.nix
        ./shared/docker.nix
        ./shared/powermgmt.nix
        ./shared/physicalmachine.nix

        ./desktop/base.nix
        ./desktop/hyprland.nix
        ./desktop/kde.nix
        ./desktop/lydm.nix

      ];

      # WSL configuration
      adesso-wsl = mkHost [

        ./hosts/adesso-wsl.nix

        ./user/nixos.nix

        ./shared/base.nix

        nixos-wsl.nixosModules.wsl

      ];
    };

    # Development shell for managing the flake
    devShells.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.mkShell {
      buildInputs = with nixpkgs.legacyPackages.x86_64-linux; [
        nixos-rebuild
        git
        vim
        neovim
      ];

      shellHook = ''
        echo "NixOS Configuration Development Environment"
        echo "Available commands:"
        echo "  nixos-rebuild switch --flake .#<hostname>"
        echo "  nixos-rebuild test --flake .#<hostname>"
        echo "  nixos-rebuild boot --flake .#<hostname>"
        echo ""
        echo "Available configurations:"
        ${nixpkgs.lib.concatMapStrings (host: ''
          echo "  - ${host}"
        '') (builtins.attrNames self.nixosConfigurations)}
      '';
    };
  };
}
