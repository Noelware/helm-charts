# 🔮 Helm Charts
[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/Noelware)](https://artifacthub.io/packages/search?repo=Noelware)

> List of Helm Charts for Noelware projects

## Charts
### [Arisu](https://arisu.land)
- [🎀 **Tsubaki**](./arisu/tsubaki)
- [💝 **Fubuki**](./arisu/fubuki)
- [:octocat: **GitHub Bot**](./arisu/github)
- [🌌 **Telemetry Server**](./arisu/telemetry)

### 💫 [Kanata](https://docs.floof.gay/services/kanata)
- [💫 **kanatad**](./kanata/daemon)

### 🥐 [gitjb](https://gitjb.dev)
- [🥐 **gitjbd**](./gitjb/daemon)
- [🥐 **backend**](./gitjb/backend)

## How to use a Noelware Helm Chart?
```sh
$ helm repo add https://charts.floof.gay/noelware
$ helm search repo noelware
$ helm install my-release <product>/<name>
```

- Replace **my-release** with the release name
- Replace **<product>** with the product name, i.e, `arisu`
- Replace **<name>** with the name of the repository, i.e, `tsubaki`

## License
Noelware **Helm Charts** are released under the **MIT** License.
