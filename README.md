# aztfexport-flake

[![License](https://img.shields.io/badge/license-MPL--2.0-blue.svg)](https://opensource.org/licenses/MPL-2.0)
[![NixOS Compatible](https://img.shields.io/badge/NixOS-Compatible-brightgreen)](https://nixos.org/)

A [Nix flake](https://nixos.org/manual/nix/stable/concepts/flakes.html) for
[`aztfexport`](https://github.com/Azure/aztfexport), Microsoft's tool for
exporting existing Azure infrastructure into Terraform configuration. The build
is pinned to one upstream commit, so everyone on your team gets the same binary.

<p align="center">
  <img src=".github/assets/azure-to-terraform.svg" width="100%"
       alt="Diagram: three Azure resources (rg-demo, vnet-demo, stdemo) pass one at a time through aztfexport v0.16.0, built by Nix from commit 215fca6, and become Terraform resource blocks res-0, res-1 and res-2 in main.tf.">
</p>

## Run it

You need [Nix](https://nixos.org/download.html) with flakes enabled.

Export a resource group without installing anything:

```bash
nix run github:jakob1379/aztfexport-flake -- resource-group <resource-group-name>
```

Or open a shell with `aztfexport` on your `$PATH`:

```bash
nix shell github:jakob1379/aztfexport-flake
```

For every command and flag, see the
[upstream `aztfexport` documentation](https://github.com/Azure/aztfexport).

## Add it to your flake

Add this repository as an input and put the package in your dev shell:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    aztfexport-flake.url = "github:jakob1379/aztfexport-flake";
  };

  outputs = { self, nixpkgs, aztfexport-flake }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = [ aztfexport-flake.defaultPackage.${system} ];
      };
    };
}
```

Then run `nix develop` and `aztfexport` is available in that shell.

The flake exposes the package as `defaultPackage.<system>` for every system in
[flake-utils](https://github.com/numtide/flake-utils)' default set.

## What is pinned

| Piece          | Pinned to                                                                                      | Where         |
| -------------- | ---------------------------------------------------------------------------------------------- | ------------- |
| `aztfexport`   | `v0.16.0`, commit [`215fca6`](https://github.com/Azure/aztfexport/commit/215fca6ab1ccb8f164976fba4232a504e18667ea) | `flake.nix`   |
| Go module deps | `vendorHash`                                                                                   | `flake.nix`   |
| `nixpkgs`      | `nixpkgs-unstable` at the locked revision                                                      | `flake.lock`  |

To move to a newer `aztfexport`, update `version`, `rev`, `sha256` and
`vendorHash` in `flake.nix`.

## Working on this flake

`nix develop` in this repository gives you `pre-commit` and `nixfmt-rfc-style`.
Run `pre-commit install` once to format and lint on every commit.

## Contributing

Contributions are welcome. Open a pull request with your changes.

## License

This project is licensed under the
[Mozilla Public License 2.0](https://opensource.org/licenses/MPL-2.0).
