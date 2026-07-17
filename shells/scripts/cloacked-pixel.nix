let
  pkgs = import <nixpkgs> {};
  src = pkgs.fetchFromGitHub {
    owner = "livz";
    repo = "cloacked-pixel";
    rev = "master";
    sha256 = "sha256-lfezmXQMVir6jM7T69GvWCM1br+OCmM1+K3Mw+01wm0=";
  };
  pythonEnv = pkgs.python3.withPackages (ps: with ps; [
    pillow pycryptodome matplotlib numpy
  ]);
in pkgs.mkShell {
  buildInputs = [ pythonEnv ];

  shellHook = ''
    dir=$(mktemp -d)
    cp ${src}/*.py "$dir"
    ${pkgs.python312}/bin/2to3 -w "$dir"/*.py 
    cd "$dir"
  '';
}
