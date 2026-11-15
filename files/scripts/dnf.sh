#!/usr/bin/env bash

set -oue pipefail

dnf5 config-manager setopt \
  copr:copr.fedorainfracloud.org:ublue-os:bazzite.name='Bazzite' \
  copr:copr.fedorainfracloud.org:ublue-os:bazzite-multilib.name='Bazzite Multilib' \
  copr:copr.fedorainfracloud.org:ublue-os:packages.name='Ublue Packages' \
  copr:copr.fedorainfracloud.org:ublue-os:staging.name='Ublue Staging' \
  copr:copr.fedorainfracloud.org:ycollet:audinux.name='Audinux' \
  fedora.name='Fedora Core' \
  fedora-cisco-openh264.name='Cisco OpenH264' \
  fedora-cisco-openh264-debuginfo.name='Cisco OpenH264 (debug)' \
  fedora-cisco-openh264-source.name='Cisco OpenH264 (source)' \
  fedora-debuginfo.name='Fedora Core (debug)' \
  fedora-multimedia.name='Fedora Multimedia' \
  fedora-multimedia-debug.name='Fedora Multimedia (debug)' \
  fedora-multimedia-source.name='Fedora Multimedia (source)' \
  fedora-rar.name='RAR Archiver' \
  fedora-rar-debug.name='RAR Archiver (debug)' \
  fedora-rar-source.name='RAR Archiver (source)' \
  fedora-source.name='Fedora Core (source)' \
  terra.name='Fyra Labs Terra' \
  terra-extras.name='Fyra Labs Extras' \
  terra-mesa.name='Fyra Labs Mesa' \
  terra-mesa-source.name='Fyra Labs Mesa (source)' \
  updates.name='Fedora Updates' \
  updates-archive.name='Archived Updates' \
  updates-debuginfo.name='Fedora Updates (debug)' \
  updates-source.name='Fedora Updates (source)' \
  updates-testing.name='Fedora Test Updates' \
  updates-testing-debuginfo.name='Fedora Test Updates (debug)' \
  updates-testing-source.name='Fedora Test Updates (source)'

dnf5 config-manager setopt \
  copr:copr.fedorainfracloud.org:ublue-os:bazzite.priority=89 \
  copr:copr.fedorainfracloud.org:ublue-os:bazzite-multilib.priority=88 \
  copr:copr.fedorainfracloud.org:ublue-os:packages.priority=109 \
  copr:copr.fedorainfracloud.org:ublue-os:staging.priority=108 \
  copr:copr.fedorainfracloud.org:ycollet:audinux.priority=119 \
  fedora.priority=99 \
  fedora-cisco-openh264.priority=97 \
  fedora-cisco-openh264-debuginfo.priority=97 \
  fedora-cisco-openh264-source.priority=97 \
  fedora-multimedia.priority=79 \
  fedora-debuginfo.priority=99 \
  fedora-multimedia-debug.priority=79 \
  fedora-multimedia-source.priority=79 \
  fedora-rar.priority=88 \
  fedora-rar-debug.priority=88 \
  fedora-rar-source.priority=88 \
  fedora-source.priority=99 \
  terra.priority=79 \
  terra-extras.priority=77 \
  terra-mesa.priority=76 \
  terra-mesa-source.priority=76 \
  updates.priority=98 \
  updates-archive.priority=119 \
  updates-debuginfo.priority=98 \
  updates-source.priority=98 \
  updates-testing.priority=98 \
  updates-testing-debuginfo.priority=98 \
  updates-testing-source.priority=98

dnf5 config-manager setopt \
  copr:copr.fedorainfracloud.org:ycollet:audinux.exclude="kernel*"
