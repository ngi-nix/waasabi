{
  description = "waasabi flake";

  inputs.nixpkgs.url = "nixpkgs/nixos-unstable-small";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  inputs.strapi-src.url = "github:strapi/strapi/v3.6.8";
  inputs.strapi-src.flake = false;

  inputs.template-src.url = "github:baytechc/strapi-template-waasabi";
  inputs.template-src.flake = false;

  outputs = { self, nixpkgs, flake-utils, strapi-src, template-src }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs { inherit system; overlays = [ self.overlay ]; };
        in
        {
          packages = {
            inherit (pkgs) create-strapi-app waasabi-backend;
          };
        })
  // {
    overlay = final: prev:
    let
      strapiWorkspace = final.callPackage ./packages/strapi { inherit strapi-src; };
    in
    {
      inherit (strapiWorkspace) create-strapi-app;
      waasabi-backend = final.callPackage ./packages/waasabi-backend { inherit template-src; };
    };
  };
}
