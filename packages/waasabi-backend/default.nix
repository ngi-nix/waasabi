{ template-src, create-strapi-app, stdenv, breakpointHook, yarn, mkYarnPackage }:

mkYarnPackage {
  yarnLock = ./yarn.lock;
  src = stdenv.mkDerivation {
    pname = "waasabi-backend";
    version = "1.0";

    nativeBuildInputs = [ yarn breakpointHook ];

    unpackPhase = "true";
    buildPhase = ''
      cp -r ${create-strapi-app} tmp/
      chmod -R a+w tmp/

      ./tmp/bin/create-strapi-app \
        backend/ \
        --no-run \
        --template file://${template-src} \
        --dbclient postgres \
        --dbhost localhost \
        --dbport 5432 \
        --dbname public \
        --dbusername test \
        --dbpassword test \
        --quickstart || true
    '';
    installPhase = ''
      cp -r backend/ $out
    '';
  };
}
