#!/bin/bash
# Deploy Kubernetes manifests for Alertmanager and Prometheus

#set -x # Uncomment for debugging -  Prints each command before execution
set -e # Exit immediately if a command exits with a non-zero status.

# --- Configuration ---
NAMESPACE=" s5ndeye-monitoring"
MANIFEST_DIR="./" # Assuming manifests are in the same directory

# --- Helper Functions ---

# Function to apply a Kubernetes manifest
apply_manifest() {
  local manifest_file="$1"
  echo "Applying manifest: $manifest_file to namespace: $NAMESPACE"
  kubectl apply -n "$NAMESPACE" -f "$manifest_file"
  if [ $? -ne 0 ]; then
    echo "Error applying manifest: $manifest_file"
    exit 1
  fi
  echo "Manifest $manifest_file applied successfully."
}

# --- Main Script ---

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
  echo "kubectl is not installed. Please install it and try again."
  exit 1
fi

# Check if the namespace exists, create if it doesn't.
kubectl get namespace "$NAMESPACE" &> /dev/null
if [ $? -ne 0 ]; then
  echo "Namespace '$NAMESPACE' does not exist. Creating..."
  kubectl create namespace "$NAMESPACE"
  if [ $? -ne 0 ]; then
    echo "Failed to create namespace '$NAMESPACE'."
    exit 1
  fi
  echo "Namespace '$NAMESPACE' created."
  sleep 2 # Wait for namespace creation to propagate.
else
  echo "Namespace '$NAMESPACE' already exists."
fi

# Apply manifests with sleeps
apply_manifest "$MANIFEST_DIR/prometheus-serviceaccount.yml"
sleep 2
apply_manifest "$MANIFEST_DIR/prometheus-configmap.yml"
sleep 2
apply_manifest "$MANIFEST_DIR/prometheus-service.yml"
sleep 2
apply_manifest "$MANIFEST_DIR/prometheus-server.yml"
sleep 5 # Give Prometheus server more time to start.
apply_manifest "$MANIFEST_DIR/prometheus-alerts-rules.yml"
sleep 2
apply_manifest "$MANIFEST_DIR/alertmanager-config.yml"
sleep 2
apply_manifest "$MANIFEST_DIR/alertmanager-service.yml"
sleep 2
apply_manifest "$MANIFEST_DIR/alertmanager-deployment.yml"
sleep 5 # Give Alertmanager deployment time.
apply_manifest "$MANIFEST_DIR/alertmanager-secret.yml"
sleep 2
apply_manifest "$MANIFEST_DIR/k8s-job.yml"
sleep 2
apply_manifest "$MANIFEST_DIR/prometheus-RBAC.yml"

echo "All manifests applied successfully."
echo "Prometheus and Alertmanager deployed in namespace '$NAMESPACE'."
