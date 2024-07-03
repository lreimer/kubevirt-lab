# KubeVirt Demo Lab

Demo repository for trying out KubeVirt locally and on GKE.

## Instructions

```bash
# if desired, create a GKE cluster
# otherwise make sure your Kube context points to your local cluster
make create-gke-cluster

# next we bootstrap kubevirt onto the cluster
# this will install the operator and custom resource as describe in https://kubevirt.io/quickstart_cloud/
make bootstrap-kubevirt

# finally make sure to remove any VM and cluster
make destroy-gke-cluster
```

## Maintainer

M.-Leander Reimer (@lreimer), <mario-leander.reimer@qaware.de>

## License

This software is provided under the Apache v2.0 open source license, read the `LICENSE` file for details.
