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

charted {
    version = "~ 0.1-beta"
    helm    = "~ 3.12"
}

registry "default" {
    version = 1
    url     = "https://charts.noelware.org/api"
}

repository "jetbrains-hub" {
    readme = "./charts/jetbrains/hub/README.md"
    source = "./charts/jetbrains/hub"

    config {
        repository = "noelware/jetbrains-hub"
        registry   = [registry.default]
    }
}

repository "jetbrains-youtrack" {
    readme = "./charts/jetbrains/youtrack/README.md"
    source = "./charts/jetbrains/youtrack"

    config {
        repository = "noelware/youtrack"
        registry   = [registry.default]
    }
}

repository "hazel" {
    readme = "./charts/noelware/hazel/README.md"
    source = "./charts/noelware/hazel"

    config {
        repository = "noelware/hazel"
        registry   = [registry.default]
    }
}

repository "petal" {
    readme = "./charts/noelware/petal/README.md"
    source = "./charts/noelware/petal"

    config {
        repository = "noelware/petal"
        registry   = [registry.default]
    }
}
