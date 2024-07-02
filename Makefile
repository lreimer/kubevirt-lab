GCP_PROJECT ?= cloud-native-experience-lab
GCP_REGION ?= europe-north1

prepare-gcp:
	@gcloud config set project $(GCP_PROJECT)
	@gcloud config set container/use_client_certificate False

create-gke-cluster:
	@gcloud container clusters create kubevirt-lab \
		--release-channel regular \
		--region $(GCP_REGION)  \
		--cluster-version 1.29 \
		--enable-autoscaling \
		--min-nodes 1 \
		--max-nodes 3 \
		--enable-autorepair \
		--enable-vertical-pod-autoscaling \
		--enable-ip-alias \
		# --enable-master-authorized-networks \
		# --master-authorized-networks 192.168.235.0/24,185.91.50.0/24 \
		--addons HttpLoadBalancing,HorizontalPodAutoscaling \
		--machine-type n1-standard-4

delete-gke-cluster:
	@gcloud container clusters delete kubevirt-lab --region $(GCP_REGION)
