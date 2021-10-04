{
  description = "waasabi flake";

  inputs.nixpkgs.url = "nixpkgs/nixos-unstable-small";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.napalm.url = "github:nix-community/napalm";
  inputs.napalm.inputs.nixpkgs.follows = "nixpkgs";

  inputs.strapi-src.url = "github:strapi/strapi/v3.6.8";
  inputs.strapi-src.flake = false;

  inputs.template-src.url = "github:baytechc/strapi-template-waasabi";
  inputs.template-src.flake = false;

  inputs.frontend-src.url = "github:baytechc/waasabi-live";
  inputs.frontend-src.flake = false;

  outputs = { self, nixpkgs, flake-utils, napalm, strapi-src, template-src, frontend-src }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs { inherit system; overlays = [ napalm.overlay self.overlay ]; };
        in
        {
          packages = {
            inherit (pkgs) create-strapi-app waasabi-backend waasabi-live;
          };
        })
  // {
    overlay = final: prev:
    let
      strapiWorkspace = final.callPackage ./packages/strapi { inherit strapi-src; };
    in
    {
      esbuild-0_12_9 = final.callPackage ./packages/esbuild-0.12.9 { };

      inherit (strapiWorkspace) create-strapi-app;
      waasabi-backend = final.callPackage ./packages/waasabi-backend { inherit template-src; };
      waasabi-live = final.callPackage ./packages/waasabi-live { inherit frontend-src; };
    };

    nixosModule = { ... }:
      {
        imports = builtins.attrValues self.nixosModules;
      };

    nixosModules = {
      waasabi-live = import ./modules/waasabi-live.nix;
    };
  };
}
