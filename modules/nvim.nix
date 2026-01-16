{ pkgs, lib, ... }:

let
  aura-theme = pkgs.vimUtils.buildVimPlugin {
    name = "aura-theme";
    src = pkgs.fetchFromGitHub {
      owner = "daltonmenezes";
      repo = "aura-theme";
      rev = "main";
      sparseCheckout = [
        "/packages/neovim"
      ];
      sha256 = "sha256-mU5rZkEycjmqiCDsKlrT1mgAnvmktG/lYvgUPRt+iiE=";
    } + "/packages/neovim";
  };
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraConfig = ''
      set number 
      set relativenumber

      set undofile

      set ignorecase
      set smartcase

      set splitright
      set splitbelow

      set whichwrap+=h,l,<,>,[,]
      set scrolloff=5

      set shiftwidth=2
      set tabstop=2
      set expandtab

      colorscheme aura-dark
    '';
    extraLuaConfig = ''
      require('mini.pairs').setup()
    '';
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      which-key-nvim
      aura-theme
      mini-nvim
      (nvim-treesitter.withPlugins (
        plugins: with plugins; [
          nix
	  markdown
	  html
	  css
	  bash
	]
      ))
    ];
  };
}
