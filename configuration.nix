{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-20.09";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, nixos-unstable, home-manager, ... }@inputs: {
    nixosConfigurations.fedora = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      modules = [
        (nixpkgs.nixosModules.notDetected)
        (nixos-hardware.nixosModules.lenovo-thinkpad-t430)
        (let
          overlay-unstable = final: prev: {
            unstable = nixos-unstable.legacyPackages.${system};
          };
         in { nixpkgs.overlays = [ overlay-unstable ]; })
        (./configuration.nix)
      ];
      specialArgs = { inherit inputs; };
    };
  };
}
