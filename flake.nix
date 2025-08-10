{
  description = "Chris's NixOS Configuration Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-wsl, home-manager, ... }@inputs: {
    nixosConfigurations = {
      # Desktop/Laptop configurations
      void-carbonx1 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
          ./hosts/void-carbonx1.nix
          ./shared/base.nix
          ./desktop/base.nix
          ./desktop/kde.nix
          ./desktop/lydm.nix
          ./shared/docker.nix
          ./shared/powermgmt.nix
          ./shared/virtualbox.nix
          ./shared/yubikey.nix
          ./user/chris.nix
        ];
      };

      void-yoga = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
          ./hosts/void-yoga.nix
          ./shared/base.nix
          ./desktop/base.nix
          ./desktop/kde.nix
          ./desktop/hyprland.nix
          ./desktop/sddm.nix
          ./shared/docker.nix
          ./shared/libvirt-kvm.nix
          ./shared/powermgmt.nix
          ./shared/yubikey.nix
          ./user/chris.nix
        ];
      };

      # WSL configuration
      adesso-wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          nixos-wsl.nixosModules.wsl
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
          ./hosts/adesso-wsl.nix
          ./shared/base.nix
          ./shared/docker.nix
          ./desktop/base.nix
          ./user/chris.nix
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
