{ pkgs, lib, ... }:

let
  inherit (pkgs) vscode-extensions vscode-utils vscode-with-extensions;

  p5-vscode = vscode-utils.extensionFromVscodeMarketplace {
    name = "p5-vscode";
    publisher = "samplavigne";
    version = "1.2.16";
    sha265 = "sha256:W/9k+r9ddSCBBj1V0b1Bd8I5oTCmzkAD10CUa2iLE70=";
  };

  vscode = vscode-with-extensions.override {
    vscodeExtensions = with vscode-extensions;
      [
        ms-vscode-remote.remote-ssh
        bbenoist.nix
        ritwickdey.liveserver
        bradlc.vscode-tailwindcss
      ];
  };

  vsc-server = (fetchTarball "https://github.com/nix-community/nixos-vscode-server/tarball/master");
in
{
  imports = [ vsc-server ];

  environment.systemPackages = [ vscode ];

  services.vscode-server.enable = true;
}
