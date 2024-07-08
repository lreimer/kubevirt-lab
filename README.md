# KubeVirt Demo Lab

Demo repository for trying out KubeVirt on GKE (or locally).

## Setup Instructions

```bash
# if desired, create a GKE cluster
# for GKE we need to enable nested virtualization
# not all machine types support this feature, see https://cloud.google.com/compute/docs/machine-resource?hl=en#machine_type_comparison
# otherwise make sure your Kube context points to your local cluster
make create-gke-cluster

# next we bootstrap kubevirt onto the cluster
# this will install the operator and custom resource as describe in https://kubevirt.io/quickstart_cloud/
make bootstrap-kubevirt
kubectl krew install virt

# finally make sure to remove any VM and cluster
make destroy-gke-cluster
```

## Lab Instructions

```bash
# first we create our first VM
kubectl apply -f examples/testvm.yaml
kubectl get vms

# we start and check that the VM instance is running
kubectl virt start testvm
kubectl get vmis
kubectl virt console testvm

# next we check the cluster internal communication
kubectl apply -f examples/testshell.yaml
kubectl get vmis
kubectl exec -it testshell -- /bin/sh
ping <IP>

# now expose the SSH port of the VM and connect to it
kubectl virt expose vmi testvm --name=testvm-ssh --port=20222 --target-port=22 --type=LoadBalancer
kubectl get services
ssh cirros@<EXTERNAL-IP> -p 20222

# there are also machine instance replica sets, this one can also be scaled
kubectl apply -f examples/testreplicaset.yaml
kubectl virt expose vmirs testreplicaset --name=testreplicaset-ssh --port=22222 --target-port=22
kubectl get vmis

kubectl scale vmirs testreplicaset --replicas=2
kubectl get vmis

kubectl apply -f examples/testhpa.yaml
kubectl get vmis
kubectl scale vmirs testreplicaset --replicas=3
kubectl describe hpa testhpa
kubectl get vmis
```

## Maintainer

M.-Leander Reimer (@lreimer), <mario-leander.reimer@qaware.de>

## License

This software is provided under the Apache v2.0 open source license, read the `LICENSE` file for details.
