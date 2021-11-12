#!/bin/bash -eu
set -e
helm uninstall -n devops-gitlab devops-gitlab || true
kubectl delete all --all -n devops-gitlab || true
kubectl delete secret --all -n devops-gitlab || true
echo "Done!!!!"
