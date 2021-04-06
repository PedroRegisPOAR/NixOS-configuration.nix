{
  outputs = { self, nixpkgs }: {
     nixosConfigurations.pedroregispoar = nixpkgs.lib.nixosSystem {
       system = "x86_64-linux";
       modules = [ ./configuration.nix ];
     };
  };
}

