final: prev: {
  hello-flakes = prev.callPackage ./hello-flakes.nix {};
}
