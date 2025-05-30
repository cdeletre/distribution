# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2023 Nicholas Ricciuti (rishooty@gmail.com)
# Copyright (C) 2023 JELOS (https://github.com/JustEnoughLinuxOS)

PKG_NAME="mupen64plus-sa-video-rice"
PKG_VERSION="470865c6c64bdb44645faa88eae59cd87ce561b6"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/mupen64plus/mupen64plus-video-rice"
PKG_URL="https://github.com/mupen64plus/mupen64plus-video-rice/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain libpng SDL2 SDL2_net zlib freetype nasm:host mupen64plus-sa-core"
PKG_LONGDESC="mupen64plus-video-rice"
PKG_LONGDESC="Mupen64Plus Standalone Rice Video Driver"
PKG_TOOLCHAIN="manual"

case ${DEVICE} in
  AMD64|RK3588|S922X|RK3399|RK3566*|SM8250|SM8550)
    PKG_DEPENDS_TARGET+=" mupen64plus-sa-simplecore"
  ;;
esac

case ${DEVICE} in
  AMD64|SM8250|SM8550)
    PKG_DEPENDS_TARGET+=" ${OPENGL} glu libglvnd"
    export USE_GLES=0
  ;;
  *)
    PKG_DEPENDS_TARGET+=" ${OPENGLES}"
    export USE_GLES=1
  ;;
esac

make_target() {

  export HOST_CPU=${TARGET_ARCH} \
         NEW_DYNAREC=1 \
         VFP_HARD=1 \
         V=1 \
         VC=0 \
         OSD=0

  export BINUTILS="$(get_build_dir binutils)/.${TARGET_NAME}"
  export APIDIR=$(get_build_dir mupen64plus-sa-core)/src/api
  export SDL_CFLAGS="-I${SYSROOT_PREFIX}/usr/include/SDL2 -pthread -D_REENTRANT"
  export SDL_LDLIBS="-lSDL2_net -lSDL2"
  export CROSS_COMPILE="${TARGET_PREFIX}"

  sed -i 's/\-O[23]/-Ofast/' ${PKG_BUILD}/projects/unix/Makefile

  make -C projects/unix clean
  make -C projects/unix all ${PKG_MAKE_OPTS_TARGET}
  cp ${PKG_BUILD}/projects/unix/mupen64plus-video-rice.so ${PKG_BUILD}/projects/unix/mupen64plus-video-rice-base.so

  case ${DEVICE} in
    AMD64|RK3588|S922X|RK3399|RK3566*|SM8250|SM8550)
      export APIDIR=$(get_build_dir mupen64plus-sa-simplecore)/src/api
      make -C projects/unix all ${PKG_MAKE_OPTS_TARGET}
      cp ${PKG_BUILD}/projects/unix/mupen64plus-video-rice.so ${PKG_BUILD}/projects/unix/mupen64plus-video-rice-simple.so
    ;;
  esac
}

makeinstall_target() {
  UPREFIX=${INSTALL}/usr/local
  ULIBDIR=${UPREFIX}/lib
  USHAREDIR=${UPREFIX}/share/mupen64plus
  UPLUGINDIR=${ULIBDIR}/mupen64plus
  mkdir -p ${UPLUGINDIR}
  cp ${PKG_BUILD}/projects/unix/mupen64plus-video-rice-base.so ${UPLUGINDIR}/mupen64plus-video-rice.so
  chmod 0644 ${UPLUGINDIR}/mupen64plus-video-rice.so

  if [ -e "${PKG_BUILD}/projects/unix/mupen64plus-video-rice-simple.so" ]
  then
    cp ${PKG_BUILD}/projects/unix/mupen64plus-video-rice-simple.so ${UPLUGINDIR}
    chmod 0644 ${UPLUGINDIR}/mupen64plus-video-rice-simple.so
  fi

  mkdir -p ${USHAREDIR}
  cp ${PKG_BUILD}/data/RiceVideoLinux.ini ${USHAREDIR}
  chmod 0644 ${USHAREDIR}/RiceVideoLinux.ini
}

