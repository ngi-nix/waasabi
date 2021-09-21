{ strapi-src, yarn2nix-moretea }:

yarn2nix-moretea.mkYarnWorkspace {
  src = strapi-src;
}
