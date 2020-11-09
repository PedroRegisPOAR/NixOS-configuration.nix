{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs-channels/nixos-unstable;
    # nur.url = github:nix-community/NUR;
  };

  outputs = { self, nixpkgs }: {
     # replace 'pedro' with your hostname here.
     nixosConfigurations.pedro = nixpkgs.lib.nixosSystem {
       system = "x86_64-linux";
       modules = [ ./configuration.nix ];
     };
  };
}
