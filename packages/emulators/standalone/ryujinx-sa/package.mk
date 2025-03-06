PKG_NAME="ryujinx-sa"
PKG_LICENSE="MIT"
PKG_DEPENDS_TARGET="toolchain SDL2 dotnet:host"

PKG_SITE="https://github.com/Ryubing/Ryujinx"
PKG_URL="${PKG_SITE}.git"
PKG_VERSION="a23c6bf547320a1abbeb1680fe595244b115ebc0"

PKG_LONGDESC="Ryujinx switch emulator"
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  # Disable stripping of the binary
  # Ryujinx won"t run otherwise
  export STRIP=false

  dotnet publish -r linux-arm64 -c Release --self-contained true -o .${TARGET_NAME}

  mkdir -p ${INSTALL}/usr/bin
  mkdir -p ${INSTALL}/usr/lib


  cp -rf ${PKG_DIR}/scripts/* ${INSTALL}/usr/bin
  chmod +x ${INSTALL}/usr/bin/start_ryujinx.sh

  cp ${PKG_BUILD}/.${TARGET_NAME}/Ryujinx ${INSTALL}/usr/bin
  chmod 755 ${INSTALL}/usr/bin/Ryujinx
  rm ${PKG_BUILD}/.${TARGET_NAME}/libSDL2.so
  cp ${PKG_BUILD}/.${TARGET_NAME}/lib*.so ${INSTALL}/usr/lib

  mkdir -p ${INSTALL}/usr/config/Ryujinx
  cp -rf ${PKG_DIR}/config/${DEVICE}/* ${INSTALL}/usr/config/Ryujinx

}
