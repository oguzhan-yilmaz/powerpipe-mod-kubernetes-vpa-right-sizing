# powerpipe-mod-kubernetes-vpa-right-sizing


| Dashboard Title | Details |
| -- | -- |
| Deployments: Limits and Requests | All Limits and Requests|
| VPA -- Not Enabled | Workloads that doesn't have associated VPA crd objects |
| VPA CPU Overshot | Defined `CPU Request` are **more** than average usage |
| VPA CPU Undershot | Defined `CPU Request` are **less** than average usage |
| VPA Memory Overshot | Defined `Memory Request` are **more** than average usage |
| VPA Memory Undershot | Defined `Memory Request` are **less** than average usage |
| VPA CPU Recommendations | Only CPU Recommendations |
| VPA Memory Recommendations | Only Memory Recommendations |
| VPA CPU and Memory Recommendations | All Recommendations |

## Kubernetes Cluster Requirements

### Install metric-server

Make sure [metrics-server](https://github.com/kubernetes-sigs/metrics-server/tree/master/charts/metrics-server) is installed for VPA to work by running below commands.

```bash
kubectl top pods
kubectl top nodes
```

### Install VPA (Recommender Only)

```bash
helm repo add fairwinds-stable https://charts.fairwinds.com/stable

helm repo update fairwinds-stable

# get the custom values yaml for fairwinds/vpa chart
curl -LO https://raw.githubusercontent.com/oguzhan-yilmaz/powerpipe-mod-kubernetes-vpa-right-sizing/refs/heads/main/vpa-recommender-only.values.yaml

cat vpa-recommender-only.values.yaml


# install the helm chart w/ custom values
helm upgrade --install vpa fairwinds-stable/vpa -f vpa-recommender-only.values.yaml -n kube-system
```

### with ArgoCD

```bash
kubectl apply -f https://raw.githubusercontent.com/oguzhan-yilmaz/powerpipe-mod-kubernetes-vpa-right-sizing/refs/heads/main/vpa-argocd-application.yaml
```

## Mod Installation

Install the Powerpipe Mod

```bash
powerpipe mod install github.com/oguzhan-yilmaz/powerpipe-mod-kubernetes-vpa-right-sizing
```

Start the server and check for `Kubernetes VPA Right Sizing` mod.

```bash
powerpipe server
```

## Install steampipe-powerpipe-kubernetes

You can deploy steampipe and powerpipe as a Kubernetes Deployment using [steampipe-powerpipe-kubernetes](https://github.com/oguzhan-yilmaz/steampipe-powerpipe-kubernetes).

### with ArgoCD

```bash
kubectl apply -f https://raw.githubusercontent.com/oguzhan-yilmaz/powerpipe-mod-kubernetes-vpa-right-sizing/refs/heads/main/argocd-application.yaml
```

## Configuration

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



### [optional] Add custom PSQL functions to Steampipe DB

If you are running steampipe locally, you should do this step.

```bash
curl -LO https://raw.githubusercontent.com/oguzhan-yilmaz/powerpipe-mod-kubernetes-vpa-right-sizing/refs/heads/main/init-db.sql

# You may need to provide a password
psql postgres://steampipe@127.0.0.1:9193/steampipe -f init-db.sql
```
