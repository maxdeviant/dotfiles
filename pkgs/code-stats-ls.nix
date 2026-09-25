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
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "code-stats-ls";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "maxdeviant";
    repo = "code-stats-ls";
    rev = "v${version}";
    hash = "sha256-BLuI+u9+dIiDs4z4E7yTNL/yGUI5uyUkfI5PlNte9nA=";
  };

  cargoHash = "sha256-efpE9yg0BHI5JKNJWLJTUtAsMaG2KuqOjw2p65WoXHg=";

  # reqwest keeps its default features, so native-tls (and so OpenSSL) is
  # linked in alongside rustls.
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  meta = {
    description = "A language server for Code::Stats";
    homepage = "https://github.com/maxdeviant/code-stats-ls";
    license = lib.licenses.mit;
    mainProgram = "code-stats-ls";
  };
}
