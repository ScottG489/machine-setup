#!/bin/bash
set -ex

readonly ETH_DEVICE=$(ip addr | grep enp | head -1 | awk '{print $2}' | rev | cut -c 2- | rev)

ethtool --change "$ETH_DEVICE" wol g
