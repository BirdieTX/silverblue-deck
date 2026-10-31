#!/usr/bin/env bash

set -oue pipefail

dnf5 config-manager setopt \
    terra-extras.name='Fyra Labs Extras' \
    copr:copr.fedorainfracloud.org:ublue-os:bazzite.name='Bazzite' \
    copr:copr.fedorainfracloud.org:ublue-os:bazzite-multilib.name='Bazzite Multilib' \
    copr:copr.fedorainfracloud.org:ublue-os:packages.name='Ublue Packages' \
    copr:copr.fedorainfracloud.org:ublue-os:staging.name='Ublue Staging' \
    copr:copr.fedorainfracloud.org:ycollet:audinux.name='Audinux' \
    copr:copr.fedorainfracloud.org:ycollet:audinux.priority=119 \
    copr:copr.fedorainfracloud.org:ublue-os:staging.priority=108 \
    terra.priority=89 \
    terra-extras.priority=88 \
    fedora-multimedia.priority=87 \
    terra-mesa.priority=86 \
    copr:copr.fedorainfracloud.org:ublue-os:bazzite.priority=79 \
    copr:copr.fedorainfracloud.org:ublue-os:bazzite-multilib.priority=78