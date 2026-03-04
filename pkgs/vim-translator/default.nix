{
  vimUtils,
  fetchFromGitHub,
}:

vimUtils.buildVimPlugin {
  pname = "vim-translator";
  version = "unstable-2023-05-25";

  src = fetchFromGitHub {
    owner = "voldikss";
    repo = "vim-translator";
    rev = "6f0639c6d471a3a90ac19db96e1e379c030f74e3";
    hash = "sha256-ow5axYMtH433hXwYF5Oz3wWT/24VUHpALrH+Phlwk90=";
  };
}
