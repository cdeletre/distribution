# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="suyu-sa"
PKG_LICENSE="GPLv2"
PKG_DEPENDS_TARGET="toolchain SDL2 boost libevdev libdrm ffmpeg zlib libpng lzo libusb zstd ecm openal-soft pulseaudio alsa-lib llvm qt6 libfmt vulkan-loader vulkan-headers"

PKG_LONGDESC="SuYu is a Switch emulator, allowing you to play games for this platforms on PC with improvements. "
PKG_TOOLCHAIN="cmake"
PKG_SITE="https://git.suyu.dev/suyu/suyu"
PKG_URL="${PKG_SITE}.git"
PKG_VERSION="ee365bad9501c73ff49936e72ec91cd9c3ce5c24"

PKG_CMAKE_OPTS_TARGET+="        -DENABLE_QT6=ON \
                                -DCMAKE_BUILD_TYPE=Release \
                                -DSUYU_ROOM=OFF \
                                -DSUYU_USE_BUNDLED_SDL2=OFF \
                                -DSUYU_USE_BUNDLED_QT=OFF \
                                -DSUYU_TESTS=OFF \
                                -DENABLE_SDL2=ON \
                                -DARCHITECTURE_x86_64=OFF \
                                -DARCHITECTURE_arm64=ON \
                                -DBUILD_SHARED_LIBS=OFF \
																-DENABLE_WEB_SERVICE=OFF \
																-DENABLE_COMPATIBILITY_LIST_DOWNLOAD=ON \
																-DSUYU_USE_BUNDLED_FFMPEG=OFF \
																-DSUYU_USE_EXTERNAL_VULKAN_HEADERS=ON \
																-DSUYU_USE_EXTERNAL_SDL2=ON \
																-DSUYU_USE_FASTER_LD=OFF \
																-DSUYU_USE_PRECOMPILED_HEADERS=ON \
																-DSUYU_USE_QT_MULTIMEDIA=OFF \
																-DSUYU_USE_QT_WEB_ENGINE=OFF \
																-DUSE_DISCORD_PRESENCE=OFF"

pre_configure_target() {
  CFLAGS=$(echo ${CFLAGS} | sed -e "s|-Ofast|-O3|")
  CXXFLAGS=$(echo ${CXXFLAGS} | sed -e "s|-Ofast|-O3|")
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/bin
    cp ${PKG_BUILD}/.${TARGET_NAME}/bin/suyu  ${INSTALL}/usr/bin/
    cp ${PKG_BUILD}/.${TARGET_NAME}/bin/suyu-cmd  ${INSTALL}/usr/bin/
    #cp ${PKG_BUILD}/.${TARGET_NAME}/bin/suyu-room  ${INSTALL}/usr/bin/
		cp -rf ${PKG_DIR}/scripts/* ${INSTALL}/usr/bin
    chmod +x ${INSTALL}/usr/bin/start_suyu.sh

  mkdir -p ${INSTALL}/usr/config/suyu
    cp -rf ${PKG_DIR}/config/${DEVICE}/* ${INSTALL}/usr/config/suyu
}
