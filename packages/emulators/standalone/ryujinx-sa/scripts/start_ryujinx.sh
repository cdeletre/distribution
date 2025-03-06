#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later

. /etc/profile
set_kill set "-9 Ryujinx"

if [ ! -d "/storage/.config/Ryujinx" ]; then
    mkdir -p "/storage/.config/Ryujinx"
        cp -r "/usr/config/Ryujinx" "/storage/.config/"
fi

#Move ryujinx nand to bios folder
if [ ! -d "/storage/roms/bios/ryujinx/nand" ]; then
    mkdir -p "/storage/roms/bios/ryujinx/nand"
fi
rm -rf /storage/.config/Ryujinx/bis/system/Contents/registered
mkdir -p /storage/.config/Ryujinx/bis/system/Contents/
ln -sf /storage/roms/bios/ryujinx/nand/ /storage/.config/Ryujinx/bis/system/Contents/registered

#Link ryujinx keys to bios folder
if [ ! -d "/storage/roms/bios/ryujinx/keys" ]; then
    mkdir -p "/storage/roms/bios/ryujinx/keys"
fi
rm -rf ~/.switch
ln -sf /storage/roms/bios/ryujinx/keys ~/.switch

  #Emulation Station Features
  GAME=$(echo "${1}"| sed "s#^/.*/##")
  GRENDERER=$(get_setting graphics_backend switch "${GAME}")
  SUI=$(get_setting start_ui switch "${GAME}")

  #Graphics Backend
        if [ "$GRENDERER" = "0" ]
        then
                sed -i '/^  "graphics_backend": /c\  "graphics_backend": "OpenGL",' /storage/.config/Ryujinx/Config.json
        fi
        if [ "$GRENDERER" = "1" ]
        then
                sed -i '/^  "graphics_backend": /c\  "graphics_backend": "Vulkan",' /storage/.config/Ryujinx/Config.json
        fi

# Ensure vm.max_map_count is at least 524388
	[[ `sysctl vm.max_map_count| cut -d'=' -f2` -le 524389 ]] && sysctl -w vm.max_map_count=524388

#Run Ryujinx emulator
        /usr/bin/Ryujinx "${1}"
