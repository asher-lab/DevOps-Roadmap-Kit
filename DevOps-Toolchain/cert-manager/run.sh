#!/bin/bash -eu
CONFIGURATION_PATH="$(dirname $0)/configurations"

ENVIRONMENT=$1
shift

#VERSION='v0.15.1'
NAMESPACE='cert-manager'

helm repo add jetstack https://charts.jetstack.io
helm repo update

set +u

helm upgrade --install cert-manager jetstack/cert-manager \
  --version=${VERSION} \
  --namespace ${NAMESPACE} \
  --create-namespace \
  --set installCRDs=true \
  --values ${CONFIGURATION_PATH}/values.yaml \
  --install --wait --timeout 300s ${@}
