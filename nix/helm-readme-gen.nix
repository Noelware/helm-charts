# 🐻‍❄️🏴‍☠️ Noel's Helm Charts: Curated catalog of Noel's Helm charts.
# Copyright (c) 2024 Noel Towa <cutie@floofy.dev>
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
{pkgs}:
pkgs.buildNpmPackage rec {
  pname = "helm-readme-gen";
  version = "2.6.1";
  src = pkgs.fetchFromGitHub {
    owner = "bitnami";
    repo = "readme-generator-for-helm";
    rev = "${version}";
    hash = "sha256-hgVSiYOM33MMxVlt36aEc0uBWIG/OS0l7X7ZYNESO6A=";
  };

  patches = [
    # `readme-generator` is too vague, so `helm-readme-gen` will do for now. Just a simple
    # package.json patch to update the bin name.
    ./helm-readme-gen_overwrite-bin.patch
  ];

  NODE_OPTIONS = "--openssl-legacy-provider";

  npmDepsHash = "sha256-baRBchp4dBruLg0DoGq7GsgqXkI/mBBDowtAljC2Ckk=";
  dontNpmBuild = true;
  meta = with pkgs.lib; {
    description = "Auto generate READMEs for Helm Charts";
    homepage = "https://github.com/bitnami/readme-generator-for-helm";
    license = licenses.asl20;
    maintainers = with maintainers; [bitnami];
  };
}
