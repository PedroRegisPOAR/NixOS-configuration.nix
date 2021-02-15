{
  outputs = { self, nixpkgs }: {
     nixosConfigurations.pedro-desktop = nixpkgs.lib.nixosSystem {
       system = "x86_64-linux";
       modules = [ ./configuration.nix ];
     };
  };
}

