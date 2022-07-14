{
  outputs = { self, nixpkgs }: {
     nixosConfigurations.pedroregispoar= nixpkgs.lib.nixosSystem {
       system = "x86_64-linux";
       modules = [
                   ./configuration.nix

                   # Provide an initial copy of the NixOS channel so that the user
                   # doesn't need to run "nix-channel --update" first.
                   # "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"

                   # For virtualisation settings.
                   # It brings among other things the `.vm` attr need for 
                   "${nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
                 ];
     };
          
  };
}

