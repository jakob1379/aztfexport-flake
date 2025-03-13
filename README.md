# aztfexport-flake

[![License](https://img.shields.io/badge/license-MPL--2.0-blue.svg)](https://opensource.org/licenses/MPL-2.0)
[![NixOS Compatible](https://img.shields.io/badge/NixOS-Compatible-brightgreen)](https://nixos.org/)

This repository provides a [Nix flake](https://nixos.org/manual/nix/stable/concepts/flakes.html) for the `aztfexport` Go tool, which is used to export your existing Azure infrastructure into Terraform configuration.

## Features

*   **Declarative Package Management:** Uses Nix to ensure reproducible and consistent builds.
*   **Development Environment:**  Provides a `devShell` with all necessary tools for development, including `pre-commit` and `nixfmt-rfc-style`.
*   **Easy to Use:** Simply add this flake as an input to your project and start exporting your Azure resources.
*   **Up-to-date:**  Pinning the version to a specific commit hash ensures you're using a known and tested version of `aztfexport`.

## Prerequisites

*   [Nix Package Manager](https://nixos.org/download.html) (version 2.0 or higher for flake support)

## Getting Started

### Adding as a flake input

To use this flake in your Nix project, add it as an input in your `flake.nix`:

```nix
{
  inputs = {
    aztfexport-flake.url = "github:your-github-username/aztfexport-flake";
  };

  outputs = { self, nixpkgs, aztfexport-flake }: {
    devShell.${system} = nixpkgs.legacyPackages.${system}.mkShell {
      packages = [
        aztfexport-flake.packages.${system}.default
      ];
    };
  };
}
```

Replace `your-github-username` with the actual GitHub username where this repository is hosted.

### Using the `devShell`

Once you've added the flake as an input, you can enter the development shell by running:

```bash
nix develop
```

This will provide an environment with `aztfexport` available in your `$PATH`, along with pre-commit hooks for formatting.

### Running `aztfexport`

After entering the `devShell`, you can use the `aztfexport` command to export your Azure resources. Refer to the [official `aztfexport` documentation](https://github.com/Azure/aztfexport) for usage instructions.

## Contributing

Contributions are welcome! Please submit a pull request with your changes.

## License

This project is licensed under the [Mozilla Public License 2.0](https://opensource.org/licenses/MPL-2.0).
