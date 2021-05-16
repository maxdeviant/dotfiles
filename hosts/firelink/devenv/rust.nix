with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "rust-env";

  buildInputs = [
    stdenv
    pkg-config
  ];
}