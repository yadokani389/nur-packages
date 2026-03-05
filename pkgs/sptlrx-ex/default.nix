{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "sptlrx-ex";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "yadokani389";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-kEi2pnzuUyWx+plKjw0ULSHbt0/+unnLM6iY1N7kwl8=";
  };

  cargoHash = "sha256-v4nWSGUv6rkLtZGIj8QmTJRerKfgQnOb/OrIhq7YyNw=";

  meta = {
    description = "Relay synced Spotify Web Player lyrics to your local terminal";
    homepage = "https://github.com/yadokani389/sptlrx-ex";
    license = with lib.licenses; [
      asl20
      mit
    ];
    mainProgram = "sptlrx-ex";
  };
}
