# Copyright (c) Lumiini
# All rights reserved.
#
# This file is licensed under the MIT license (found in the
# LICENSE file in the root directory of this source tree).

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

          cargoHash = "sha256-PAi0x6MB0hVqUD1v1Z/PN7bWeAAKLxgcBNnS2p6InXs=";

          doCheck = false;

          # Create a dummy git_revision.txt file so build.rs doesn't try to run git
          # prePatch = ''
          #   echo "unknown" > git_revision.txt
          # '';

          prePatch = ''
            echo "nixos-lumiini-1" > git_revision.txt
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
