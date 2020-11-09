{
  inputs = rec {
        stable.url = "github:NixOS/nixpkgs/nixos-20.03";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:rycee/home-manager";
      inputs.nixpkgs.follows = "stable";
    };
    # nur.url = "github:nix-community/NUR";
    emacs.url = "github:nix-community/emacs-overlay";
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    nix-direnv = {
      url = "github:nix-community/nix-direnv";
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
