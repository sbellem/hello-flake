# hello-flake
Simple nix flake demonstrating a basic usage of a flake in another flake.

The flake is in the file [`flake.nix`](./flake.nix) and is shown here for
convenience:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        # nix build .#hello
        packages.hello = pkgs.hello;

        # nix build
        defaultPackage = self.packages.${system}.hello;

        # nix develop .#hello or nix shell .#hello
        devShells.hello = pkgs.mkShell { buildInputs = [ pkgs.hello pkgs.cowsay ]; };
        
        # nix develop or nix shell
        devShell = self.devShells.${system}.hello;
      });
}
```


## Usages
Here are some possible usages, from _outside_ this repository, meaning that
you should be able to run this on your machine without cloning the repository.

Invoke the flake with `nix shell` or `nix develop`:

```shell
nix develop github:sbellem/hello-flake -c hello
```
```shell
nix develop github:sbellem/hello-flake#hello -c hello
```

To use in another flake, such as specifying the package as a dependency in
`buildInputs`, you need to be explicit, such as in:

```nix
buildInputs = [
  hello-flake.defaultPackage.${system}
];
```
```nix
buildInputs = [
  hello-flake.packages.${system}.hello
];
```

**NOTE** that the following will not work:
(see related [discourse question &
answers](https://discourse.nixos.org/t/using-a-nix-flake-in-a-flake-e-g-buildinputs/17923))

```nix
buildInputs = [
  hello-flake
];
```

Here's a complete flake, which should work. To try just copy/paste the flake
in a `flake.nix` file under a git repository, and stage the `flake.nix` for
committing it. For instance:

```
mkdir /tmp/hello && cd /tmp/hello && git init
vim flake.nix

# copy the flake just below

# stage
git add flake.nix
```

```nix
{
  description = "hello hello world";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.hello-flake.url = "github:sbellem/hello-flake";

  outputs = { self, nixpkgs, flake-utils, hello-flake }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        devShell = pkgs.mkShell {
          buildInputs = [
            # specify the default package
            hello-flake.defaultPackage.${system}

            # specify the hello pacakge
            #hello-flake.packages.${system}.hello
          ];
        };
      }
    );
}
```

Start the dev shell

```shell
you@awesome:/tmp/hello$ nix develop
warning: Git tree '/tmp/hello' is dirty
warning: creating lock file '/tmp/hello/flake.lock'
warning: Git tree '/tmp/hello' is dirty
```

The `hello` program should be available:

```shell
you@awesome:/tmp/hello$ hello
Hello, world!
```
