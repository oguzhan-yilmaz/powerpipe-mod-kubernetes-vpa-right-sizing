#!/bin/bash

# Generates VPA Manifests for Deployments + StatefulSets + DaemonSets


MANIFEST_DIR="vpa-manifests"

mkdir -p "$MANIFEST_DIR"

# Get all deployments with their namespaces and names
deployments=$(kubectl get deployments --all-namespaces -o jsonpath='{range .items[*]}{.metadata.namespace}{" "}{.metadata.name}{"\n"}{end}')


# Loop through each deployment and echo the namespace and name
deployments_filepath="$MANIFEST_DIR/deployment_vpas.yaml"
while IFS=' ' read -r namespace deployment_name; do
    # Check if the line is empty
    if [[ -z "$namespace" && -z "$deployment_name" ]]; then
        break
    fi
    cat << EOF >> "$deployments_filepath"
---
apiVersion: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler
metadata:
  namespace: ${namespace}
  name: ${deployment_name}-vpa
spec:
  targetRef:
    apiVersion: "apps/v1"
    kind:       Deployment
    name:       ${deployment_name}
  updatePolicy:
    updateMode: "Off"
EOF
done <<< "$deployments"



# Get all statefulsets with their namespaces and names
statefulsets=$(kubectl get statefulsets --all-namespaces -o jsonpath='{range .items[*]}{.metadata.namespace}{" "}{.metadata.name}{"\n"}{end}')

statefulsets_filepath="$MANIFEST_DIR/statefulset_vpas.yaml"
while IFS=' ' read -r namespace statefulset_name; do
    # Check if the line is empty
    if [[ -z "$namespace" && -z "$statefulset_name" ]]; then
        break
    fi
    cat << EOF >> "$statefulsets_filepath"
---
apiVersion: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler
metadata:
  namespace: ${namespace}
  name: ${statefulset_name}-vpa
spec:
  targetRef:
    apiVersion: "apps/v1"
    kind:       StatefulSet
    name:       ${statefulset_name}
  updatePolicy:
    updateMode: "Off"
EOF
done <<< "$statefulsets"



daemonsets=$(kubectl get daemonsets --all-namespaces -o jsonpath='{range .items[*]}{.metadata.namespace}{" "}{.metadata.name}{"\n"}{end}')
daemonsets_filepath="$MANIFEST_DIR/daemonset_vpas.yaml"

while IFS=' ' read -r namespace daemonset_name; do
    # Check if the line is empty
    if [[ -z "$namespace" && -z "$daemonset_name" ]]; then
        break
    fi
    cat << EOF >> "$daemonsets_filepath"
---
apiVersion: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler
metadata:
  namespace: ${namespace}
  name: ${daemonset_name}-vpa
spec:
  targetRef:
    apiVersion: "apps/v1"
    kind:       DaemonSet
    name:       ${daemonset_name}
  updatePolicy:
    updateMode: "Off"
EOF
done <<< "$daemonsets"

echo "Recommender VPA manifests are written to: $MANIFEST_DIR"
echo ""
echo "Apply with:"
echo ""
echo "kubectl apply -f $deployments_filepath"
echo "kubectl apply -f $statefulsets_filepath"
echo "kubectl apply -f $daemonsets_filepath"



echo ""
echo "Delete with:"
echo ""
echo "kubectl delete -f $deployments_filepath"
echo "kubectl delete -f $statefulsets_filepath"
echo "kubectl delete -f $daemonsets_filepath"

