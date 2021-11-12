#!/bin/bash -eu
CONFIGURATION_PATH="$(dirname $0)/configurations"

ENVIRONMENT=$1
shift

VERSION='5.4.1' # https://docs.gitlab.com/charts/installation/version_mappings.html
NAMESPACE='gitlab'

helm repo add gitlab https://charts.gitlab.io/
helm repo update

set +u

helm upgrade --install gitlab gitlab/gitlab \
  --version=${VERSION} -n ${NAMESPACE} \
  --set global.hosts.domain=codeops.ml \
  --set global.hosts.externalIP=20.120.122.45 \
  --set global.ingress.annotations."kubernetes\.io/tls-acme"=true \
  --set certmanager-issuer.email=mananganasher01@gmail.com \
  --namespace ${NAMESPACE} \
  --create-namespace \
    --values ${CONFIGURATION_PATH}/values.yaml \
    #--values ${CONFIGURATION_PATH}/${ENVIRONMENT}/values.yaml \
    --install --wait --timeout 700s ${@}
  