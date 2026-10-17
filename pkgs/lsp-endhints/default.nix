{
  lib,
  vimUtils,
  fetchFromGitHub,
}:

vimUtils.buildVimPlugin {
  pname = "lsp-endhints";
  version = "unstable-2026-08-03";

  src = fetchFromGitHub {
    owner = "chrisgrieser";
    repo = "nvim-lsp-endhints";
    rev = "3224a1c1b2fe1b067049764a154d4d727425fa6d";
    hash = "sha256-OYINp7BgZ108BnGGAiB9teis9TRIw4C+afX9rvByt2Q=";
  };

  meta = with lib; {
    description = "Display LSP inlay hints at the end of the line, rather than within the line.";
    homepage = "https://github.com/chrisgrieser/nvim-lsp-endhints";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
