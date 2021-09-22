{ strapi-src, yarn2nix-moretea, stdenv }:

yarn2nix-moretea.mkYarnWorkspace {
  #src = strapi-src;
  src = stdenv.mkDerivation {
    name = "strapi-src";
    src = strapi-src;

    phases = [ "unpackPhase" "patchPhase" "installPhase" ];

    patches = [
      ./file.patch
    ];

    unpackPhase = ''
      cp -r $src/* .
      chmod -R a+w .
    '';

    installPhase = ''
      cp -r . $out
    '';
  };
}
