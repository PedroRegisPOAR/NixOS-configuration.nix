{

#  inputs = { unstable.url = github:NixOS/nixpkgs-channels/nixos-unstable; };

#  outputs = inputs: {
#    defaultPackage.x86_64-linux = import ./configuration.nix { npkgs = inputs.unstable; };
#  };

#  outputs = { self, nixpkgs }: {
#     # replace 'pedro' with your hostname here.
#     nixosConfigurations.pedro = nixpkgs.lib.nixosSystem {
#       system = "x86_64-linux";
#       modules = [ ./configuration.nix ];
#     };
#  };

  outputs = { nixpkgs, ... }: {

    packages.x86_64-linux = nixpkgs.system.legacyPackages.x86_64-linux;

    nixosConfigurations.mymachine = nixpkgs.lib.nixosSystem {
      modules = [
        # Point this to your original configuration.
        ./configuration.nix
      ];
      # Select the target system here.
      system = "x86_64-linux";
    };
  };

}

