#!/usr/bin/env bash

set -oue pipefail

dnf5 upgrade --allow-vendor-change --refresh -y
source /usr/lib/os-release
sed -i "s/^PRETTY_NAME=.*/PRETTY_NAME=\"Fedora Linux ${VERSION_ID} (Silverblue)\"/" /usr/lib/os-release