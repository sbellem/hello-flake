{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    flake-utils,
    nixpkgs,
  }:
    {
      overlay = import ./overlay.nix;
    }
    // flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        # nix build .#hello
        packages.hello = pkgs.hello;

        # nix build
        defaultPackage = self.packages.${system}.hello;

        # nix develop .#hello or nix shell .#hello
        devShells.hello = pkgs.mkShell {buildInputs = [pkgs.hello pkgs.cowsay];};

        # nix develop or nix shell
        devShell = self.devShells.${system}.hello;
      }
    );
}
