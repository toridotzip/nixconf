{ pkgs, lib, ... }:

let
  inherit (pkgs) vscode-extensions vscode-utils vscode-with-extensions;

  aura-theme = vscode-utils.extensionFromVscodeMarketplace {
    name = "aura-theme";
    publisher = "daltonmenezes";
    version = "2.1.2";
    sha256 = "sha256-r6pPpvJ1AZsM0RYF+xHsZ4b4QTszN+wELr1SENsUDFA=";
  };

  symbols = vscode-utils.extensionFromVscodeMarketplace {
    name = "symbols";
    publisher = "miguelsolorio";
    version = "0.0.25";
    sha256 = "sha256-nhymeLPfgGKyg3krHqRYs2iWNINF6IFBtTAp5HcwMs8=";
  };

  p5-vscode = vscode-utils.extensionFromVscodeMarketplace {
    name = "p5-vscode";
    publisher = "samplavigne";
    version = "1.2.16";
    sha256 = "sha256-W/9k+r9ddSCBBj1V0b1Bd8I5oTCmzkAD10CUa2iLE70=";
  };

  yarn-spinner = vscode-utils.extensionFromVscodeMarketplace {
    name = "yarn-spinner";
    publisher = "secretlab";
    version = "3.0.463";
    sha256 = "sha256-dapfCejOm6Fna7JSnLXUJh8nXjPrL0LyOPJCw7PDVVI=";
  };

  vue-snippets = vscode-utils.extensionFromVscodeMarketplace {
    name = "vue-snippets";
    publisher = "hollowtree";
    version = "1.0.4";
    sha256 = "sha256-IQBRAwiL0HdX4HooJMB1YIVPT+bl5gvMHg4mE0iZxm8=";
  };

  textual-syntax-highlighter = vscode-utils.extensionFromVscodeMarketplace {
    name = "textual-syntax-highlighter";
    publisher = "Textualize";
    version = "1.3.0";
    sha256 = "sha256-Z9lOIExpQndTG16HznLVCfU7JcxdW5qpG5HBg6U9CVI=";
  };

  vscode = vscode-with-extensions.override {
    vscodeExtensions = with vscode-extensions;
      [
        aura-theme
    	  symbols
	      p5-vscode
        yarn-spinner
        vue-snippets
        textual-syntax-highlighter
        # --- in pkgs ---
        ## --- gen ---
        ms-vscode-remote.remote-ssh
        dbaeumer.vscode-eslint
        esbenp.prettier-vscode
        arrterian.nix-env-selector
        ms-dotnettools.vscode-dotnet-runtime
        # --- nix ---
        jnoortheen.nix-ide
        ## --- web ---
        firefox-devtools.vscode-firefox-debug
	      ritwickdey.liveserver
	      bradlc.vscode-tailwindcss
        vue.volar
        formulahendry.auto-close-tag
        # --- python ---
        ms-python.python
        ms-python.debugpy
        ms-python.black-formatter
      ];
  };
in
{
  environment.systemPackages = [ 
    vscode
    pkgs.nixfmt
    pkgs.dotnet-sdk_9
  ];

  environment.sessionVariables = {
    DOTNET_ROOT = "${pkgs.dotnet-sdk_9}/share/dotnet";
  };
}
