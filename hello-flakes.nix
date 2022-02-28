{rustPlatform}:
rustPlatform.buildRustPackage rec {
  pname = "hello-flakes";
  version = "0.1.0";

  src = builtins.path {
    path = ./.;
    name = "${pname}-${version}";
  };

  cargoSha256 = "sha256-RmWLymKhIzA6MgEsRpE4cHoRKgXQchf8A01t8fo+tx0=";
}
