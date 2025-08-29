# flake.nix
{
  description = "aztfexport Go tool";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        fetchFromGitHub = pkgs.fetchFromGitHub;
        lib = pkgs.lib;
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            pre-commit
            nixfmt-rfc-style
          ];

          setupHook = ''
            pre-commit install
            pre-commit autoupdate -j $(nproc)
          '';

        };

        defaultPackage = pkgs.buildGoModule rec {
          pname = "aztfexport";
          version = "v0.16.0"; # Short commit hash

          src = fetchFromGitHub {
            owner = "Azure";
            repo = "aztfexport";
            rev = "215fca6ab1ccb8f164976fba4232a504e18667ea";
            sha256 = "sha256-fcS8Z1dLEGBx39cuBiJj4wTgEx/ALqhkiJi89LOFDD4=";
          };

          vendorHash = "sha256-VLBE7L81lqPNGZjVDBmJs4DKWrS+wJ/JDWWsQTiMSDg=";

          meta = with pkgs.lib; {
            description = "Azure Terraform Export Tool";
            homepage = "https://github.com/Azure/aztfexport";
            license = licenses.mpl20;
            maintainers = with pkgs.lib.maintainers; [ ];
          };
        };
      });
}
