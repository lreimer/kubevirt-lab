GCP_PROJECT ?= cloud-native-experience-lab
GCP_REGION ?= europe-north1
KUBEVIRT_VERSION ?= $(shell curl -s https://storage.googleapis.com/kubevirt-prow/release/kubevirt/kubevirt/stable.txt)

prepare-gcp:
	@gcloud config set project $(GCP_PROJECT)
	@gcloud config set container/use_client_certificate False

create-gke-cluster:
	@gcloud container clusters create kubevirt-lab \
		--release-channel=regular \
		--region=$(GCP_REGION)  \
		--cluster-version=1.29 \
		--addons=HttpLoadBalancing,HorizontalPodAutoscaling \
		--machine-type=n2-standard-8 \
		--enable-autoscaling \
		--autoscaling-profile=optimize-utilization \
        --num-nodes=1 \
		--min-nodes=1 --max-nodes=3 \
		--enable-autorepair \
		--enable-vertical-pod-autoscaling \
		--enable-ip-alias \
		--enable-nested-virtualization \
		--node-labels=nested-virtualization=enabled	
	@kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin --user=$$(gcloud config get-value core/account)
	@kubectl cluster-info

bootstrap-kubevirt:
	@kubectl create -f https://github.com/kubevirt/kubevirt/releases/download/${KUBEVIRT_VERSION}/kubevirt-operator.yaml
	@kubectl create -f https://github.com/kubevirt/kubevirt/releases/download/${KUBEVIRT_VERSION}/kubevirt-cr.yaml

delete-gke-cluster:
	@gcloud container clusters delete kubevirt-lab --region=$(GCP_REGION) --async --quiet
