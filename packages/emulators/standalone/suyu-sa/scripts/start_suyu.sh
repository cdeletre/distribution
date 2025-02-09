#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present JELOS (https://github.com/JustEnoughLinuxOS)

. /etc/profile

#Check if suyu exists in .config
if [ ! -d "/storage/.config/suyu" ]; then
    mkdir -p "/storage/.config/suyu"
        cp -r "/usr/config/suyu" "/storage/.config/"
fi

#Check if qt-config.ini exists in .config/suyu
if [ ! -f "/storage/.config/suyu/qt-config.ini" ]; then
        cp -r "/usr/config/suyu/qt-config.ini" "/storage/.config/suyu/qt-config.ini"
fi

#Move Nand / Saves to switch roms folder
if [ ! -d "/storage/roms/bios/suyu/nand" ]; then
    mkdir -p "/storage/roms/bios/suyu/nand"
fi
rm -rf /storage/.config/suyu/nand
ln -sf /storage/roms/bios/suyu/nand /storage/.config/suyu/nand

#Link suyu keys to bios folder
if [ ! -d "/storage/roms/bios/suyu/keys" ]; then
    mkdir -p "/storage/roms/bios/suyu/keys"
fi
rm -rf /storage/.config/suyu/keys
ln -sf /storage/roms/bios/suyu/keys /storage/.config/suyu/keys

#Emulation Station Features
GAME=$(echo "${1}"| sed "s#^/.*/##")
AF=$(get_setting anisotropic_filtering switch "${GAME}")
AA=$(get_setting anti_aliasing switch "${GAME}")
ASPECT=$(get_setting aspect_ratio switch "${GAME}")
ASTCD=$(get_setting astc_decoding_method switch "${GAME}")
ASTCR=$(get_setting astc_recompress switch "${GAME}")
CPUACCURACY=$(get_setting cpu_accuracy switch "${GAME}")
CPUBACKEND=$(get_setting cpu_backend switch "${GAME}")
GPUACCURACY=$(get_setting gpu_accuracy switch "${GAME}")
GPURENDERER=$(get_setting graphics_backend switch "${GAME}")
IRES=$(get_setting internal_resolution switch "${GAME}")
PFILTER=$(get_setting pixel_filter switch "${GAME}")
RUMBLE=$(get_setting rumble switch "${GAME}")
RUMBLESTR=$(get_setting rumble_strength switch "${GAME}")
SDOCK=$(get_setting switch_mode switch "${GAME}")
SUI=$(get_setting start_ui switch "${GAME}")
VSYNC=$(get_setting vsync switch "${GAME}")

#Anisotropic Filtering
# src/common/settings_enums.h ENUM(AnisotropyMode, Automatic, Default, X2, X4, X8, X16);
sed -i '/^max_anisotropy\\default=/c\max_anisotropy\\default=false' /storage/.config/suyu/qt-config.ini
if [ "$AF" = "0" ]; then
	sed -i '/^max_anisotropy=/c\max_anisotropy=0' /storage/.config/suyu/qt-config.ini
elif [ "$AF" = "1" ]; then
	sed -i '/^max_anisotropy=/c\max_anisotropy=1' /storage/.config/suyu/qt-config.ini
elif [ "$AF" = "2" ]; then
	sed -i '/^max_anisotropy=/c\max_anisotropy=2' /storage/.config/suyu/qt-config.ini
elif [ "$AF" = "3" ]; then
	sed -i '/^max_anisotropy=/c\max_anisotropy=3' /storage/.config/suyu/qt-config.ini
elif [ "$AF" = "4" ]; then
	sed -i '/^max_anisotropy=/c\max_anisotropy=4' /storage/.config/suyu/qt-config.ini
else
	sed -i '/^max_anisotropy\\default=/c\max_anisotropy\\default=true' /storage/.config/suyu/qt-config.ini
fi

#Anti-Aliasing
# src/common/settings_enums.h ENUM(AntiAliasing, None, Fxaa, Smaa, MaxEnum);
sed -i '/^anti_aliasing\\default=/c\anti_aliasing\\default=false' /storage/.config/suyu/qt-config.ini
if [ "$AA" = "0" ]; then
	sed -i '/^anti_aliasing=/c\anti_aliasing=0' /storage/.config/suyu/qt-config.ini
elif [ "$AA" = "1" ]; then
	sed -i '/^anti_aliasing=/c\anti_aliasing=1' /storage/.config/suyu/qt-config.ini
elif [ "$AA" = "2" ]; then
	sed -i '/^anti_aliasing=/c\anti_aliasing=2' /storage/.config/suyu/qt-config.ini
else
	sed -i '/^anti_aliasing\\default=/c\anti_aliasing\\default=true' /storage/.config/suyu/qt-config.ini
fi

#Aspect Ratio
# src/common/settings_enums.h ENUM(AspectRatio, R16_9, R4_3, R21_9, R16_10, R32_9, Stretch);
sed -i '/^aspect_ratio\\default=/c\aspect_ratio\\default=false' /storage/.config/suyu/qt-config.ini
if [ "$ASPECT" = "0" ]; then
	sed -i '/^aspect_ratio=/c\aspect_ratio=0' /storage/.config/suyu/qt-config.ini
elif [ "$ASPECT" = "1" ]; then
	sed -i '/^aspect_ratio=/c\aspect_ratio=1' /storage/.config/suyu/qt-config.ini
elif [ "$ASPECT" = "2" ]; then
	sed -i '/^aspect_ratio=/c\aspect_ratio=2' /storage/.config/suyu/qt-config.ini
elif [ "$ASPECT" = "3" ]; then
	sed -i '/^aspect_ratio=/c\aspect_ratio=3' /storage/.config/suyu/qt-config.ini
elif [ "$ASPECT" = "4" ]; then
	sed -i '/^aspect_ratio=/c\aspect_ratio=4' /storage/.config/suyu/qt-config.ini
elif [ "$ASPECT" = "5" ]; then
	sed -i '/^aspect_ratio=/c\aspect_ratio=5' /storage/.config/suyu/qt-config.ini
else
	sed -i '/^aspect_ratio\\default=/c\aspect_ratio\\default=true' /storage/.config/suyu/qt-config.ini
fi

#ASTC Acceleration (default to 1/GPU)
# src/common/settings_enums.h ENUM(AstcDecodeMode, Cpu, Gpu, CpuAsynchronous);
sed -i '/^accelerate_astc\\default=/c\accelerate_astc\\default=false' /storage/.config/suyu/qt-config.ini
if [ "$ASTCD" = "0" ]; then
	sed -i '/^accelerate_astc=/c\accelerate_astc=0' /storage/.config/suyu/qt-config.ini
elif [ "$ASTCD" = "1" ]; then
	sed -i '/^accelerate_astc=/c\accelerate_astc=1' /storage/.config/suyu/qt-config.ini
elif [ "$ASTCD" = "2" ]; then
	sed -i '/^accelerate_astc=/c\accelerate_astc=2' /storage/.config/suyu/qt-config.ini
else
	sed -i '/^accelerate_astc\\default=/c\accelerate_astc\\default=true' /storage/.config/suyu/qt-config.ini
fi

#ASTC Recompress
# src/common/settings_enums.h ENUM(AstcRecompression, Uncompressed, Bc1, Bc3);
sed -i '/^astc_recompression\\default=/c\astc_recompression\\default=false' /storage/.config/suyu/qt-config.ini
if [ "$ASTCR" = "0" ]; then
	sed -i '/^astc_recompression=/c\astc_recompression=0' /storage/.config/suyu/qt-config.ini
elif [ "$ASTCR" = "1" ]; then
	sed -i '/^astc_recompression=/c\astc_recompression=1' /storage/.config/suyu/qt-config.ini
elif [ "$ASTCR" = "2" ]; then
	sed -i '/^astc_recompression=/c\astc_recompression=2' /storage/.config/suyu/qt-config.ini
else
	sed -i '/^astc_recompression\\default=/c\astc_recompression\\default=true' /storage/.config/suyu/qt-config.ini
fi

#CPU Backend
# src/common/settings_enums.h ENUM(CpuBackend, Dynarmic, Nce);
sed -i '/^cpu_backend\\default=/c\cpu_backend\\default=false' /storage/.config/suyu/qt-config.ini
if [ "$CPUBACKEND" = "0" ]; then
	sed -i '/^cpu_backend=/c\cpu_backend=0' /storage/.config/suyu/qt-config.ini
elif [ "$CPUBACKEND" = "1" ]; then
	sed -i '/^cpu_backend=/c\cpu_backend=1' /storage/.config/suyu/qt-config.ini
else
	sed -i '/^cpu_backend\\default=/c\cpu_backend\\default=true' /storage/.config/suyu/qt-config.ini
fi

#CPU Accuracy
# src/common/settings_enums.h ENUM(CpuAccuracy, Auto, Accurate, Unsafe, Paranoid);
sed -i '/^cpu_accuracy\\default=/c\cpu_accuracy\\default=false' /storage/.config/suyu/qt-config.ini
if [ "$CPUACCURACY" = "0" ]; then
	sed -i '/^cpu_accuracy=/c\cpu_accuracy=0' /storage/.config/suyu/qt-config.ini
elif [ "$CPUACCURACY" = "1" ]; then
	sed -i '/^cpu_accuracy=/c\cpu_accuracy=1' /storage/.config/suyu/qt-config.ini
elif [ "$CPUACCURACY" = "2" ]; then
	sed -i '/^cpu_accuracy=/c\cpu_accuracy=2' /storage/.config/suyu/qt-config.ini
elif [ "$CPUACCURACY" = "3" ]; then
	sed -i '/^cpu_accuracy=/c\cpu_accuracy=3' /storage/.config/suyu/qt-config.ini
else
	sed -i '/^cpu_accuracy\\default=/c\cpu_accuracy\\default=true' /storage/.config/suyu/qt-config.ini
fi

#GPU Accuracy
# src/common/settings_enums.h ENUM(GpuAccuracy, Normal, High, Extreme);
sed -i '/^gpu_accuracy\\default=/c\gpu_accuracy\\default=false' /storage/.config/suyu/qt-config.ini
if [ "$GPUACCURACY" = "0" ]; then
	sed -i '/^gpu_accuracy=/c\gpu_accuracy=0' /storage/.config/suyu/qt-config.ini
elif [ "$GPUACCURACY" = "1" ]; then
	sed -i '/^gpu_accuracy=/c\gpu_accuracy=1' /storage/.config/suyu/qt-config.ini
elif [ "$GPUACCURACY" = "2" ]; then
	sed -i '/^gpu_accuracy=/c\gpu_accuracy=2' /storage/.config/suyu/qt-config.ini
else
	sed -i '/^gpu_accuracy\\default=/c\gpu_accuracy\\default=true' /storage/.config/suyu/qt-config.ini
fi

#Graphics Backend
# src/common/settings_enums.h ENUM(RendererBackend, OpenGL, Vulkan, Null);
sed -i '/^backend\\default=/c\backend\\default=false' /storage/.config/suyu/qt-config.ini
if [ "$GPURENDERER" = "0" ]; then
	sed -i '/^backend=/c\backend=0' /storage/.config/suyu/qt-config.ini
elif [ "$GPURENDERER" = "1" ]; then
	sed -i '/^backend=/c\backend=1' /storage/.config/suyu/qt-config.ini
else
	sed -i '/^backend\\default=/c\backend\\default=true' /storage/.config/suyu/qt-config.ini
fi

#Internal Resolution
# src/common/settings_enums.h ENUM(ResolutionSetup, Res1_2X, Res3_4X, Res1X, Res3_2X, Res2X, Res3X, Res4X, Res5X, Res6X, Res7X, Res8X);
sed -i '/^resolution_setup\\default=/c\resolution_setup\\default=false' /storage/.config/suyu/qt-config.ini
if [ "$IRES" = "0" ]; then
	sed -i '/^resolution_setup=/c\resolution_setup=0' /storage/.config/suyu/qt-config.ini
elif [ "$IRES" = "1" ]; then
	sed -i '/^resolution_setup=/c\resolution_setup=1' /storage/.config/suyu/qt-config.ini
elif [ "$IRES" = "2" ]; then
	sed -i '/^resolution_setup=/c\resolution_setup=2' /storage/.config/suyu/qt-config.ini
else
	sed -i '/^resolution_setup\\default=/c\resolution_setup\\default=true' /storage/.config/suyu/qt-config.ini
fi

#Pixel Filter
# src/common/settings_enums.h ENUM(ScalingFilter, NearestNeighbor, Bilinear, Bicubic, Gaussian, ScaleForce, Fsr, MaxEnum);
sed -i '/^scaling_filter\\default=/c\scaling_filter\\default=false' /storage/.config/suyu/qt-config.ini
if [ "$PFILTER" = "0" ]; then
	sed -i '/^scaling_filter=/c\scaling_filter=0' /storage/.config/suyu/qt-config.ini
elif [ "$PFILTER" = "1" ]; then
	sed -i '/^scaling_filter=/c\scaling_filter=1' /storage/.config/suyu/qt-config.ini
elif [ "$PFILTER" = "2" ]; then
	sed -i '/^scaling_filter=/c\scaling_filter=2' /storage/.config/suyu/qt-config.ini
elif [ "$PFILTER" = "3" ]; then
	sed -i '/^scaling_filter=/c\scaling_filter=3' /storage/.config/suyu/qt-config.ini
elif [ "$PFILTER" = "4" ]; then
	sed -i '/^scaling_filter =/c\scaling_filter=4' /storage/.config/suyu/qt-config.ini
elif [ "$PFILTER" = "5" ]; then
	sed -i '/^scaling_filter =/c\scaling_filter=5' /storage/.config/suyu/qt-config.ini
else
	sed -i '/^scaling_filter\\default=/c\scaling_filter\\default=true' /storage/.config/suyu/qt-config.ini
fi

#RUMBLE
sed -i '/^vibration_enabled\\default=/c\vibration_enabled\\default=false' /storage/.config/suyu/qt-config.ini
if [ "$RUMBLE" = "0" ]; then
	sed -i '/^vibration_enabled=/c\vibration_enabled=false' /storage/.config/suyu/qt-config.ini
elif [ "$RUMBLE" = "1" ]; then
	sed -i '/^vibration_enabled=/c\vibration_enabled=true' /storage/.config/suyu/qt-config.ini
else
	sed -i '/^vibration_enabled\\default=/c\vibration_enabled\\default=true' /storage/.config/suyu/qt-config.ini
fi

#RUMBLE STRENGTH
sed -i '/^player_0_vibration_strength\\default=/c\player_0_vibration_strength\\default=false' /storage/.config/suyu/qt-config.ini
if [ "$RUMBLESTR" = "100" ]; then
	sed -i '/^player_0_vibration_strength=/c\player_0_vibration_strength=100' /storage/.config/suyu/qt-config.ini
elif [ "$RUMBLESTR" = "75" ]; then
		sed -i '/^player_0_vibration_strength=/c\player_0_vibration_strength=75' /storage/.config/suyu/qt-config.ini
elif [ "$RUMBLESTR" = "50" ]; then
		sed -i '/^player_0_vibration_strength=/c\player_0_vibration_strength=50' /storage/.config/suyu/qt-config.ini
elif [ "$RUMBLESTR" = "25" ]; then
		sed -i '/^player_0_vibration_strength=/c\player_0_vibration_strength=25' /storage/.config/suyu/qt-config.ini
else
	sed -i '/^player_0_vibration_strength\\default=/c\player_0_vibration_strength\\default=true' /storage/.config/suyu/qt-config.ini
fi

#Switch Mode
sed -i '/^use_docked_mode\\default=/c\use_docked_mode\\default=false' /storage/.config/suyu/qt-config.ini
if [ "$SDOCK" = "0" ]; then
	sed -i '/^use_docked_mode=/c\use_docked_mode=0' /storage/.config/suyu/qt-config.ini
elif [ "$SDOCK" = "1" ]; then
	sed -i '/^use_docked_mode=/c\use_docked_mode=1' /storage/.config/suyu/qt-config.ini
else
	sed -i '/^use_docked_mode\\default=/c\use_docked_mode\\default=true' /storage/.config/suyu/qt-config.ini
fi

#Vysnc
# src/common/settings_enums.h ENUM(VSyncMode, Immediate, Mailbox, Fifo, FifoRelaxed);
sed -i '/^use_vsync\\default=/c\use_vsync\\default=false' /storage/.config/suyu/qt-config.ini
if [ "$VSYNC" = "0" ]; then
	sed -i '/^use_vsync=/c\use_vsync=0' /storage/.config/suyu/qt-config.ini
elif [ "$VSYNC" = "1" ]; then
	sed -i '/^use_vsync=/c\use_vsync=1' /storage/.config/suyu/qt-config.ini
elif [ "$VSYNC" = "2" ]; then
	sed -i '/^use_vsync=/c\use_vsync=2' /storage/.config/suyu/qt-config.ini
elif [ "$VSYNC" = "3" ]; then
	sed -i '/^use_vsync=/c\use_vsync=3' /storage/.config/suyu/qt-config.ini
else
	sed -i '/^use_vsync\\default=/c\use_vsync\\default=true' /storage/.config/suyu/qt-config.ini
fi

#Never ask to confrim close
sed -i '/^confirmStop\\default=/c\confirmStop\\default=false' /storage/.config/suyu/qt-config.ini
sed -i '/^confirmStop=/c\confirmStop=3' /storage/.config/suyu/qt-config.ini

#Link  .config/suyu to .local
rm -rf /storage/.local/share/suyu
ln -sf /storage/.config/suyu /storage/.local/share/suyu

#Set QT Platform to Wayland-EGL
export QT_QPA_PLATFORM=wayland-egl

#Suyu won't work with the pipewire driver yet
export SDL_AUDIODRIVER=pulseaudio

set_kill set "-9 suyu"

#Run Suyu emulator
/usr/bin/suyu -f -g "${1}"
