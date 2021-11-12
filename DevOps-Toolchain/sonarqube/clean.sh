#!/bin/bash -eu
set -e
helm uninstall -n sonarqube sonarqube || true
kubectl delete all --all -n sonarqube || true
kubectl delete secret --all -n sonarqube || true
echo "Done!!!!"
