{
  description = "Reproducible dev environment flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.03";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs, ... }@inputs: {

    nixosConfigurations = {
      xenia = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ (import ./configuration.nix) ];
        specialArgs = { inherit inputs; };
      };
    };

    xenia = self.nixosConfigurations.xenia.config.system.build.toplevel;

  };
}
