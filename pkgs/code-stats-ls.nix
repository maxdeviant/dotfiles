# The Code::Stats language server, used by the Code::Stats Zed extension.
#
# The extension would otherwise download a prebuilt binary from GitHub, which
# is dynamically linked against a standard FHS layout and won't run on NixOS.
# It looks for `code-stats-ls` on PATH before downloading, so installing this
# package is enough to make it use ours instead.
{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "code-stats-ls";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "maxdeviant";
    repo = "code-stats-ls";
    rev = "v${version}";
    hash = "sha256-MY3a+rgCq1UzrFQ4ZkKaU88BGK4lYbZEwwIvOMJDl2M=";
  };

  cargoHash = "sha256-BKdAXgaoRWL9bCBxRlq1GC5ee7UZAHdAKQIwjm/dNe4=";

  meta = {
    description = "A language server for Code::Stats";
    homepage = "https://github.com/maxdeviant/code-stats-ls";
    license = lib.licenses.mit;
    mainProgram = "code-stats-ls";
  };
}
