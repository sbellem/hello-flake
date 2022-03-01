{
  description = "hello hello world";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.hello-flake.url = "github:sbellem/hello-flake";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    hello-flake,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        overlays = [hello-flake.overlay];
        pkgs = import nixpkgs {inherit system overlays;};
      in {
        devShell = pkgs.mkShell {
          buildInputs = [
            hello-flake.defaultPackage.${system}
            #hello-flake.packages.${system}.hello
            pkgs.hello-flakes
          ];
        };
      }
    );
}
