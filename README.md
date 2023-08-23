# 🐻‍❄️🔮 Noelware's Helm Charts
> *Curated catalog of [Helm](https://helm.sh) charts that [Noelware](https://noelware.org) maintains*
>
> **NOTE**: This doesn't cover the Helm charts for all of Noelware's products. This only contains the Helm charts
> that Noelware uses in production.

**helm-charts** is Noelware's curated catalog of [Helm](https://helm.sh) charts that we use in production today. We do maintain our own charts for Elasticsearch, Kibana, Logstash, fleet-server, and Elastic Agent due to the official Helm charts being deprecated ([elastic/helm-charts](https://github.com/elastic/helm-charts)).

We do use Bazel to manage our Helm charts to:

* have a hermetic Helm toolchain,
* make it easier to push, test, and lint charts without having `helm` installed.

This uses our [rules_helm](https://github.com/Noelware/rules_helm) Bazel ruleset to do what we want.

## Noelware's Products Helm Charts
* [Noeldoc Registry](https://github.com/Noelware/noeldoc/tree/master/distribution/helm)
* [charted-server](https://github.com/charted-dev/charted/tree/main/distribution/helm)
* [AuthKit](https://github.com/Noelware/AuthKit/tree/master/distribution/helm)
* [Petal](https://github.com/Noelware/Petal/tree/master/distribution/helm)
* [Hazel](https://github.com/Noelware/hazel/tree/master/distribution/helm)
