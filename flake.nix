{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs-channels/nixos-unstable;
    # nur.url = github:nix-community/NUR;
  };

  outputs = { nixpkgs, nix, self, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [ (import ./configuration.nix) ];
      # specialArgs = { inherit inputs; };
    };
   packages.x86_64-linux.nixpkgs-review = import ./. { 
     nixpkgs = nixpkgs.legacyPackages.x86_64-linux;
   };

   defaultPackage.x86_64-linux = self.packages.x86_64-linux.nixpkgs-review;
  };
}
