#!/bin/bash

# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2025-present ROCKNIX (https://github.com/ROCKNIX)

# Replace es_features.cfg link by a writable file
[[ -L /storage/.emulationstation/es_features.cfg ]] && \
    rm /storage/.emulationstation/es_features.cfg && \
    cp /usr/config/emulationstation/es_features.cfg /storage/.emulationstation/es_features.cfg 

# test if vulkan device node exists
xmlstarlet sel -t -c '//core[@name="suyu-sa"]/features/feature[@name="vulkan device"]' \
    /storage/.emulationstation/es_features.cfg > /dev/null

if [[ $? -eq 0 ]]; then
   # delete vulkan device node
   xmlstarlet ed --inplace -d '//core[@name="suyu-sa"]/features/feature[@name="vulkan device"]' \
       /storage/.emulationstation/es_features.cfg
fi

# create vulkan device node
xmlstarlet ed --inplace -a '//core[@name="suyu-sa"]/features/feature[@name="graphics backend"]' -t elem -n feature -v "" \
    -i '//core[@name="suyu-sa"]/features/feature[@name="graphics backend"]/following-sibling::feature[1]' -t attr -n name -v "vulkan device" \
    /storage/.emulationstation/es_features.cfg


# create vulkan device choices
device_index=0
vulkaninfo --summary | grep "deviceName" | cut -d'=' -f2 | cut -d' ' -f2- | sort -r | while read -r device_name; do

    xmlstarlet ed --inplace -s '//core[@name="suyu-sa"]/features/feature[@name="vulkan device"]' -t elem -n choice -v "" \
    -i '//core[@name="suyu-sa"]/features/feature[@name="vulkan device"]/choice[last()]' -t attr -n name -v "$device_name" \
    -i '//core[@name="suyu-sa"]/features/feature[@name="vulkan device"]/choice[last()]' -t attr -n value -v $device_index \
    /storage/.emulationstation/es_features.cfg

	device_index=`expr $device_index + 1`
done

systemctl restart essway