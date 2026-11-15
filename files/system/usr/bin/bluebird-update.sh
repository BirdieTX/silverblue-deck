#!/usr/bin/env bash

echo "Checking for updates from bluebird..."
rpm-ostree upgrade

if rpm-ostree status --json | jq -e '.deployments[] | select(.staged == true)' >/dev/null; then
    echo
    echo "Restart this system to install updates..."
else
    echo
    echo "No updates available..."
fi

echo
read -r -p "Press Enter to close..."