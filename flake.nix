{
  description = "Ion shell from latest master";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    ion-src = {
      url = "git+https://gitlab.redox-os.org/redox-os/ion.git?ref=master";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, ion-src }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        ion = pkgs.rustPlatform.buildRustPackage rec {
          pname = "ion-shell";
          version = "unstable-master";

          src = ion-src;

          # Update this hash when the build fails with a hash mismatch.
          cargoHash = "sha256-PAi0x6MB0hVqUD1v1Z/PN7bWeAAKLxgcBNnS2p6InXs=";

          doCheck = false;

          # Optional: set a custom version string
          prePatch = ''
            echo "nix-lumiini-1" > git_revision.txt
          '';

          meta = with pkgs.lib; {
            description = "Ion shell from upstream master";
            homepage = "https://gitlab.redox-os.org/redox-os/ion";
            license = licenses.mit;
            mainProgram = "ion";
          };
        };
      in {
        packages.default = ion;
        packages.ion = ion;
        apps.default = flake-utils.lib.mkApp { drv = ion; };
      }
    );
}
