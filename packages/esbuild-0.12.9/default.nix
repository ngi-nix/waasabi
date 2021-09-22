{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "esbuild";
  version = "0.12.9";

  src = fetchFromGitHub {
    owner = "evanw";
    repo = "esbuild";
    rev = "v${version}";
    sha256 = "sha256-MqwgdhgWIfYE0wO7fWQuC72tEwCVgL7qUbJlJ3APf4E=";
  };

  vendorSha256 = "sha256-2ABWPqhK2Cf4ipQH7XvRrd+ZscJhYPc3SV2cGT0apdg=";
}
