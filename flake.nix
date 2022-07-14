{

  description = "Configuration for my NixOS system";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-22.05"; };
    nixos-unstable = { url = "github:nixos/nixpkgs/nixos-unstable"; };
  };

  outputs = { self, nixpkgs, nixos-unstable }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };
    
    in {
       nixosConfigurations.pedroregispoar= nixpkgs.lib.nixosSystem {
         inherit system;
         modules = [
                   ./configuration.nix

                   # Provide an initial copy of the NixOS channel so that the user
                   # doesn't need to run "nix-channel --update" first.
                   # "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"

                   # For virtualisation settings.
                   # It brings among other things the `.vm` attr need for 
                   # (nixpkgs + "/nixos/modules/virtualisation/qemu-vm.nix")
                 ];
          # specialArgs = {
          #  pkgs = pkgs;
          #  nixos-unstable = nixos-unstable.legacyPackages;
          # };
        };     
      };
}

