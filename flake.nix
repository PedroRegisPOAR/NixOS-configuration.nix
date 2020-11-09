{
  inputs = { unstable.url = github:NixOS/nixpkgs-channels/nixos-unstable; };

  outputs = inputs: {
    defaultPackage.x86_64-linux = import ./configuration.nix { npkgs = inputs.unstable; };
  };

}
