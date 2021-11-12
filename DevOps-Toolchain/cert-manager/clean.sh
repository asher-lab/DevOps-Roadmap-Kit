#!/bin/bash -eu
set -e
helm uninstall -n cert-manager cert-manager || true
echo "Done!!!!"
