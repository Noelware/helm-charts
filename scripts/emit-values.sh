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

if ! command -v bun >/dev/null; then
    echo "[ERROR] ===> Missing \`bun\` in host machine, install it please!"
    exit 1
fi

! [ -d "$DIR/.cache" ] && mkdir -p "$DIR/.cache"

if ! [ -d "$DIR/.cache/bitnami-helm-gen" ]; then
    echo "===> Missing $DIR/.cache/bitnami-helm-gen directory, installing..."

    git clone https://github.com/bitnami-labs/readme-generator-for-helm "$DIR/.cache/bitnami-helm-gen"
    bun install "$DIR/.cache/bitnami-helm-gen"
fi

# TODO(@auguwu): auto generate this list (if we need to)
charts=(
    "$DIR/charts/jetbrains/hub"
    "$DIR/charts/jetbrains/youtrack"
    "$DIR/charts/noelware/hazel"
    "$DIR/charts/noelware/petal"
    "$DIR/charts/docker-auth"
    "$DIR/charts/docker-registry"
)

for chart in "${charts[@]}"; do
    rel="./$(realpath --relative-to="$DIR" "$chart")"
    echo "Updating README.md with Helm values... [$rel]"

    if ! [ -f "$chart/values.yaml" ]; then
        echo ".... Skipping due to no \`values.yaml\` in $rel"
        continue
    fi

    if ! [ -f "$chart/README.md" ]; then
        echo ".... Skipping due to no \`README.md\` in $rel"
        continue
    fi

    echo ".... Generating..."
    (cd "$DIR/.cache/bitnami-helm-gen" && bun --bun bin/index.js --values "$chart/values.yaml" --readme "$chart/README.md")

    if [ "$?" != "0" ]; then
        echo ".... Failed to generate, view logs above"
        exit 1
    fi
done
