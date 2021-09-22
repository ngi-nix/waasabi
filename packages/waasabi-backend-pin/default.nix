{ writeShellScriptBin, create-strapi-app, template-src, nixUnstable, yarn }:

writeShellScriptBin "waasabi-pin" ''
  template=$(mktemp -d)
  cp -r ${create-strapi-app}/* $template
  chmod -R a+w $template

  ${nixUnstable}/bin/nix shell nixpkgs#yarn -c $template/bin/create-strapi-app \
    $template/backend/ \
    --no-run \
    --template file://${template-src} \
    --dbclient postgres \
    --dbhost localhost \
    --dbport 5432 \
    --dbname public \
    --dbusername test \
    --dbpassword test \
    --quickstart

  currentPWD=$PWD
  cd $template/backend
  ${yarn}/bin/yarn install
  cd $currentPWD
  cp $template/backend/yarn.lock .
''
