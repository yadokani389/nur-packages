{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "sptlrx-ex";
  version = "unstable-2026-04-30";

  src = fetchFromGitHub {
    owner = "yadokani389";
    repo = pname;
    rev = "61bf347bfaaa602d6573c045545a03fd9a24925d";
    hash = "sha256-t7T7xKfPlyrGFCGiOM6P9fckmmxDEwQgrXPvcXcGLiI=";
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
