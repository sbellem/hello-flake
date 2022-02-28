{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
  };

  outputs = { self, nixpkgs }:
  let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in {
    # nix build .#hello
    packages.x86_64-linux.hello = pkgs.hello;

    # nix build
    defaultPackage.x86_64-linux = self.packages.x86_64-linux.hello;

    # nix develop .#hello or nix shell .#hello
    devShells.x86_64-linux.hello = pkgs.mkShell { buildInputs = [ pkgs.hello pkgs.cowsay ]; };

    # nix develop or nix shell
    devShell.x86_64-linux = self.devShells.x86_64-linux.hello;
  };
}
