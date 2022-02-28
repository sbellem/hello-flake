{pkgs ? import <nixpkgs> {}}: {
  helloflakes = pkgs.callPackage ./hello-flakes.nix {};
}
