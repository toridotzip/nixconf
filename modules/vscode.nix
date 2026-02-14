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

  yarnspinner = vscode-utils.extensionFromVscodeMarketplace {
    name = "yarn-spinner";
    publisher = "secretlab";
    version = "3.0.463";
    sha256 = "sha256-dapfCejOm6Fna7JSnLXUJh8nXjPrL0LyOPJCw7PDVVI=";
  };

  vscode = vscode-with-extensions.override {
    vscodeExtensions = with vscode-extensions;
      [
        aura-theme
    	  symbols
	      p5-vscode
        yarnspinner
        firefox-devtools.vscode-firefox-debug
        ms-vscode-remote.remote-ssh
	      jnoortheen.nix-ide
	      ritwickdey.liveserver
	      bradlc.vscode-tailwindcss
        ms-python.python
        ms-python.debugpy
        arrterian.nix-env-selector
        svelte.svelte-vscode
      ];
  };
in
{
  environment.systemPackages = [ 
    pkgs.vscode
    pkgs.nixfmt
  ];
}
