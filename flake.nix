{
  description = "Chris's NixOS Configuration Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, lanzaboote, nixos-wsl, home-manager, ... }@inputs: {
    nixosConfigurations = {
      # Desktop/Laptop configurations
      void-carbonx1 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [

          ./hosts/void-carbonx1.nix
          ./hosts/void-carbonx1-hardware.nix

          ./user/chris.nix

          ./shared/base.nix
          ./shared/docker.nix
          ./shared/lanzaboote.nix
          ./shared/powermgmt.nix
          ./shared/virtualbox.nix
          ./shared/yubikey.nix

          ./desktop/base.nix
          ./desktop/gaming.nix
          ./desktop/hyprland.nix
          ./desktop/kde.nix
          ./desktop/lydm.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }

        ];
      };

      void-yoga = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [

          ./hosts/void-yoga.nix
          ./hosts/void-yoga-hardware.nix

          ./user/chris.nix

          ./shared/base.nix
          ./shared/docker.nix
          ./shared/powermgmt.nix
          ./shared/yubikey.nix

          ./desktop/base.nix
          ./desktop/hyprland.nix
          ./desktop/kde.nix
          ./desktop/lydm.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }

        ];
      };

      # WSL configuration
      adesso-wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [

          ./hosts/adesso-wsl.nix

          ./user/chris.nix
          
          ./shared/base.nix
          ./shared/docker.nix
          
          ./desktop/base.nix

          nixos-wsl.nixosModules.wsl
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }

        ];
      };
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
        echo "  - void-carbonx1"
        echo "  - void-yoga" 
        echo "  - adesso-wsl"
      '';
    };
  };
}
