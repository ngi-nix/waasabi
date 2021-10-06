{
  napalm,
  writeTextFile,
  esbuild-0_12_9,
  frontend-src,

  waasabiConfig ? {
    prefix = "";
    brand = "placeholder";
    urlBackend = "http://localhost";
    urlGraphQL = "wss://localhost/graphql";
    urlSession = "";

    chatEnabled = true;
    chatSystem = "matrix";
    chatInvites = false;
    chatUrl = "https://matrix.to/";

    matrixClient = "https://app.element.io/";
    matrixApi = "https://matrix.org/_matrix/";
  },
}:

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
        PREFIX: '${waasabiConfig.prefix}',
        BUILD_DIR: '_site/',
        WAASABI_BRAND: '${waasabiConfig.brand}',
        WAASABI_BACKEND: '${waasabiConfig.urlBackend}',
        WAASABI_GRAPHQL_WS: '${waasabiConfig.urlGraphQL}',
        WAASABI_SESSION_URL: '${waasabiConfig.urlSession}',
        WAASABI_CHAT_ENABLED: ${if waasabiConfig.chatEnabled then "true" else "false"},
        WAASABI_CHAT_SYSTEM: '${waasabiConfig.chatSystem}',
        WAASABI_CHAT_INVITES: ${if waasabiConfig.chatInvites then "true" else "false"},
        WAASABI_CHAT_URL: '${waasabiConfig.chatUrl}',
        WAASABI_MATRIX_CLIENT: '${waasabiConfig.matrixClient}',
        WAASABI_MATRIX_API: '${waasabiConfig.matrixApi}',
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
