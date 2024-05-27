# 🐻‍❄️🔮 Noelware's Helm Charts: Curated catalog of Noelware's Helm charts.
# Copyright (c) 2022-2024 Noelware, LLC. <team@noelware.org>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
{
  description = "Curated catalog of Noelware's maintained Helm charts";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    # charted-helm-plugin aren't released on nixpkgs as of 25/04/24
    charted = {
      # TODO(@auguwu): use tag release instead of `main`
      url = "github:charted-dev/charted";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        flake-compat.follows = "flake-compat";
      };
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://noelware.cachix.org"
      "https://noel.cachix.org"
    ];

    extra-trusted-public-keys = [
      "noelware.cachix.org-1:22A8ELRjkqEycSHz+R5A5ReX2jyjU3rftsBmlD6thn0="
      "noel.cachix.org-1:pQHbMJOB5h5VqYi3RV0Vv0EaeHfxARxgOhE9j013XwQ="
    ];
  };

  outputs = {
    nixpkgs,
    flake-utils,
    charted,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
      };

      helm = pkgs.wrapHelm pkgs.kubernetes-helm {
        plugins = [
          charted.packages.${system}.helm-plugin
        ];
      };
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = [
          (import ./nix/helm-readme-gen.nix {inherit pkgs;})

          pkgs.hclfmt
          helm
        ];
      };
    });
}
