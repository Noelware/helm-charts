#!/usr/bin/env bash

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

# This script will emit a '# Parameters' section in each chart avaliable.

while [ -L "$BASH_SRC" ]; do
    target=$(readlink "$BASH_SRC")
    if [[ $target == /* ]]; then
        BASH_SRC=$target
    else
        dir=$(dirname "$BASH_SRC")
        BASH_SRC=$dir/$target
    fi
done

DIR=$(cd -P "$(dirname "$BASH_SRC")" >/dev/null 2>&1 && pwd)
charts=(
    #"$DIR/charts/docker_auth"

    "$DIR/charts/jetbrains/hub"
    "$DIR/charts/jetbrains/youtrack"

    "$DIR/charts/noelware/hazel"

    #"$DIR/charts/sentry/snuba"
    "$DIR/charts/sentry/symbolicator"
    "$DIR/charts/sentry/vroom"
)

function charts::generate-readme() {
    local use_bun="$1"

    for chart in "${charts[@]}"; do
        rel="./$(realpath --relative-to=$DIR $chart)"
        echo "~> updating README.md                     [$rel]"

        [ ! -f "$chart/README.md" ] && {
            echo "~> ...skipping since no README is there   [$rel]"
            continue
        }

        if [ "$use_bun" == "no" ]; then
            helm-readme-gen --values "$chart/values.yaml" --readme "$chart/README.md"
            [ "$?" != "0" ] && {
                echo "~> ...failed to update! view logs above           [$rel]"
                exit 1
            }
        else
            bun --bun "$DIR/.cache/bitnami-helm-gen/bin/index.js" --values "$chart/values.yaml" --readme "$chart/README.md"
            [ "$?" != "0" ] && {
                echo "~> ...failed to update! view logs above           [$rel]"
                exit 1
            }
        fi
    done
}

# If on NixOS, then we provide a Nix package called `helm-readme-gen`, which is the binary that we use
# for this script. This will check if we have it via `command -v` since if we used `nix-shell` or `direnv`,
# the binary will find it.
#
# If we are on NixOS and can't find it, then we'll just do a `bun install` and
# run it as an ordinary package.
if cat /etc/os-release | grep -q 'ID=nixos'; then
    if command -v helm-readme-gen >/dev/null; then
        charts::generate-readme "no"
        exit 0
    fi
fi

if ! command -v bun >/dev/null; then
    echo "~> fatal: missing \`bun\` on host machine."
    exit 1
fi

! [ -d "$DIR/.cache" ] && mkdir -p "$DIR/.cache"
if ! [ -d "$DIR/.cache/bitnami-helm-gen" ]; then
    echo "~> missing \`bitnami-helm-gen\` directory in .cache, installing via \`bun\`..."

    git clone https://github.com/bitnami/readme-generator-for-helm "$DIR/.cache/bitnami-helm-gen"
    bun install "$DIR/.cache/bitnami-helm-gen"

    # moves bun.lockb to its respective directory
    mv "$DIR/bun.lockb" "$DIR/.cache/bitnami-helm-gen"

    # removes package.json since it only references the `bun install`
    # invocation as a dependency (and we don't want that)
    rm "$DIR/package.json"
fi

charts::generate-readme "yes"
