{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-compete";
  version = "0.10.7";

  src = fetchFromGitHub {
    owner = "qryxip";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-qlRVHSUVOqdTx4H3pE19Fy634742veTisHm6IqfKBUQ=";
  };

  cargoHash = "sha256-lid1tyR8Y6lvjpeGJ4vGzqDTY6V2y/5rL9fGyjyF3yw=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  doCheck = false;

  meta = {
    description = " A Cargo subcommand for competitive programming";
    homepage = "https://github.com/qryxip/cargo-compete";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = [ ];
  };
}
