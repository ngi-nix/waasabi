{
  description = "waasabi flake";

  inputs.nixpkgs.url = "nixpkgs/nixos-unstable-small";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs { inherit system; overlays = [ self.overlay ]; };
        in
        {
        })
  // {
    overlay = final: prev: {

    };
  };
}
