{
  lib,
  vimUtils,
  fetchFromGitHub,
}:

vimUtils.buildVimPlugin {
  pname = "vim-translator";
  version = "unstable-2026-08-23";

  src = fetchFromGitHub {
    owner = "voldikss";
    repo = "vim-translator";
    rev = "67457d5ab92a9d022f466df7e4a578a129207aa2";
    hash = "sha256-mcuAQbHYe41NWab+hA+XLeqhSGH1ORchF4mWNvnlve4=";
  };

  meta = with lib; {
    description = ":closed_book: Translating plugin for Vim/Neovim";
    homepage = "https://github.com/voldikss/vim-translator";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
