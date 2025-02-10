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
CPU_ACCURACY=$(get_setting cpu_accuracy switch "${GAME}")
CPU_BACKEND=$(get_setting cpu_backend switch "${GAME}")
GPU_BACKEND=$(get_setting graphics_backend switch "${GAME}")
ASTC_DECODING=$(get_setting astc_decoding_method switch "${GAME}")
VSYNC=$(get_setting vsync switch "${GAME}")
ASPEC_TRATIO=$(get_setting aspect_ratio switch "${GAME}")
INTERNAL_RESOLUTION=$(get_setting internal_resolution switch "${GAME}")
WINDOW_ADAPTING_FILTER=$(get_setting window_adapting_filter switch "${GAME}")
ANTI_ALIASING=$(get_setting anti_aliasing switch "${GAME}")
GPU_ACCURACY=$(get_setting gpu_accuracy switch "${GAME}")
ANISOTROPIC_FILTER=$(get_setting anisotropic_filtering switch "${GAME}")
ASTC_RECOMPRESSION=$(get_setting astc_recompress switch "${GAME}")
VRAM_USAGE_MODE=$(get_setting vram_usage_mode switch "${GAME}")
ASYNC_PRESENTATION=$(get_setting async_presentation switch "${GAME}")
ASYNC_SHADERS=$(get_setting asynchronous_shader switch "${GAME}")
FAST_GPU_TIME=$(get_setting fast_gpu_time switch "${GAME}")
RUMBLE=$(get_setting rumble switch "${GAME}")
RUMBLE_STRENGTH=$(get_setting rumble_strength switch "${GAME}")
SWITCH_MODE=$(get_setting switch_mode switch "${GAME}")

#CPU Accuracy
# src/common/settings_enums.h ENUM(CpuAccuracy, Auto, Accurate, Unsafe, Paranoid);
sed -i '/^cpu_accuracy\\default=/c\cpu_accuracy\\default=false' /storage/.config/suyu/qt-config.ini
if [ "$CPU_ACCURACY" = "0" ]; then
	sed -i '/^cpu_accuracy=/c\cpu_accuracy=0' /storage/.config/suyu/qt-config.ini
elif [ "$CPU_ACCURACY" = "1" ]; then
	sed -i '/^cpu_accuracy=/c\cpu_accuracy=1' /storage/.config/suyu/qt-config.ini
elif [ "$CPU_ACCURACY" = "2" ]; then
	sed -i '/^cpu_accuracy=/c\cpu_accuracy=2' /storage/.config/suyu/qt-config.ini
elif [ "$CPU_ACCURACY" = "3" ]; then
	sed -i '/^cpu_accuracy=/c\cpu_accuracy=3' /storage/.config/suyu/qt-config.ini
else
	sed -i '/^cpu_accuracy\\default=/c\cpu_accuracy\\default=true' /storage/.config/suyu/qt-config.ini
fi

#CPU Backend
# src/common/settings_enums.h ENUM(CpuBackend, Dynarmic, Nce);
sed -i '/^cpu_backend\\default=/c\cpu_backend\\default=false' /storage/.config/suyu/qt-config.ini
if [ "$CPU_BACKEND" = "0" ]; then
	sed -i '/^cpu_backend=/c\cpu_backend=0' /storage/.config/suyu/qt-config.ini
elif [ "$CPU_BACKEND" = "1" ]; then
	sed -i '/^cpu_backend=/c\cpu_backend=1' /storage/.config/suyu/qt-config.ini
else
	sed -i '/^cpu_backend\\default=/c\cpu_backend\\default=true' /storage/.config/suyu/qt-config.ini
fi

#Graphics Backend
# src/common/settings_enums.h ENUM(RendererBackend, OpenGL, Vulkan, Null);
sed -i '/^backend\\default=/c\backend\\default=false' /storage/.config/suyu/qt-config.ini
if [ "$GPU_BACKEND" = "0" ]; then
	sed -i '/^backend=/c\backend=0' /storage/.config/suyu/qt-config.ini
elif [ "$GPU_BACKEND" = "1" ]; then
	sed -i '/^backend=/c\backend=1' /storage/.config/suyu/qt-config.ini
else
	sed -i '/^backend\\default=/c\backend\\default=true' /storage/.config/suyu/qt-config.ini
fi

#ASTC Acceleration (default to 1/GPU)
# src/common/settings_enums.h ENUM(ASTC_DECODINGecodeMode, Cpu, Gpu, CpuAsynchronous);
sed -i '/^accelerate_astc\\default=/c\accelerate_astc\\default=false' /storage/.config/suyu/qt-config.ini
if [ "$ASTC_DECODING" = "0" ]; then
	sed -i '/^accelerate_astc=/c\accelerate_astc=0' /storage/.config/suyu/qt-config.ini
elif [ "$ASTC_DECODING" = "1" ]; then
	sed -i '/^accelerate_astc=/c\accelerate_astc=1' /storage/.config/suyu/qt-config.ini
elif [ "$ASTC_DECODING" = "2" ]; then
	sed -i '/^accelerate_astc=/c\accelerate_astc=2' /storage/.config/suyu/qt-config.ini
else
	sed -i '/^accelerate_astc\\default=/c\accelerate_astc\\default=true' /storage/.config/suyu/qt-config.ini
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

#Aspect Ratio
# src/common/settings_enums.h ENUM(AspectRatio, R16_9, R4_3, R21_9, R16_10, R32_9, Stretch);
sed -i '/^aspect_ratio\\default=/c\aspect_ratio\\default=false' /storage/.config/suyu/qt-config.ini
if [ "$ASPEC_TRATIO" = "0" ]; then
	sed -i '/^aspect_ratio=/c\aspect_ratio=0' /storage/.config/suyu/qt-config.ini
elif [ "$ASPEC_TRATIO" = "1" ]; then
	sed -i '/^aspect_ratio=/c\aspect_ratio=1' /storage/.config/suyu/qt-config.ini
elif [ "$ASPEC_TRATIO" = "2" ]; then
	sed -i '/^aspect_ratio=/c\aspect_ratio=2' /storage/.config/suyu/qt-config.ini
elif [ "$ASPEC_TRATIO" = "3" ]; then
	sed -i '/^aspect_ratio=/c\aspect_ratio=3' /storage/.config/suyu/qt-config.ini
elif [ "$ASPEC_TRATIO" = "4" ]; then
	sed -i '/^aspect_ratio=/c\aspect_ratio=4' /storage/.config/suyu/qt-config.ini
elif [ "$ASPEC_TRATIO" = "5" ]; then
	sed -i '/^aspect_ratio=/c\aspect_ratio=5' /storage/.config/suyu/qt-config.ini
else
	sed -i '/^aspect_ratio\\default=/c\aspect_ratio\\default=true' /storage/.config/suyu/qt-config.ini
fi

#Internal Resolution
# src/common/settings_enums.h ENUM(ResolutionSetup, Res1_2X, Res3_4X, Res1X, Res3_2X, Res2X, Res3X, Res4X, Res5X, Res6X, Res7X, Res8X);
sed -i '/^resolution_setup\\default=/c\resolution_setup\\default=false' /storage/.config/suyu/qt-config.ini
if [ "$INTERNAL_RESOLUTION" = "0" ]; then
	sed -i '/^resolution_setup=/c\resolution_setup=0' /storage/.config/suyu/qt-config.ini
elif [ "$INTERNAL_RESOLUTION" = "1" ]; then
	sed -i '/^resolution_setup=/c\resolution_setup=1' /storage/.config/suyu/qt-config.ini
elif [ "$INTERNAL_RESOLUTION" = "2" ]; then
	sed -i '/^resolution_setup=/c\resolution_setup=2' /storage/.config/suyu/qt-config.ini
else
	sed -i '/^resolution_setup\\default=/c\resolution_setup\\default=true' /storage/.config/suyu/qt-config.ini
fi

#Window adapting Filter
# src/common/settings_enums.h ENUM(ScalingFilter, NearestNeighbor, Bilinear, Bicubic, Gaussian, ScaleForce, Fsr, MaxEnum);
sed -i '/^scaling_filter\\default=/c\scaling_filter\\default=false' /storage/.config/suyu/qt-config.ini
if [ "$WINDOW_ADAPTING_FILTER" = "0" ]; then
	sed -i '/^scaling_filter=/c\scaling_filter=0' /storage/.config/suyu/qt-config.ini
elif [ "$WINDOW_ADAPTING_FILTER" = "1" ]; then
	sed -i '/^scaling_filter=/c\scaling_filter=1' /storage/.config/suyu/qt-config.ini
elif [ "$WINDOW_ADAPTING_FILTER" = "2" ]; then
	sed -i '/^scaling_filter=/c\scaling_filter=2' /storage/.config/suyu/qt-config.ini
elif [ "$WINDOW_ADAPTING_FILTER" = "3" ]; then
	sed -i '/^scaling_filter=/c\scaling_filter=3' /storage/.config/suyu/qt-config.ini
elif [ "$WINDOW_ADAPTING_FILTER" = "4" ]; then
	sed -i '/^scaling_filter =/c\scaling_filter=4' /storage/.config/suyu/qt-config.ini
elif [ "$WINDOW_ADAPTING_FILTER" = "5" ]; then
	sed -i '/^scaling_filter =/c\scaling_filter=5' /storage/.config/suyu/qt-config.ini
else
	sed -i '/^scaling_filter\\default=/c\scaling_filter\\default=true' /storage/.config/suyu/qt-config.ini
fi

#Anti-Aliasing
# src/common/settings_enums.h ENUM(AntiAliasing, None, Fxaa, Smaa, MaxEnum);
sed -i '/^anti_aliasing\\default=/c\anti_aliasing\\default=false' /storage/.config/suyu/qt-config.ini
if [ "$ANTI_ALIASING" = "0" ]; then
	sed -i '/^anti_aliasing=/c\anti_aliasing=0' /storage/.config/suyu/qt-config.ini
elif [ "$ANTI_ALIASING" = "1" ]; then
	sed -i '/^anti_aliasing=/c\anti_aliasing=1' /storage/.config/suyu/qt-config.ini
elif [ "$ANTI_ALIASING" = "2" ]; then
	sed -i '/^anti_aliasing=/c\anti_aliasing=2' /storage/.config/suyu/qt-config.ini
else
	sed -i '/^anti_aliasing\\default=/c\anti_aliasing\\default=true' /storage/.config/suyu/qt-config.ini
fi

#GPU Accuracy
# src/common/settings_enums.h ENUM(GpuAccuracy, Normal, High, Extreme);
sed -i '/^gpu_accuracy\\default=/c\gpu_accuracy\\default=false' /storage/.config/suyu/qt-config.ini
if [ "$GPU_ACCURACY" = "0" ]; then
	sed -i '/^gpu_accuracy=/c\gpu_accuracy=0' /storage/.config/suyu/qt-config.ini
elif [ "$GPU_ACCURACY" = "1" ]; then
	sed -i '/^gpu_accuracy=/c\gpu_accuracy=1' /storage/.config/suyu/qt-config.ini
elif [ "$GPU_ACCURACY" = "2" ]; then
	sed -i '/^gpu_accuracy=/c\gpu_accuracy=2' /storage/.config/suyu/qt-config.ini
else
	sed -i '/^gpu_accuracy\\default=/c\gpu_accuracy\\default=true' /storage/.config/suyu/qt-config.ini
fi

#Anisotropic Filtering
# src/common/settings_enums.h ENUM(AnisotropyMode, Automatic, Default, X2, X4, X8, X16);
sed -i '/^max_anisotropy\\default=/c\max_anisotropy\\default=false' /storage/.config/suyu/qt-config.ini
if [ "$ANISOTROPIC_FILTER" = "0" ]; then
	sed -i '/^max_anisotropy=/c\max_anisotropy=0' /storage/.config/suyu/qt-config.ini
elif [ "$ANISOTROPIC_FILTER" = "1" ]; then
	sed -i '/^max_anisotropy=/c\max_anisotropy=1' /storage/.config/suyu/qt-config.ini
elif [ "$ANISOTROPIC_FILTER" = "2" ]; then
	sed -i '/^max_anisotropy=/c\max_anisotropy=2' /storage/.config/suyu/qt-config.ini
elif [ "$ANISOTROPIC_FILTER" = "3" ]; then
	sed -i '/^max_anisotropy=/c\max_anisotropy=3' /storage/.config/suyu/qt-config.ini
elif [ "$ANISOTROPIC_FILTER" = "4" ]; then
	sed -i '/^max_anisotropy=/c\max_anisotropy=4' /storage/.config/suyu/qt-config.ini
else
	sed -i '/^max_anisotropy\\default=/c\max_anisotropy\\default=true' /storage/.config/suyu/qt-config.ini
fi

#ASTC Recompress
# src/common/settings_enums.h ENUM(AstcRecompression, Uncompressed, Bc1, Bc3);
sed -i '/^astc_recompression\\default=/c\astc_recompression\\default=false' /storage/.config/suyu/qt-config.ini
if [ "$ASTC_RECOMPRESSION" = "0" ]; then
	sed -i '/^astc_recompression=/c\astc_recompression=0' /storage/.config/suyu/qt-config.ini
elif [ "$ASTC_RECOMPRESSION" = "1" ]; then
	sed -i '/^astc_recompression=/c\astc_recompression=1' /storage/.config/suyu/qt-config.ini
elif [ "$ASTC_RECOMPRESSION" = "2" ]; then
	sed -i '/^astc_recompression=/c\astc_recompression=2' /storage/.config/suyu/qt-config.ini
else
	sed -i '/^astc_recompression\\default=/c\astc_recompression\\default=true' /storage/.config/suyu/qt-config.ini
fi

#VRAM usage mode
# src/common/settings_enums.h ENUM(VramUsageMode, Conservative, Aggressive);
sed -i '/^vram_usage_mode\\default=/c\vram_usage_mode\\default=false' /storage/.config/suyu/qt-config.ini
if [ "$VRAM_USAGE_MODE" = "0" ]; then
	sed -i '/^vram_usage_mode=/c\vram_usage_mode=0' /storage/.config/suyu/qt-config.ini
elif [ "$VRAM_USAGE_MODE" = "1" ]; then
	sed -i '/^vram_usage_mode=/c\vram_usage_mode=1' /storage/.config/suyu/qt-config.ini
else
	sed -i '/^vram_usage_mode\\default=/c\vram_usage_mode\\default=true' /storage/.config/suyu/qt-config.ini
fi

#Async Presentation
# Use a dedicated thread for presentation (vulkan only)
sed -i '/^async_presentation\\default=/c\async_presentation\\default=false' /storage/.config/suyu/qt-config.ini
if [ "$ASYNC_PRESENTATION" = "0" ]; then
	sed -i '/^async_presentation=/c\async_presentation=false' /storage/.config/suyu/qt-config.ini
elif [ "$ASYNC_PRESENTATION" = "1" ]; then
	sed -i '/^async_presentation=/c\async_presentation=true' /storage/.config/suyu/qt-config.ini
else
	sed -i '/^async_presentation\\default=/c\async_presentation\\default=true' /storage/.config/suyu/qt-config.ini
fi

#Async Presentation
# Use a dedicated thread for presentation (vulkan only)
sed -i '/^asynchronous_shaders\\default=/c\asynchronous_shaders\\default=false' /storage/.config/suyu/qt-config.ini
if [ "$ASYNC_SHADERS" = "0" ]; then
	sed -i '/^asynchronous_shaders=/c\asynchronous_shaders=false' /storage/.config/suyu/qt-config.ini
elif [ "$ASYNC_SHADERS" = "1" ]; then
	sed -i '/^asynchronous_shaders=/c\asynchronous_shaders=true' /storage/.config/suyu/qt-config.ini
else
	sed -i '/^asynchronous_shaders\\default=/c\asynchronous_shaders\\default=true' /storage/.config/suyu/qt-config.ini
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
if [ "$RUMBLE_STRENGTH" = "100" ]; then
	sed -i '/^player_0_vibration_strength=/c\player_0_vibration_strength=100' /storage/.config/suyu/qt-config.ini
elif [ "$RUMBLE_STRENGTH" = "75" ]; then
		sed -i '/^player_0_vibration_strength=/c\player_0_vibration_strength=75' /storage/.config/suyu/qt-config.ini
elif [ "$RUMBLE_STRENGTH" = "50" ]; then
		sed -i '/^player_0_vibration_strength=/c\player_0_vibration_strength=50' /storage/.config/suyu/qt-config.ini
elif [ "$RUMBLE_STRENGTH" = "25" ]; then
		sed -i '/^player_0_vibration_strength=/c\player_0_vibration_strength=25' /storage/.config/suyu/qt-config.ini
else
	sed -i '/^player_0_vibration_strength\\default=/c\player_0_vibration_strength\\default=true' /storage/.config/suyu/qt-config.ini
fi

#Switch Mode
sed -i '/^use_docked_mode\\default=/c\use_docked_mode\\default=false' /storage/.config/suyu/qt-config.ini
if [ "$SWITCH_MODE" = "0" ]; then
	sed -i '/^use_docked_mode=/c\use_docked_mode=0' /storage/.config/suyu/qt-config.ini
elif [ "$SWITCH_MODE" = "1" ]; then
	sed -i '/^use_docked_mode=/c\use_docked_mode=1' /storage/.config/suyu/qt-config.ini
else
	sed -i '/^use_docked_mode\\default=/c\use_docked_mode\\default=true' /storage/.config/suyu/qt-config.ini
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
