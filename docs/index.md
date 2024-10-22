# powerpipe-mod-kubernetes-vpa-right-sizing


## Requirements

### Install VPA (Recommender Only)

```bash

git clone https://github.com/kubernetes/autoscaler.git --depth 1

# remove admission-controller and updater deployments 
# from kustomization resources
cat << EOF > "autoscaler/vertical-pod-autoscaler/deploy/kustomization.yaml"
resources:
#  - admission-controller-deployment.yaml
- recommender-deployment.yaml
#  - updater-deployment.yaml
- vpa-rbac.yaml
- vpa-v1-crd-gen.yaml
EOF

# make sure changes are applied
cat autoscaler/vertical-pod-autoscaler/deploy/kustomization.yaml

# NOTE: save this file to remove the VPA installation later
kubectl kustomize autoscaler/vertical-pod-autoscaler/deploy > vpa-recommend-manifests.yaml


kubectl apply -f vpa-recommend-manifests.yaml
```

### Add custom PSQL functions to Steampipe DB

```bash
curl -LO https://raw.githubusercontent.com/oguzhan-yilmaz/powerpipe-mod-kubernetes-vpa-right-sizing/refs/heads/main/init-db.sql

# You may need to provide a password
psql postgres://steampipe@127.0.0.1:9193/steampipe -f init-db.sql
```

### Generate VPA objects for Deployments, Statefulsets and Daemonsets

```bash
# make sure you're targeting the correct cluster
kubectl config current-context

# Run the helper script to generate Recommend only VPA objects for your workload
bash generate_vpa_recommender.sh

# Apply and keep the manifests files to easy removal later on
kubectl apply -f vpa-manifests/deployment_vpas.yaml
kubectl apply -f vpa-manifests/statefulset_vpas.yaml
kubectl apply -f vpa-manifests/daemonset_vpas.yaml
```


## Installation

Install the Powerpipe Mod

```bash
powerpipe mod install github.com/oguzhan-yilmaz/powerpipe-mod-kubernetes-vpa-right-sizing
```

Start the server and check for `Kubernetes VPA Right Sizing` mod.

```bash
powerpipe server
```