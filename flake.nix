{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs-channels/nixos-unstable;
    # nur.url = github:nix-community/NUR;

    # Modules
    hardware = {
      url = "github:NixOS/nixos-hardware";
      flake = false;
    };

  };

  outputs = { self, nixpkgs }: {
     # replace 'pedro' with your hostname here.
     nixosConfigurations.pedro = nixpkgs.lib.nixosSystem {
       system = "x86_64-linux";
       modules = [ ./configuration.nix ];
     };
  };
}
