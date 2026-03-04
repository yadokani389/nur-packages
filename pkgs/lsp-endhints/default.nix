{
  lib,
  vimUtils,
  fetchFromGitHub,
}:

vimUtils.buildVimPlugin {
  pname = "lsp-endhints";
  version = "unstable-2026-02-06";

  src = fetchFromGitHub {
    owner = "chrisgrieser";
    repo = "nvim-lsp-endhints";
    rev = "9b210f760fe8bde5f335f2660ccb2bf19aabad68";
    hash = "sha256-4NSQLw/MW6kJO+3eMuE5FFyWRsOiAEQcfQ/rM3gPGIw=";
  };

  meta = with lib; {
    description = "Display LSP inlay hints at the end of the line, rather than within the line.";
    homepage = "https://github.com/chrisgrieser/nvim-lsp-endhints";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
