{
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
}
