{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-compete";
  version = "unstable-2026-04-19";

  src = fetchFromGitHub {
    owner = "yadokani389";
    repo = pname;
    rev = "fdca38e9a78825cff0887981eb7a16b5b9d35081";
    hash = "sha256-BhmWrunYqipzT8FcYRhM3PJ2dYIOIczm6pVOG55UNpA=";
  };

  cargoHash = "sha256-S7H3+i4S+mBoTtHLJqSdijJ408qG4sgOtu6uz3hQOkQ=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  doCheck = false;

  meta = {
    description = "A Cargo subcommand for competitive programming";
    homepage = "https://github.com/qryxip/cargo-compete";
    license = with lib.licenses; [
      asl20
      mit
    ];
    mainProgram = "cargo-compete";
    platforms = lib.platforms.all;
  };
}
