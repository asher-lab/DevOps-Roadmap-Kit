#!/bin/bash -eu
CONFIGURATION_PATH="$(dirname $0)/configurations"

#ENVIRONMENT=$1
shift

VERSION='1.1'
NAMESPACE='sonarqube'

helm repo add sonarqube https://SonarSource.github.io/helm-chart-sonarqube
helm repo update

set +u

helm upgrade --install sonarqube sonarqube/sonarqube \
  --version=${VERSION} -n ${NAMESPACE} \
  --namespace ${NAMESPACE} \
  --create-namespace \
  --values ${CONFIGURATION_PATH}/values.yaml \
  --install --wait --timeout 300s ${@}
 # --insecure-skip-tls-verify 
