{ napalm, writeTextFile, esbuild-0_12_9, frontend-src }:

napalm.buildPackage frontend-src {
  preBuild = ''
    echo Putting esbuild-0.12.9 into the right place
    mkdir -p esbuild/bin
    export XDG_CACHE_HOME=$PWD
    cp ${esbuild-0_12_9}/bin/esbuild esbuild/bin/esbuild-linux-64@${esbuild-0_12_9.version}

    cp $waasabiConfig src/config.js

    patchShebangs ./scripts
  '';

  waasabiConfig = writeTextFile {
    name = "config.js";
    text = "
      export default {
        PREFIX: '',
        BUILD_DIR: '_site/',
        WAASABI_BRAND: 'placeholder',
        WAASABI_BACKEND: 'http://localhost',
        WAASABI_GRAPHQL_WS: 'wss://localhost/graphql',
        WAASABI_SESSION_URL: ' ',
        WAASABI_CHAT_ENABLED: true,
        WAASABI_CHAT_SYSTEM: 'matrix',
        WAASABI_CHAT_INVITES: false,
        WAASABI_CHAT_URL: 'https://matrix.to/',
        WAASABI_MATRIX_CLIENT: 'https://app.element.io/',
        WAASABI_MATRIX_API: 'https://matrix.org/_matrix/',
      }
    ";
  };

  npmCommands = [
    "npm install --loglevel verbose"
    "npm run build --loglevel verbose"
  ];

  installPhase = ''
    cp -r _site $out
  '';
}
