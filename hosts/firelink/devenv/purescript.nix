with import <nixpkgs> {};

let
  easy-ps = import (fetchFromGitHub {
    owner = "justinwoo";
    repo = "easy-purescript-nix";
    rev = "7b1c1635e16c7f12065db2f8ec049030fcc63655";
    sha256 = "1nybcann9aiwbvj95p6wam8xyhxwaxmfnkxmgylxcw42np2lvbzr";
  }) {
    inherit pkgs;
  };
in
stdenv.mkDerivation {
  name = "purescript-env";

  buildInputs = [
    easy-ps.purs
    easy-ps.spago
    easy-ps.purty
  ];
}
