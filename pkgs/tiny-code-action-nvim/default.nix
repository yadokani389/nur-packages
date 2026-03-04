{
  lib,
  vimUtils,
  fetchFromGitHub,
  vimPlugins,
}:

vimUtils.buildVimPlugin {
  pname = "tiny-code-action-nvim";
  version = "unstable-2026-02-25";

  src = fetchFromGitHub {
    owner = "rachartier";
    repo = "tiny-code-action.nvim";
    rev = "8e72efa075ba3154bbc4c7d1db532b03b4e68373";
    hash = "sha256-PAwpKpvPOJuqN6XNWSQTQ14XF3aalZ2HXqx2mugzC5I=";
  };

  dependencies = with vimPlugins; [
    telescope-nvim
    plenary-nvim
    snacks-nvim
  ];

  meta = with lib; {
    description = "A Neovim plugin that provides a simple way to run and visualize code actions with Telescope.";
    homepage = "https://github.com/rachartier/tiny-code-action.nvim";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
